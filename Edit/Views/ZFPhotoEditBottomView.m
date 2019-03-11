//
//  PhotoEditBottomView.m
//  PhotoT
//
//  Created by apple on 2019/3/6.
//  Copyright © 2019 apple. All rights reserved.
//

#import "ZFPhotoEditBottomView.h"

@interface ShaderCollectionCell : UICollectionViewCell
@property (strong ,nonatomic) UILabel *textLabel;
@end

@implementation ShaderCollectionCell

- (instancetype)initWithFrame:(CGRect)frame{
    if (self = [super initWithFrame:frame]) {
        [self.contentView addSubview:self.textLabel];
        self.backgroundColor = [UIColor orangeColor];
    }
    return self;
}

- (void)layoutSubviews{
    [super layoutSubviews];
    [self.textLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.contentView);
    }];
}

- (UILabel *)textLabel{
    if (!_textLabel) {
        _textLabel = [UILabel new];
        _textLabel.font = [UIFont systemFontOfSize:20];
        _textLabel.textAlignment = NSTextAlignmentCenter;
        _textLabel.textColor = [UIColor whiteColor];
    }
    return _textLabel;
}
@end

@interface PhotoEditBottomTopView : UIView
@property (strong ,nonatomic) UISlider *slider;
@property (strong, nonatomic) UILabel *leftLabel;
@property (strong, nonatomic) UILabel *rightLabel;

@property (copy ,nonatomic) void (^sliderValueChangeBlock)(CGFloat value);
- (void)resetMaxValue;
@end

@implementation PhotoEditBottomTopView

- (instancetype)initWithFrame:(CGRect)frame{
    if (self = [super initWithFrame:frame]) {
        self.userInteractionEnabled = YES;
        [self addSubview:self.leftLabel];
        [self addSubview:self.rightLabel];
        [self addSubview:self.slider];
        
        [self setViewEnable:0];
    }
    return self;
}

- (void)layoutSubviews{
    [super layoutSubviews];
    
    [self.leftLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.top.bottom.equalTo(self);
        make.width.mas_equalTo(60);
    }];
    
    [self.rightLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.top.bottom.equalTo(self);
        make.width.equalTo(self.leftLabel);
    }];
    
    [self.slider mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.leftLabel.mas_right);
        make.right.equalTo(self.rightLabel.mas_left);
        make.bottom.top.equalTo(self);
    }];
}

- (void)sliderValueChange:(UISlider *)slider{
    self.rightLabel.text = [NSString stringWithFormat:@"%.f%%",slider.value*100];
    !self.sliderValueChangeBlock?:self.sliderValueChangeBlock(slider.value);
}

- (void)setViewEnable:(NSInteger)index{
    //点击原图，禁止滑动slider
    if (index == 0) {
        self.alpha = 0.5;
        self.userInteractionEnabled = NO;
    }else{
        self.alpha = 1;
        self.userInteractionEnabled = YES;
    }
}

//设置最大值
- (void)resetMaxValue{
    self.slider.value = 100;
    [self sliderValueChange:self.slider];
}

- (UISlider *)slider{
    if(!_slider){
        _slider = [UISlider new];
        _slider.maximumValue = 1;
        _slider.minimumValue = 0;
        _slider.value = 1;
        [_slider addTarget:self action:@selector(sliderValueChange:) forControlEvents:UIControlEventValueChanged];
    }
    return _slider;
}

- (UILabel *)leftLabel{
    if (!_leftLabel) {
        _leftLabel = [UILabel new];
        _leftLabel.font = [UIFont systemFontOfSize:16];
        _leftLabel.textAlignment = NSTextAlignmentCenter;
        _leftLabel.textColor = [UIColor whiteColor];
        _leftLabel.text = @"程度";
    }
    return _leftLabel;
}

- (UILabel *)rightLabel{
    if (!_rightLabel) {
        _rightLabel = [UILabel new];
        _rightLabel.font = [UIFont systemFontOfSize:16];
        _rightLabel.textAlignment = NSTextAlignmentCenter;
        _rightLabel.textColor = [UIColor whiteColor];
        _rightLabel.text = @"100%";
    }
    return _rightLabel;
}
@end

@interface ZFPhotoEditBottomView ()<UICollectionViewDelegate,UICollectionViewDataSource>

@property (strong ,nonatomic) NSArray *shaderNames;
@property (strong,nonatomic) UICollectionView *collectionView;

@property (strong ,nonatomic) PhotoEditBottomTopView *topView;

@end
@implementation ZFPhotoEditBottomView

- (instancetype)init{
    if (self = [super init]) {
        self.userInteractionEnabled = YES;
        self.backgroundColor = [UIColor blackColor];
        
        self.itemOffset = 10;
        self.sliderSize = 50;
        self.itemH = (kScreenWidth-4*self.itemOffset-10)/4;
        
        self.shaderNames = @[@"原图",@"色温",@"饱和度",@"曝光度",@"亮度"];
        
        [self addSubview:self.topView];
        [self addSubview:self.collectionView];
        
        __weak typeof(self)weakself = self;
        self.topView.sliderValueChangeBlock = ^(CGFloat value) {
            [weakself sliderValueChange:value];
        };
    }
    return self;
}

- (void)layoutSubviews{
    [super layoutSubviews];
    
    [self.topView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.top.right.equalTo(self);
        make.height.mas_equalTo(self.sliderSize);
    }];
    [self.collectionView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(self);
        make.top.equalTo(self.topView.mas_bottom);
        make.height.mas_equalTo(self.itemH+2*self.itemOffset);
    }];
}



#pragma mark ========== methods
- (void)sliderValueChange:(CGFloat )value{
    !self.sliderValueChangeBlock?:self.sliderValueChangeBlock(value,self.currentShaderIndex);
}

#pragma mark ========== UICollectionViewDelegate
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    return self.shaderNames.count;
}

- (__kindof UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    
    ShaderCollectionCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"cell" forIndexPath:indexPath];
    cell.textLabel.text = self.shaderNames[indexPath.row];
    
    if (indexPath.row == self.currentShaderIndex) {
        cell.textLabel.textColor = [UIColor redColor];
    }else{
        cell.textLabel.textColor = [UIColor whiteColor];
    }
    return cell;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    self.currentShaderIndex = indexPath.row;
    [collectionView reloadData];
    
    [self.topView setViewEnable:self.currentShaderIndex];
    
    //重置slider
    [self.topView resetMaxValue];
    !self.shaderStyleBlock?:self.shaderStyleBlock(self.shaderNames[self.currentShaderIndex]);
}

#pragma mark ========== lazy load
- (PhotoEditBottomTopView*)topView{
    if (!_topView) {
        _topView = [[PhotoEditBottomTopView alloc] init];
    }
    return _topView;
}

- (UICollectionView*)collectionView{
    if (!_collectionView) {
        UICollectionViewFlowLayout *layout = [UICollectionViewFlowLayout new];
        layout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
        

        layout.minimumLineSpacing = self.itemOffset;
        layout.minimumInteritemSpacing = self.itemOffset;

        layout.itemSize = CGSizeMake(self.itemH, self.itemH);
        
        _collectionView = [[UICollectionView alloc] initWithFrame:CGRectZero collectionViewLayout:layout];
        _collectionView.delegate = self;
        _collectionView.dataSource = self;
        [_collectionView registerClass:[ShaderCollectionCell class] forCellWithReuseIdentifier:@"cell"];
        _collectionView.showsHorizontalScrollIndicator = NO;
    }
    return _collectionView;
}
@end
