//
//  PhotoPermission.h
//  PhotoT
//
//  Created by apple on 2019/3/1.
//  Copyright © 2019 apple. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ZFPhotoTool.h"

NS_ASSUME_NONNULL_BEGIN

@interface ZFPhotoPermission : NSObject

+(BOOL)detectionPhotoState:(void(^)(void))authorizedBlock;

@end

NS_ASSUME_NONNULL_END
