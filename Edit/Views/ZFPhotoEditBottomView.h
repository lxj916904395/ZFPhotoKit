//
//  PhotoEditBottomView.h
//  PhotoT
//
//  Created by apple on 2019/3/6.
//  Copyright © 2019 apple. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface ZFPhotoEditBottomView : UIView

@property (copy ,nonatomic) void (^sliderValueChangeBlock)(CGFloat value,NSInteger shaderIndex);
@property (copy ,nonatomic) void (^shaderStyleBlock)(NSString *shaderName);

@property (assign ,nonatomic) NSInteger currentShaderIndex;
@property (assign, nonatomic) CGFloat itemH;
@property (assign, nonatomic) CGFloat itemOffset;
@property (assign, nonatomic) CGFloat sliderSize;


@end

NS_ASSUME_NONNULL_END
