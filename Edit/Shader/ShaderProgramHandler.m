//
//  PhotoShader.m
//  PhotoT
//
//  Created by apple on 2019/3/6.
//  Copyright © 2019 apple. All rights reserved.
//

#import "ShaderProgramHandler.h"

@interface ShaderProgramHandler ()
{
    GLuint _vertextShader;
}
@end
@implementation ShaderProgramHandler
- (instancetype)init{
    if (self = [super init]) {
        [self compileVertexShader];
        [self loadDefaultProgram];
    }
    return self;
}

//获取默认顶点shader
- (void)compileVertexShader{
    NSString *vertexPath = [[NSBundle mainBundle] pathForResource:@"shader" ofType:@"vsh"];
    [self compileShader:&_vertextShader type:GL_VERTEX_SHADER path:vertexPath];
}

//获取默认program
- (void)loadDefaultProgram{
    NSString *fragmentPath = [[NSBundle mainBundle] pathForResource:@"shader" ofType:@"fsh"];
    if (! [self loadProgramWithfragment:fragmentPath program:&_defaultProgram]) {
        return;
    };
}

//获取色温program
- (void)loadTemperatureProgram{
    NSString *fragmentPath = [[NSBundle mainBundle] pathForResource:@"shadertemp" ofType:@"fsh"];
    if (! [self loadProgramWithfragment:fragmentPath program:&_tempProgram]) {
        return;
    };
}

//获取饱和度program
- (void)loadSaturabilityProgram{
    NSString *fragmentPath = [[NSBundle mainBundle] pathForResource:@"shadersat" ofType:@"fsh"];
    if (! [self loadProgramWithfragment:fragmentPath program:&_satProgram]) {
        return;
    };
}

//获取曝光度program
- (void)loadExposureProgram{
    NSString *fragmentPath = [[NSBundle mainBundle] pathForResource:@"shader_exposure" ofType:@"fsh"];
    if (! [self loadProgramWithfragment:fragmentPath program:&_exposureProgram]) {
        return;
    };
}

//获取亮度program
- (void)loadBrightnessProgram{
    NSString *fragmentPath = [[NSBundle mainBundle] pathForResource:@"shader_brightness" ofType:@"fsh"];
    if (! [self loadProgramWithfragment:fragmentPath program:&_brightnessProgram]) {
        return;
    };
}

- (BOOL)loadProgramWithfragment:(NSString*)fragmentPath program:(GLuint*)program{
    GLuint fragmentShader;
    if (![self compileShader:&fragmentShader type:GL_FRAGMENT_SHADER path:fragmentPath])
        return NO;
    
    *program = glCreateProgram();
    
    //把shader 与program 关联
    glAttachShader(*program, _vertextShader);
    glAttachShader(*program, fragmentShader);
    
    //链接
    glLinkProgram(*program);
    
    //获取链接状态
    GLint linkstatus;
    glGetProgramiv(*program, GL_LINK_STATUS, &linkstatus);
    if (linkstatus != GL_TRUE) {
        //错误日志
        GLint loglength;
        glGetProgramiv(*program, GL_INFO_LOG_LENGTH, &loglength);
        GLchar *message = malloc(loglength);
        glGetProgramInfoLog(*program, loglength, &loglength, message);
        NSLog(@"program 链接出错:%s",message);
        return NO;
    }
    //删除shader
    glDeleteShader(fragmentShader);
    
    glUseProgram(*program);
    
    [self setupVBO];
    [self setShaderAttrib:*program];
    return YES;
}

- (void)setupVBO{
    GLuint vertexBuffer;
    //顶点坐标数据
    GLfloat vertexs[] = {
        -1,-1,0,   0,0,
        1,-1,0,     1,0,
        -1,1,0,   0,1,
        1,1,0,      1,1
    };
    glGenBuffers(1, &vertexBuffer);
    glBindBuffer(GL_ARRAY_BUFFER, vertexBuffer);
    glBufferData(GL_ARRAY_BUFFER, sizeof(vertexs), vertexs, GL_DYNAMIC_DRAW);
}

- (void)setShaderAttrib:(GLuint)program{
    //获取顶点着色器属性position
    GLuint attribPosition = glGetAttribLocation(program, "position");
    //开启position读取，
    glEnableVertexAttribArray(attribPosition);
    //position数据读取格式
    glVertexAttribPointer(attribPosition, 3, GL_FLOAT, GL_FALSE, sizeof(GLfloat)*5, (GLfloat*)NULL+0);
    
    GLuint attribCoordinate = glGetAttribLocation(program, "textureCoordinate");
    glEnableVertexAttribArray(attribCoordinate);
    glVertexAttribPointer(attribCoordinate, 2, GL_FLOAT, GL_FALSE, sizeof(GLfloat)*5, (GLfloat*)NULL+3);
}

//编译shader
- (BOOL)compileShader:(GLuint*)shader type:(GLenum)type path:(NSString*)path{
    NSString *content = [NSString stringWithContentsOfFile:path encoding:NSUTF8StringEncoding error:nil];
    if (!content.length ) {
        NSLog(@"shader 无内容");
        return NO;
    }
    //转化为c字符串
   const GLchar *source = (GLchar*)[content UTF8String];
    
    *shader = glCreateShader(type);
    //绑定shader内容
    glShaderSource(*shader, 1, &source, NULL);
    //编译shader
    glCompileShader(*shader);
    
    GLint loglength;
    glGetShaderiv(*shader, GL_INFO_LOG_LENGTH, &loglength);
    if (loglength) {
        GLchar *message = malloc(loglength);
        glGetShaderInfoLog(*shader, loglength, &loglength, message);
        NSLog(@"shader 编译出错: %s",message);
        return NO;
    }
    return YES;
}


- (void)dealloc{
    
    if (_defaultProgram) {
        glDeleteProgram(_defaultProgram);
    }
    _defaultProgram = 0;
    
    if (_tempProgram) {
        glDeleteProgram(_tempProgram);
    }
    _tempProgram = 0;
    
    if (_satProgram) {
        glDeleteProgram(_satProgram);
    }
    _satProgram = 0;
    
    if (_exposureProgram) {
        glDeleteProgram(_exposureProgram);
    }
    _exposureProgram = 0;
    
}
@end
