//
//  Photo3DController.m
//  PhotoT
//
//  Created by apple on 2019/3/11.
//  Copyright © 2019 apple. All rights reserved.
//

#import "ZFPhoto3DController.h"

#import "sphere.h"

@interface ZFPhoto3DController ()
{
    CGFloat yrot;
    CGFloat xrot;
    
    CGPoint currentPoint;
    CGPoint lastPoint;
    
    BOOL isRotY;
}
@property (strong ,nonatomic) UIImage *image;
@property (strong ,nonatomic) EAGLContext *context;
@property (strong ,nonatomic) GLKBaseEffect *effect;
@property (assign ,nonatomic) GLKMatrixStackRef matrixStack;
@end

@implementation ZFPhoto3DController

- (void)viewDidLoad{
    [super viewDidLoad];
    
    [self setupContext];
    [self setupEffect];
    [self setupBuffer];
    [self setupMatrix];
    
    self.view.userInteractionEnabled = YES;
    
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithActionBlock:^(id  _Nonnull sender) {
        [self.navigationController popViewControllerAnimated:YES];
    }];
    tap.numberOfTapsRequired = 2;
    [self.view addGestureRecognizer:tap];
}

- (void)setupContext{
    _context = [[EAGLContext alloc] initWithAPI:(kEAGLRenderingAPIOpenGLES3)];
    
    GLKView *view = (GLKView*)self.view;
    
    view.drawableColorFormat = GLKViewDrawableColorFormatRGBA8888;
    view.drawableDepthFormat = GLKViewDrawableDepthFormat24;
    view.context = _context;
    
    [EAGLContext setCurrentContext:_context];
    
    glEnable(GL_DEPTH_TEST);
}

- (void)setupEffect{
    NSDictionary *options = @{GLKTextureLoaderOriginBottomLeft:@(YES)};
    GLKTextureInfo *info = [GLKTextureLoader textureWithCGImage:self.image.CGImage options:options error:nil];
    
    _effect = [[GLKBaseEffect alloc] init];
    _effect.texture2d0.enabled = YES;
    _effect.texture2d0.name = info.name;
    
    [self setupLight];
}


//光照信息
- (void)setupLight{
    //开启光照
    _effect.light0.enabled = GL_TRUE;
    
    /*
     union _GLKVector4
     {
     struct { float x, y, z, w; };
     struct { float r, g, b, a; };
     struct { float s, t, p, q; };
     float v[4];
     } __attribute__((aligned(16)));
     typedef union _GLKVector4 GLKVector4;
     
     union共用体
     有3个结构体，
     比如表示顶点坐标的x,y,z,w
     比如表示颜色的，RGBA;
     表示纹理的stpq
     
     */
    //2.设置漫射光颜色
    _effect.light0.diffuseColor = GLKVector4Make(
                                                1.00f,//Red
                                                1.0f,//Green
                                                1.0f,//Blue
                                                1.0f);//Alpha
    /*
     The position of the light in world coordinates.
     世界坐标中的光的位置。
     If the w component of the position is 0.0, the light is calculated using the directional light formula. The x, y, and z components of the vector specify the direction the light shines. The light is assumed to be infinitely far away; attenuation and spotlight properties are ignored.
     如果位置的w分量为0，则使用定向光公式计算光。向量的x、y和z分量指定光的方向。光被认为是无限远的，衰减和聚光灯属性被忽略。
     If the w component of the position is a non-zero value, the coordinates specify the position of the light in homogenous coordinates, and the light is either calculated as a point light or a spotlight, depending on the value of the spotCutoff property.
     如果该位置的W组件是一个非零的值，指定的坐标的光在齐次坐标的位置，和光是一个点光源和聚光灯计算，根据不同的spotcutoff属性的值
     The default value is [0.0, 0.0, 1.0, 0.0].
     默认值[0.0f,0.0f,1.0f,0.0f];
     */
    
    _effect.light0.position = GLKVector4Make(
                                            1.0f, //x
                                            0.5f, //y
                                            0.8f, //z
                                            0.0f);//w
    
    //光的环境部分
    _effect.light0.ambientColor = GLKVector4Make(
                                                0.0f,//Red
                                                0.0f,//Green
                                                0.0f,//Blue
                                                1.0f);//Alpha
    
}
- (void)setupBuffer{
    
    //开启文理顶点数据读取
    GLuint vertextBuffer,normalBuffer;
    
    glGenBuffers(1, &vertextBuffer);
    glBindBuffer(GL_ARRAY_BUFFER, vertextBuffer);
    glBufferData(GL_ARRAY_BUFFER, sizeof(sphereVerts), sphereVerts, GL_DYNAMIC_DRAW);
    
    glEnableVertexAttribArray(GLKVertexAttribPosition);
    glVertexAttribPointer(GLKVertexAttribPosition, 3, GL_FLOAT, GL_FALSE, sizeof(GLfloat)*3, (GLfloat*)NULL+0);
    
    //文理坐标
    GLuint textureCoordinate;
    glGenBuffers(1, &textureCoordinate);
    glBindBuffer(GL_ARRAY_BUFFER, textureCoordinate);
    glBufferData(GL_ARRAY_BUFFER, sizeof(sphereTexCoords), sphereTexCoords, GL_STATIC_DRAW);
    
    glEnableVertexAttribArray(GLKVertexAttribTexCoord0);
    glVertexAttribPointer(GLKVertexAttribTexCoord0, 2, GL_FLOAT, GL_FALSE, sizeof(GLfloat)*2, (GLfloat*)NULL+0);
    
    //法线
    glGenBuffers(1, &normalBuffer);
    glBindBuffer(GL_ARRAY_BUFFER, normalBuffer);
    glBufferData(GL_ARRAY_BUFFER, sizeof(sphereNormals), sphereNormals, GL_STATIC_DRAW);
    
    glEnableVertexAttribArray(GLKVertexAttribNormal);
    glVertexAttribPointer(GLKVertexAttribNormal, 3, GL_FLOAT, GL_FALSE, sizeof(GLfloat)*3, NULL);
    
}

- (void)setupMatrix{
    _effect.transform.modelviewMatrix = GLKMatrix4MakeTranslation(0, 0, -5);
    
    CGFloat aspect = self.view.frame.size.width/self.view.frame.size.height;

    _effect.transform.projectionMatrix = GLKMatrix4MakePerspective(GLKMathDegreesToRadians(35), aspect, 1, 12);
    
    _matrixStack = GLKMatrixStackCreate(kCFAllocatorDefault);
    GLKMatrixStackLoadMatrix4(_matrixStack,_effect.transform.modelviewMatrix);
}

- (void)glkView:(GLKView *)view drawInRect:(CGRect)rect{
    
    glClearColor(0, 0, 0, 1);
    glClear(GL_COLOR_BUFFER_BIT|GL_DEPTH_BUFFER_BIT);
    
//    yrot += (360/60.0/10);
    
    GLKMatrixStackPush(_matrixStack);

    CGFloat currentX = 0,currentY = 0;
    if (!CGPointEqualToPoint(currentPoint, lastPoint)) {
        currentX = currentPoint.x - lastPoint.x;
        currentY = currentPoint.y - lastPoint.y;
        xrot += currentY;
        yrot += currentX;
    }
    
    GLKMatrixStackRotateY(_matrixStack, GLKMathDegreesToRadians(yrot));
    GLKMatrixStackRotateX(_matrixStack, GLKMathDegreesToRadians(xrot));
    _effect.transform.modelviewMatrix = GLKMatrixStackGetMatrix4(_matrixStack);
    
    //绘制
    [_effect prepareToDraw];
    glDrawArrays(GL_TRIANGLES, 0, sphereNumVerts);
    GLKMatrixStackPop(_matrixStack);
    
    _effect.transform.modelviewMatrix = GLKMatrixStackGetMatrix4(_matrixStack);
}

- (void)touchesMoved:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    currentPoint = [[touches anyObject] locationInView:self.view];
    lastPoint = [[touches anyObject] previousLocationInView:self.view];
}

- (void)touchesEnded:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    lastPoint = currentPoint = CGPointZero;
}

- (void)touchesCancelled:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    lastPoint = currentPoint = CGPointZero;
}

@end
