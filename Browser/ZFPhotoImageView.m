//
//  PhotoImageView.m
//  PhotoT
//
//  Created by apple on 2019/3/4.
//  Copyright © 2019 apple. All rights reserved.
//

#import "ZFPhotoImageView.h"

@implementation ZFPhotoImageView
- (id)initWithFrame:(CGRect)frame {
    if ((self = [super initWithFrame:frame])) {
        [self addDoubleGesture];
    }
    return self;
}

- (id)initWithImage:(UIImage *)image {
    if ((self = [super initWithImage:image])) {
        [self addDoubleGesture];
    }
    return self;
}

- (id)initWithImage:(UIImage *)image highlightedImage:(UIImage *)highlightedImage {
    if ((self = [super initWithImage:image highlightedImage:highlightedImage])) {
        [self addDoubleGesture];
    }
    return self;
}

- (void)addDoubleGesture{
    self.userInteractionEnabled = YES;


}
@end
