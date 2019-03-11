
//
//  PhotoEditView.m
//  PhotoT
//
//  Created by apple on 2019/3/6.
//  Copyright © 2019 apple. All rights reserved.
//

#import "ZFPhotoEditView.h"
#import "ShaderProgramHandler.h"

typedef NS_ENUM(GLuint,VertexAttrib) {
    VertexAttribPosition,
    VertexAttribCoordinate,
};

@interface ZFPhotoEditView(){
    GLuint textureID;
    CGRect viewPortframe;
    CGContextRef cgcontext;
}
@property (strong,nonatomic) UIImageView *imageView;

@property (strong,nonatomic) CAEAGLLayer *eaglLayer;
@property (strong ,nonatomic) EAGLContext *context;

@property (assign,nonatomic) GLuint frameBuffer;
@property (assign,nonatomic) GLuint renderBuffer;

@property(assign,nonatomic) GLuint coordinateBuffer;

@property(strong ,nonatomic) ShaderProgramHandler *shaderHandler;

@end

@implementation ZFPhotoEditView

- (instancetype)initWithFrame:(CGRect)frame{
    if (self = [super initWithFrame:frame]) {
    
    }
    return self;
}

- (void)setup{
    [self setupLayer];
    [self setupContext];
    [self setupBuffer];
    [self setupTexture:_image];
    [self setShaderIndex:0];
}

//渲染
- (void)render{
    glDrawArrays(GL_TRIANGLE_STRIP, 0, 4);
    [_context presentRenderbuffer:GL_RENDERBUFFER];
}

//默认原图
- (void)setDefaultData{
    GLuint textureMap = glGetUniformLocation(self.shaderHandler.defaultProgram, "textureMap");
    glUniform1i(textureMap,0);
}

//色温数据
- (void)setTempData{
   
    GLuint textureMap = glGetUniformLocation(self.shaderHandler.tempProgram, "textureMap");
    glUniform1i(textureMap,0);
    
    GLuint temperature = glGetUniformLocation(self.shaderHandler.tempProgram, "temperature");
    glUniform1f(temperature, self.sliderValue);
}

//饱和度数据
- (void)setSatuData{
    GLuint textureMap = glGetUniformLocation(self.shaderHandler.satProgram, "textureMap");
    glUniform1i(textureMap,0);
    
    GLuint temperature = glGetUniformLocation(self.shaderHandler.satProgram, "saturation");
    glUniform1f(temperature, self.sliderValue);
}

//曝光度数据
- (void)setExposureData{
    GLuint textureMap = glGetUniformLocation(self.shaderHandler.exposureProgram, "textureMap");
    glUniform1i(textureMap,0);
    
    GLuint temperature = glGetUniformLocation(self.shaderHandler.exposureProgram, "exposure");
    glUniform1f(temperature, self.sliderValue);
}

//亮度数据
- (void)setBrightnessData{
    GLuint textureMap = glGetUniformLocation(self.shaderHandler.brightnessProgram, "textureMap");
    glUniform1i(textureMap,0);
    
    GLuint temperature = glGetUniformLocation(self.shaderHandler.brightnessProgram, "brightness");
    glUniform1f(temperature, self.sliderValue);
}


//设置视口大小
- (void )setupView{
    glViewport(0, 0, self.frame.size.width * self.contentScaleFactor, self.frame.size.height * self.contentScaleFactor);
    glClearColor(1, 0, 0, 1);
    glClear(GL_COLOR_BUFFER_BIT);
}

- (void)setupBuffer{
    
    if (_renderBuffer) {
        glDeleteRenderbuffers(1, &_renderBuffer);
        _renderBuffer = 0;
    }
    
    //渲染缓冲区
    glGenRenderbuffers(1, &_renderBuffer);
    glBindRenderbuffer(GL_RENDERBUFFER, _renderBuffer);
    [_context renderbufferStorage: GL_RENDERBUFFER fromDrawable:_eaglLayer];
    
    if (_frameBuffer) {
        glDeleteFramebuffers(1, &_frameBuffer);
        _frameBuffer = 0;
    }
    
    //帧缓冲区
    glGenFramebuffers(1, &_frameBuffer);
    glBindFramebuffer(GL_FRAMEBUFFER, _frameBuffer);
    glFramebufferRenderbuffer(GL_FRAMEBUFFER, GL_COLOR_ATTACHMENT0, GL_RENDERBUFFER, _renderBuffer);
}

- (void)setupLayer{
    //渲染图层
    _eaglLayer = (CAEAGLLayer*)self.layer;
    _eaglLayer.drawableProperties = [NSDictionary dictionaryWithObjectsAndKeys:[NSNumber numberWithBool:false],kEAGLDrawablePropertyRetainedBacking,kEAGLColorFormatRGBA8,kEAGLDrawablePropertyColorFormat, nil];
    _eaglLayer.opaque = YES;
}

-(void)setupContext{
    //设置上下文
    _context = [[EAGLContext alloc] initWithAPI:(kEAGLRenderingAPIOpenGLES3)];
    if (![EAGLContext setCurrentContext:_context]) {
        NSLog(@"context 设置失败");
          return;
    }
    NSLog(@"context 设置成功");
}

+ (Class)layerClass{
    return [CAEAGLLayer class];
}

- (void)setImage:(UIImage *)image{
    _image = image;
    [self setup];
}

- (void)setupTexture:(UIImage*)image{
    
    //1.获取图片宽\高
    size_t width = CGImageGetWidth(image.CGImage);
    size_t height = CGImageGetHeight(image.CGImage);
    
    
    //2.获取颜色组件
    CGColorSpaceRef colorSpace = CGColorSpaceCreateDeviceRGB();
    
    //3.计算图片数据大小->开辟空间
    void *imageData = malloc( height * width * 4 );
    //CG开头的方法都是来自于CoreGraphics这个框架
    //了解CoreGraphics 框架
    
    //创建位图context
    /*
     CGBitmapContextCreate(void * __nullable data,
     size_t width, size_t height, size_t bitsPerComponent, size_t bytesPerRow,
     CGColorSpaceRef cg_nullable space, uint32_t bitmapInfo)
     参数列表:
     1.data,指向要渲染的绘制内存的地址
     2.width,bitmap的宽度,单位为像素
     3.height,bitmap的高度,单位为像素
     4.bitsPerComponent, 内存中像素的每个组件的位数.例如，对于32位像素格式和RGB 颜色空间，你应该将这个值设为8.
     5.bytesPerRow, bitmap的每一行在内存所占的比特数
     6.colorspace, bitmap上下文使用的颜色空间
     7.bitmapInfo,指定bitmap是否包含alpha通道，像素中alpha通道的相对位置，像素组件是整形还是浮点型等信息的字符串。
     */
    
    cgcontext = CGBitmapContextCreate(imageData,
                                                 width,
                                                 height,
                                                 8,
                                                 4 * width,
                                                 colorSpace,
                                                 kCGImageAlphaPremultipliedLast | kCGBitmapByteOrder32Big);
    //创建完context,可以释放颜色空间colorSpace
    CGColorSpaceRelease( colorSpace );
    
    /*
     绘制透明矩形。如果所提供的上下文是窗口或位图上下文，则核心图形将清除矩形。对于其他上下文类型，核心图形以设备依赖的方式填充矩形。但是，不应在窗口或位图上下文以外的上下文中使用此函数
     CGContextClearRect(CGContextRef cg_nullable c, CGRect rect)
     参数:
     1.C,绘制矩形的图形上下文。
     2.rect,矩形，在用户空间坐标中。
     */
    CGContextClearRect( cgcontext, CGRectMake( 0, 0, width, height ) );
    //CTM--从用户空间和设备空间存在一个转换矩阵CTM
    /*
     CGContextTranslateCTM(CGContextRef cg_nullable c,
     CGFloat tx, CGFloat ty)
     参数1:上下文
     参数2:X轴上移动距离
     参数3:Y轴上移动距离
     */
    CGContextTranslateCTM(cgcontext, 0, height);
    //缩小
    CGContextScaleCTM (cgcontext, 1.0,-1.0);
    
    //绘制图片
    CGContextDrawImage( cgcontext, CGRectMake( 0, 0, width, height ), image.CGImage );
    
    //释放context
    CGContextRelease(cgcontext);
    //在绑定纹理之前,激活纹理单元 glActiveTexture
    glActiveTexture(GL_TEXTURE0);
    
    //生成纹理标记
    glGenTextures(1, &textureID);
    
    //绑定纹理
    glBindTexture(GL_TEXTURE_2D, textureID);
    
    
    //设置纹理参数
    //环绕方式
    glTexParameteri(GL_TEXTURE_2D, GL_TEXTURE_WRAP_S, GL_CLAMP_TO_EDGE);
    glTexParameteri(GL_TEXTURE_2D, GL_TEXTURE_WRAP_T, GL_CLAMP_TO_EDGE);
    
    //放大\缩小过滤
    glTexParameteri(GL_TEXTURE_2D, GL_TEXTURE_MIN_FILTER,GL_LINEAR);
    glTexParameteri(GL_TEXTURE_2D, GL_TEXTURE_MAG_FILTER,GL_LINEAR);
    
    //将图片载入纹理
    /*
     glTexImage2D (GLenum target, GLint level, GLint internalformat, GLsizei width, GLsizei height, GLint border, GLenum format, GLenum type, const GLvoid *pixels)
     参数列表:
     1.target,目标纹理
     2.level,一般设置为0
     3.internalformat,纹理中颜色组件
     4.width,纹理图像的宽度
     5.height,纹理图像的高度
     6.border,边框的宽度
     7.format,像素数据的颜色格式
     8.type,像素数据数据类型
     9.pixels,内存中指向图像数据的指针
     */
    glTexImage2D(GL_TEXTURE_2D,
                 0,
                 GL_RGBA,
                 (GLint)width,
                 (GLint)height,
                 0,
                 GL_RGBA,
                 GL_UNSIGNED_BYTE,
                 imageData);
    
    //释放imageData
    free(imageData);
}

//当前选中的shader
- (void)setShaderIndex:(NSInteger)shaderIndex{
    [self setupView];
    
    if (_shaderIndex != shaderIndex) {
        switch (shaderIndex) {
            case 0:
                [self.shaderHandler loadDefaultProgram];//默认原图
                break;
            case 1:
                [self.shaderHandler loadTemperatureProgram];
                break;
            case 2:
                [self.shaderHandler loadSaturabilityProgram];
                break;
                
            case 3:
                [self.shaderHandler loadExposureProgram];
                break;
                
            case 4:
                [self.shaderHandler loadBrightnessProgram];
                break;
        }
    }
    
    switch (shaderIndex) {
        case 0:
            //默认原图
            [self setDefaultData];
            break;
        case 1:
            [self setTempData];
            break;
        case 2:
            [self setSatuData];
            break;
            
        case 3:
            [self setExposureData];
            break;
            
        case 4:
            [self setBrightnessData];
            break;
    }
    _shaderIndex = shaderIndex;
    [self render];
}

#pragma mark ===== 保存图片
- (UIImage*)snapshotInternalOnIOS7AndLater{
    
    UIGraphicsBeginImageContextWithOptions(self.bounds.size, NO, 0.0);
    // Render our snapshot into the image context
    [self drawViewHierarchyInRect:self.bounds afterScreenUpdates:NO];
    // Grab the image from the context
    UIImage *complexViewImage = UIGraphicsGetImageFromCurrentImageContext();
    // Finish using the context
    UIGraphicsEndImageContext();
    
    return complexViewImage;
}

- (void)saveImage{
    UIImage *currentImage = [self snapshotInternalOnIOS7AndLater];
    if (currentImage) {
        UIImageWriteToSavedPhotosAlbum(currentImage, self, @selector(image:didFinishSavingWithError:contextInfo:), NULL);
    }
}

- (void)image:(UIImage *)image didFinishSavingWithError:(NSError *)error contextInfo:(void *)contextInfo {
    if (error) {
        showSuccessMessage(@"图片保存失败");
    }else{
        showSuccessMessage(@"图片已保存");
    }
}

#pragma mark lazy load
- (UIImageView *)imageView{
    if (!_imageView) {
        _imageView = [UIImageView new];
    }
    return _imageView;
}

- (ShaderProgramHandler*)shaderHandler{
    if (!_shaderHandler) {
        _shaderHandler = [ShaderProgramHandler new];
    }
    return _shaderHandler;
}

- (void)dealloc{
    _shaderHandler = nil;
    
}
@end
