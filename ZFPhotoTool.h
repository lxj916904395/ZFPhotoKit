//
//  PhotoTool.h
//  PhotoT
//
//  Created by apple on 2019/2/28.
//  Copyright © 2019 apple. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@protocol PhotoToolDelegate;
@interface ZFPhotoTool : NSObject

+  (ZFPhotoTool*)manager;

- (void)loadPhotoWithDelegate:( id<PhotoToolDelegate>)delegate;
- (void)loadAllAlbums:(id<PhotoToolDelegate>)delegate;

@end

@protocol PhotoToolDelegate<NSObject>
- (void)photoToolLoadPhotoCompleted:(NSString*)title photos:(NSArray*)photos originalPhotos:(NSArray*)originalPhotos;
@end

NS_ASSUME_NONNULL_END
