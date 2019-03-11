//
//  PhotoShader.h
//  PhotoT
//
//  Created by apple on 2019/3/6.
//  Copyright © 2019 apple. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <OpenGLES/ES3/gl.h>

typedef NS_ENUM(NSInteger,ShaderProgram) {
    
    ShaderProgramDefault,
    ShaderProgramTemp,//色温
    ShaderProgramSatu,//饱和度
};

NS_ASSUME_NONNULL_BEGIN

@interface ShaderProgramHandler : NSObject
//默认program
@property (assign ,nonatomic) GLuint defaultProgram;

//色温program
@property (assign ,nonatomic) GLuint tempProgram;
//饱和度program
@property (assign ,nonatomic) GLuint satProgram;

//曝光度program
@property (assign ,nonatomic) GLuint exposureProgram;

//亮度program
@property (assign ,nonatomic) GLuint brightnessProgram;


//获取默认program
- (void)loadDefaultProgram;

//获取色温program
- (void)loadTemperatureProgram;

//获取饱和度program
- (void)loadSaturabilityProgram;

//获取曝光度program
- (void)loadExposureProgram;

//获取亮度program
- (void)loadBrightnessProgram;

@end

NS_ASSUME_NONNULL_END
