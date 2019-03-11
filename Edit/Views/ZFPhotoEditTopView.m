//
//  PhotoEditTopView.m
//  PhotoT
//
//  Created by apple on 2019/3/8.
//  Copyright © 2019 apple. All rights reserved.
//

#import "ZFPhotoEditTopView.h"
@interface ZFPhotoEditTopView()
@property(strong,nonatomic) UIButton *saveBtn;
@property(strong,nonatomic) UIButton *backBtn;

@end
@implementation ZFPhotoEditTopView

- (instancetype)init{
    if (self = [super init]) {
        self.userInteractionEnabled = YES;
        
        self.backgroundColor = [[UIColor colorWithHexString:@"212121"]colorWithAlphaComponent:0.6];
        [self addSubview:self.saveBtn];
        [self addSubview:self.backBtn];

    }
    return self;
}

- (void)layoutSubviews{
    [super layoutSubviews];
    [self.saveBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        if (kDevice_is_Fringe()) {
              make.top.equalTo(self).offset(40);
        }else{
              make.top.equalTo(self).offset(20);
        }
        make.right.equalTo(self).offset(-20);
        make.size.mas_equalTo(CGSizeMake(50, 25));
    }];
    
    [self.backBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self).offset(20);
        make.top.equalTo(self.saveBtn);
        make.size.equalTo(self.saveBtn);
    }];
}

- (void)saveImage{
    !self.saveImageBlock?:self.saveImageBlock();
}

- (void)back{
    !self.backBlock?:self.backBlock();
}

- (UIButton*)saveBtn{
    if (!_saveBtn) {
        _saveBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [_saveBtn setTitle:@"保存" forState:UIControlStateNormal];
        [_saveBtn addTarget:self action:@selector(saveImage) forControlEvents:UIControlEventTouchUpInside];
    }
    return _saveBtn;
}

- (UIButton*)backBtn{
    if (!_backBtn) {
        _backBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [_backBtn setTitle:@"返回" forState:UIControlStateNormal];
        [_backBtn addTarget:self action:@selector(back) forControlEvents:UIControlEventTouchUpInside];
    }
    return _backBtn;
}
@end
