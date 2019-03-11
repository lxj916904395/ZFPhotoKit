//
//  PhotoEditManagerView.m
//  PhotoT
//
//  Created by apple on 2019/3/7.
//  Copyright © 2019 apple. All rights reserved.
//

#import "ZFPhotoEditManagerView.h"
#import "ZFPhotoEditView.h"
#import <AVFoundation/AVFoundation.h>
#import "ZFPhotoEditBottomView.h"
#import "ZFPhotoEditTopView.h"

@interface ZFPhotoEditManagerView()
@property (strong ,nonatomic) ZFPhotoEditView *mainView;
@property (strong,nonatomic) ZFPhotoEditBottomView *bottomView;
@property (strong,nonatomic) ZFPhotoEditTopView *topView;

@end

@implementation ZFPhotoEditManagerView

- (instancetype)initWithFrame:(CGRect)frame{
    if (self = [super initWithFrame:frame]) {
        self.userInteractionEnabled = YES;
        
        self.backgroundColor = [UIColor blackColor];
        
        [self addSubview:self.mainView];
        [self addSubview:self.bottomView];
        [self addSubview:self.topView];
        
        [self lxj_layout];
        
        __weak typeof(self)weakSelf = self;
        self.bottomView.sliderValueChangeBlock = ^(CGFloat value,NSInteger shaderIndex) {
            weakSelf.mainView.sliderValue = value;
            weakSelf.mainView.shaderIndex = shaderIndex;
        };
        
        self.topView.saveImageBlock = ^{
            [weakSelf saveImage];
        };
        
        self.topView.backBlock = ^{
            APPDelegate(weakSelf.delegate, PhotoEditManagerViewDelegate, PhotoEditManagerViewDidBack);
        };
    }
    return self;
}

- (void)lxj_layout{
    CGFloat sliderh = self.bottomView.sliderSize;
    CGFloat colleh = self.bottomView.itemH + 2*self.bottomView.itemOffset;
    [self.bottomView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.bottom.right.equalTo(self);
        if (kDevice_is_Fringe()) {
            make.height.mas_equalTo(sliderh+colleh+34);
        }else{
            make.height.mas_equalTo(sliderh+colleh);
        }
    }];
    
    [self.topView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.top.right.equalTo(self);
        make.height.mas_equalTo(50);
    }];
}

- (void)layoutGlkView{
    //获取图片尺寸
    CGSize imageSize = _image.size;
    
    //Returns a scaled CGRect that maintains the aspect ratio specified by a CGSize within a bounding CGRect.
    //返回一个在Self.bounds范围的CGRect,根据imagaSize的一个纵横比
    CGRect frame = AVMakeRectWithAspectRatioInsideRect(imageSize, self.bounds);
    
    //修改glView的frame
    self.mainView.frame = frame;
    
    //应用于视图的比例因子
    self.mainView.contentScaleFactor = imageSize.width / frame.size.width;
}

- (void)setImage:(UIImage *)image {
    //设置图片
    _image = image;
    
    //GLView
    [self layoutGlkView];
    
    //渲染图片
    self.mainView.image = image;
}

- (void)saveImage{
    [self.mainView saveImage];
}

- (ZFPhotoEditView*)mainView{
    if (!_mainView) {
        _mainView = [[ZFPhotoEditView alloc] initWithFrame:self.bounds];
    }
    return _mainView;
}

- (ZFPhotoEditBottomView*)bottomView{
    if (!_bottomView) {
        _bottomView = [ZFPhotoEditBottomView new];
        _bottomView.backgroundColor = self.topView.backgroundColor;
  
    }
    return _bottomView;
}

- (ZFPhotoEditTopView*)topView{
    if (!_topView) {
        _topView = [[ZFPhotoEditTopView alloc] init];
    }
    return _topView;
}

- (void)dealloc{
    _topView = nil;
    _bottomView = nil;
    _mainView = nil;
}
@end
