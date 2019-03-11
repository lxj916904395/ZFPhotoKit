//
//  PhotoEditManagerView.h
//  PhotoT
//
//  Created by apple on 2019/3/7.
//  Copyright © 2019 apple. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@protocol PhotoEditManagerViewDelegate;
@interface ZFPhotoEditManagerView : UIView

@property (strong, nonatomic) UIImage *image;
@property (weak,nonatomic) id<PhotoEditManagerViewDelegate>delegate;
@end

@protocol PhotoEditManagerViewDelegate <NSObject>

- (void)PhotoEditManagerViewDidBack;

@end

NS_ASSUME_NONNULL_END
