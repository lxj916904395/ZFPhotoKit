//
//  PhotoBottomView.h
//  PhotoT
//
//  Created by apple on 2019/3/6.
//  Copyright © 2019 apple. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN
@protocol PhotoBottomViewDelegate ;

@interface ZFPhotoBottomView : UIView
@property (weak, nonatomic) IBOutlet UIButton *editBtn;
@property(weak,nonatomic) id<PhotoBottomViewDelegate>delegate;

- (void)hiden;

- (void)show;
@end


@protocol PhotoBottomViewDelegate<NSObject>

- (void)photoBottomViewDidSelectEdit;
- (void)photoBottomViewDidSelect3D;

@end
NS_ASSUME_NONNULL_END
