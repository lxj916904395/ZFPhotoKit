//
//  PhotoView.m
//  PhotoT
//
//  Created by apple on 2019/3/4.
//  Copyright © 2019 apple. All rights reserved.
//

#import "ZFPhotoView.h"
#import "ZFPhotoImageView.h"
#import "ZFPhotoBottomView.h"

@interface ZFPhotoView()<UIScrollViewDelegate,PhotoBottomViewDelegate>{

}
@property (strong ,nonatomic) ZFPhotoImageView *tapImageView;
@property (strong ,nonatomic) ZFPhotoBottomView *bottomView;
@end

@implementation ZFPhotoView

+ (instancetype)showWithSource:(UIImageView*)sourceView originalImage:(UIImage*)originalImage delegate:(id<PhotoViewDelegate>)delegate{
    ZFPhotoView *photoView = [ZFPhotoView new];
    photoView.originalImage = originalImage;
    photoView.sourceView = sourceView;
    photoView.delegate = delegate;
    return photoView;
}

- (instancetype)initWithFrame:(CGRect)frame{
    if (self = [super initWithFrame:frame]) {
        [self setupView];
    }
    return self;
}

- (instancetype)init{
    if (self  = [super init]) {
        [self setupView];
    }
    return self;
}


- (void)setupView{
    [self setFrame:CGRectMake(0, 0, kScreenWidth, kScreenHeight)];
   
    self.userInteractionEnabled = YES;
    self.showsHorizontalScrollIndicator = NO;
    self.showsVerticalScrollIndicator = NO;
    //设置最大放大倍数
    self.minimumZoomScale = 1.0;
    self.maximumZoomScale = 2.0;
    self.bottomView.alpha = self.alpha = 0;

    _tapImageView = [[ZFPhotoImageView alloc] init];
    _tapImageView.backgroundColor = [UIColor blackColor];
    [self addSubview:self.tapImageView];
    
    [self setupTapGesture];
}

- (void)setupTapGesture{
    //单击
    UITapGestureRecognizer *tap1 = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(singleTap:)];
    tap1.numberOfTapsRequired = 1;
    [self addGestureRecognizer:tap1];
    
    //双击
    UITapGestureRecognizer *tap2 = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(doubleTapAction:)];
    tap2.numberOfTapsRequired = 2;
    [self addGestureRecognizer:tap2];
    
    [tap1 requireGestureRecognizerToFail:tap2];
}

#pragma mark ************* 显示、隐藏
- (void)showInView:(UIView *)view{
    view.userInteractionEnabled = YES;
    
    [view addSubview:self];
    [self.superview addSubview:self.bottomView];
    self.backgroundColor = [UIColor clearColor];;
    //点击的图片相对于keywindow的坐标
    self.originRect = [self loadOriginFrame:self.sourceView frame:self.sourceView.frame];
    //从原始图片位置开始动画
    self.tapImageView.image = self.sourceView.image;
    
    self.tapImageView.frame = self.originRect;
    
    [self showAnimate];
}

- (CGRect)loadOriginFrame:(UIView *)view frame:(CGRect)rect{
    while (view.superview) {
        rect = [view convertRect:rect toView:view.superview];
        view = view.superview;
    }
    return rect;
}

- (void)showAnimate{
 
    [UIView animateWithDuration:0.25 animations:^{
        //最终显示坐标
        self.tapImageView.size = CGSizeMake(kScreenWidth, self.originalImage.size.height*kScreenWidth/self.originalImage.size.width);

        self.tapImageView.center = self.center;
        self.bottomView.alpha =  self.alpha = 1;
        self.backgroundColor =  self.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:1];
        [self.bottomView show];
    } completion:^(BOOL finished) {
        //动画完成显示原图
        if (self.originalImage) {
            self.tapImageView.image = self.originalImage;
        }
        APPDelegate(self.delegate, PhotoViewDelegate, photoViewDidShowAnimatedFinish);

    }];
}

//隐藏
- (void)remove{
    
    if (self.zoomScale >1) {
        [self zoomToRect:CGRectMake(0, 0, kScreenWidth, kScreenHeight) animated:YES];
    }
    
    [UIView animateWithDuration:0.25 animations:^{
        self.tapImageView.frame = self.originRect;
        self.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0];
        
        [self.bottomView hiden];
    } completion:^(BOOL finished) {
        [self.bottomView removeFromSuperview];
        [self removeFromSuperview];

        APPDelegate(self.delegate, PhotoViewDelegate, photoViewDidRemove);
    }];
}

- (void)isHidenBottom{
    if (self.bottomView.alpha<1) {
        [UIView animateWithDuration:0.25 animations:^{
            self.bottomView.alpha = 1;
        }];
    }else{
        [UIView animateWithDuration:0.25 animations:^{
            self.bottomView.alpha = 0;
        }];
    }
}
#pragma mark ======== 单击
- (void)singleTap:(UITapGestureRecognizer*)gesture{
    CGPoint point = [gesture locationInView:self];
    //单击点在图片内，移除视图
    if (CGRectContainsPoint(self.tapImageView.frame, point)) {
        [self remove];
    }else{
        //点击点在其他区域，显示、隐藏bottom
        [self isHidenBottom];
    }
}
#pragma mark ======== 双击
- (void)doubleTapAction:(UITapGestureRecognizer*)gesture{
    CGFloat zoomScale = self.zoomScale;
    zoomScale = (zoomScale == 1.0) ? 2.0 : 1.0;
    CGRect zoomRect = [self zoomRectForScale:zoomScale withCenter:[gesture locationInView:gesture.view]];
    [self zoomToRect:zoomRect animated:YES];
}

- (CGRect)zoomRectForScale:(float)scale withCenter:(CGPoint)center{
    CGRect zoomRect;
    zoomRect.size.height =self.frame.size.height / scale;
    zoomRect.size.width  =self.frame.size.width  / scale;
    zoomRect.origin.x = center.x - (zoomRect.size.width  /2.0);
    zoomRect.origin.y = center.y - (zoomRect.size.height /2.0);
    return zoomRect;
}
#pragma mark ========== UIScrollviewDelegate
- (UIView *)viewForZoomingInScrollView:(UIScrollView *)scrollView{
    return self.tapImageView;
}

// 这个方法是针对scrollView在缩小时无法居中的问题，scrollView放大，只要在设置完zoomScale之后设置偏移量为(0,0)即可实现放大居中
- (void)scrollViewDidZoom:(UIScrollView *)scrollView {
    
    CGFloat offsetX = MAX((scrollView.bounds.size.width - scrollView.contentInset.left - scrollView.contentInset.right - scrollView.contentSize.width) * 0.5, 0.0);
    CGFloat offsetY = MAX((scrollView.bounds.size.height - scrollView.contentInset.top - scrollView.contentInset.bottom - scrollView.contentSize.height) * 0.5, 0.0);
    
    self.tapImageView.center = CGPointMake(scrollView.contentSize.width * 0.5 + offsetX,
                                        scrollView.contentSize.height * 0.5 + offsetY);
    
}


#pragma mark ==========PhotoBottomViewDelegate
//编辑
- (void)photoBottomViewDidSelectEdit{
    APPDelegate(self.delegate, PhotoViewDelegate, photoViewDidEditImage:self.originalImage);
}

//3d 显示
- (void)photoBottomViewDidSelect3D{
    APPDelegate(self.delegate, PhotoViewDelegate, photoViewDidSelect3Dmage:self.originalImage);
}

#pragma mark ========== lazy load

- (ZFPhotoBottomView*)bottomView{
    if (!_bottomView) {
        _bottomView = [UIView loadFromNib:@"ZFPhotoBottomView" owner:self];
        _bottomView.delegate = self;
    }
    return _bottomView;
}

- (void)dealloc{

    self.originalImage = nil;
    self.tapImageView = nil;
    self.originRect = CGRectZero;
    NSLog(@"%s",__func__);
}
@end
