//
//  PhotoBottomView.m
//  PhotoT
//
//  Created by apple on 2019/3/6.
//  Copyright © 2019 apple. All rights reserved.
//

#import "ZFPhotoBottomView.h"

@implementation ZFPhotoBottomView

- (void)awakeFromNib{
    [super awakeFromNib];

    self.width = kScreenWidth;
    [self hiden];
    self.backgroundColor = [[UIColor colorWithHexString:@"212121"] colorWithAlphaComponent:0.6];
}


- (IBAction)doEdit:(id)sender {
    
    APPDelegate(self.delegate, PhotoBottomViewDelegate, photoBottomViewDidSelectEdit);
}

- (IBAction)do3D:(id)sender {
    APPDelegate(self.delegate, PhotoBottomViewDelegate, photoBottomViewDidSelect3D);
}

- (void)hiden{
    self.top = kScreenHeight;
}

- (void)show{
    self.top = kScreenHeight - 70;
}
@end
