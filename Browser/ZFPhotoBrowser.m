//
//  PhotoBrowser.m
//  PhotoT
//
//  Created by apple on 2019/3/6.
//  Copyright © 2019 apple. All rights reserved.
//

#import "ZFPhotoBrowser.h"
#import "ZFNavigationController.h"
#import "ZFPhotoView.h"

@interface ZFPhotoBrowser ()<PhotoViewDelegate>{
    BOOL _isBack;
    BOOL _viewLoaded;
}
@property (strong ,nonatomic) UIImageView *sourceView;
@property (strong ,nonatomic) UIImage *originalImage;
@property (strong ,nonatomic) UIScrollView *scrollView;
@end

@implementation ZFPhotoBrowser

+ (UIViewController*)showWithSource:(UIImageView*)sourceView originalImage:(UIImage*)originalImage{
    ZFPhotoBrowser *browser = [ZFPhotoBrowser new];
    
    [browser setValue:sourceView forKey:@"sourceView"];
    [browser setValue:originalImage forKey:@"originalImage"];
    browser.view.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0.0];
    ZFNavigationController *  naiv = [[ZFNavigationController alloc] initWithRootViewController:browser];
    naiv.modalPresentationStyle = UIModalPresentationOverCurrentContext;
    return naiv;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor = [UIColor clearColor];
    if ([self.navigationController respondsToSelector:@selector(interactivePopGestureRecognizer)]) {
        self.navigationController.interactivePopGestureRecognizer.enabled = NO;
    }
}
- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:YES animated:animated];
}

- (void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    
    if (!_viewLoaded) {
        _viewLoaded = YES;
        [[ZFPhotoView showWithSource:self.sourceView originalImage:self.originalImage delegate:self] showInView:self.view];
    }
}

- (void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    if (_isBack) {
        [self.navigationController setNavigationBarHidden:NO animated:animated];
    }
}

#pragma mark ========= PhotoViewDelegate
//编辑
- (void)photoViewDidEditImage:(UIImage *)image{
    Class cla = NSClassFromString(@"ZFPhotoEditViewController");
    UIViewController *vc = [cla new];
    [vc setValue:image forKey:@"image"];
    [self.navigationController pushViewController:vc animated:YES];
}

//3D显示
- (void)photoViewDidSelect3Dmage:(UIImage *)image{
    Class cla = NSClassFromString(@"ZFPhoto3DController");
    UIViewController *vc = [cla new];
    [vc setValue:image forKey:@"image"];
    [self.navigationController pushViewController:vc animated:YES];
}

//返回
- (void)photoViewDidRemove{
    _isBack = YES;
    [self dismissViewControllerAnimated:NO completion:nil];
}

//显示动画完成
- (void)photoViewDidShowAnimatedFinish{
    self.view.userInteractionEnabled = YES;
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
