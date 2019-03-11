//
//  PhotoView.h
//  PhotoT
//
//  Created by apple on 2019/3/4.
//  Copyright © 2019 apple. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@protocol PhotoViewDelegate ;
@interface ZFPhotoView : UIScrollView

@property (strong,nonatomic) UIImage *originalImage;//原图
@property (strong,nonatomic) UIImage *thumblImage;//缩略图

@property (strong,nonatomic) UIImageView *sourceView;//来源视图
@property (assign ,nonatomic) CGRect originRect;//来源视图的坐标

@property (weak,nonatomic) id<PhotoViewDelegate> delegate;

+ (instancetype)showWithSource:(UIImageView*)sourceView originalImage:(UIImage*)originalImage delegate:(id<PhotoViewDelegate>)delegate;
- (void)showInView:(UIView*)view;
@end

@protocol PhotoViewDelegate <NSObject>
//显示动画完成
- (void)photoViewDidShowAnimatedFinish;
- (void)photoViewDidSelect3Dmage:(UIImage *)image;
- (void)photoViewDidEditImage:(UIImage *)image;
- (void)photoViewDidRemove;

@end


NS_ASSUME_NONNULL_END
