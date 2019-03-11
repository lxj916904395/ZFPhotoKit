//
//  PhotoEditViewController.m
//  PhotoT
//
//  Created by apple on 2019/3/6.
//  Copyright © 2019 apple. All rights reserved.
//

#import "ZFPhotoEditViewController.h"
#import "ZFPhotoEditManagerView.h"

@interface ZFPhotoEditViewController ()<UIGestureRecognizerDelegate,PhotoEditManagerViewDelegate>

@property(strong, nonatomic) UIImage *image;
@property (strong ,nonatomic) ZFPhotoEditManagerView *mainView;
@end

@implementation ZFPhotoEditViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    if([self.navigationController respondsToSelector:@selector(interactivePopGestureRecognizer)]) {
        self.navigationController.interactivePopGestureRecognizer.delegate = (id)self;
    }
}

- (BOOL)gestureRecognizerShouldBegin:(UIGestureRecognizer
                                      *)gestureRecognizer{
    return NO; //YES：允许右滑返回  NO：禁止右滑返回
}

- (void)PhotoEditManagerViewDidBack{
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)setupViews{
    [super setupViews];
    self.view.userInteractionEnabled = YES;
    [self.view addSubview:self.mainView];
    self.mainView.image = self.image;
}

- (ZFPhotoEditManagerView*)mainView{
    if (!_mainView) {
        _mainView = [[ZFPhotoEditManagerView alloc] initWithFrame:self.view.bounds];
        _mainView.delegate = self;
    }
    return _mainView;
}

- (void)dealloc{
    _mainView = nil;
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
