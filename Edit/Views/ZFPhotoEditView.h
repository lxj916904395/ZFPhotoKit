//
//  PhotoEditView.h
//  PhotoT
//
//  Created by apple on 2019/3/6.
//  Copyright © 2019 apple. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface ZFPhotoEditView : UIView
@property (strong, nonatomic) UIImage *image;

@property (assign, nonatomic) CGFloat sliderValue;//滑竿值
@property (assign ,nonatomic) NSInteger shaderIndex;//第几个shader

- (void)saveImage;
@end

NS_ASSUME_NONNULL_END
