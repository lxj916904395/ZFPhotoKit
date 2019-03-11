//
//  PhotoPermission.m
//  PhotoT
//
//  Created by apple on 2019/3/1.
//  Copyright © 2019 apple. All rights reserved.
//

#import "ZFPhotoPermission.h"
#import <Photos/Photos.h>
#import <AssetsLibrary/AssetsLibrary.h>
@implementation ZFPhotoPermission

+(BOOL)detectionPhotoState:(void(^)(void))authorizedBlock
{
    BOOL isAvalible = NO;
    
  
        PHAuthorizationStatus authStatus = [PHPhotoLibrary authorizationStatus];
        
        //用户尚未授权
        if (authStatus == PHAuthorizationStatusNotDetermined)
        {
            [PHPhotoLibrary requestAuthorization:^(PHAuthorizationStatus status) {
                
                if (status == PHAuthorizationStatusAuthorized)
                {
                    if (authorizedBlock)
                    {
                        authorizedBlock();
                    }
                }}];
        }
        //用户已经授权
        else if (authStatus == PHAuthorizationStatusAuthorized)
        {
            isAvalible = YES;
            
            if (authorizedBlock)
            {
                authorizedBlock();
            }
        }
        //用户拒绝授权
        else
        {
            //提示用户开启相册权限
            
            UIAlertController *alertvc = [UIAlertController alertControllerWithTitle:@"未开启相册权限，是否跳转开启？" message:nil preferredStyle: UIAlertControllerStyleAlert];
            
            [alertvc addAction:[UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
                
            }]];
            
            [alertvc addAction:[UIAlertAction actionWithTitle:@"跳转" style:    UIAlertActionStyleDestructive handler:^(UIAlertAction * _Nonnull action) {
                [self openSetting];
            }]];
            
            [[UIViewController topViewController] presentViewController:alertvc animated:(BOOL)YES completion:^{
                
            }];
            
        }
    
    return isAvalible;
}

+ (void)openSetting{
    if(kSystemVersion >= 10.0){
        
        NSURL * url = [NSURL URLWithString:UIApplicationOpenSettingsURLString];
        if (@available(iOS 10.0, *)) {
            [[UIApplication sharedApplication] openURL:url options:@{} completionHandler:^(BOOL success) {
                
            }];
        } else {
            // Fallback on earlier versions
            [[UIApplication sharedApplication] openURL:url];
        }
        
    }else{
        NSString * idf = [NSBundle mainBundle].bundleIdentifier;
        NSString * string = [NSString stringWithFormat:@"prefs:root=NOTIFICATIONS_ID&path=%@", idf];
        NSURL * url = [NSURL URLWithString:string];
        if (@available(iOS 10.0, *)) {
            [[UIApplication sharedApplication] openURL:url options:@{} completionHandler:^(BOOL success) {
                
            }];
        } else {
            [[UIApplication sharedApplication] openURL:url];
        }
        
    }
}

@end
