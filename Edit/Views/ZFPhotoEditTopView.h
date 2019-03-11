//
//  PhotoEditTopView.h
//  PhotoT
//
//  Created by apple on 2019/3/8.
//  Copyright © 2019 apple. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface ZFPhotoEditTopView : UIView

@property (copy ,nonatomic) void(^saveImageBlock)(void);
@property (copy ,nonatomic) void(^backBlock)(void);

@end

NS_ASSUME_NONNULL_END
