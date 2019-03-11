//
//  PhotoBrowser.h
//  PhotoT
//
//  Created by apple on 2019/3/6.
//  Copyright © 2019 apple. All rights reserved.
//

#import "ZFViewController.h"

NS_ASSUME_NONNULL_BEGIN

@interface ZFPhotoBrowser : ZFViewController

+ (UIViewController*)showWithSource:(UIImageView*)sourceView originalImage:(UIImage*)originalImage;

@end

NS_ASSUME_NONNULL_END
