//
//  PhotoTool.m
//  PhotoT
//
//  Created by apple on 2019/2/28.
//  Copyright © 2019 apple. All rights reserved.
//

#import "ZFPhotoTool.h"
#import <Photos/Photos.h>
@interface ZFPhotoTool()
@property (weak, nonatomic) id<PhotoToolDelegate>delegate;

@end
@implementation ZFPhotoTool

+  (ZFPhotoTool*)manager{
    static ZFPhotoTool *instance;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        instance = [ZFPhotoTool new];
    });
    return instance;
}

- (void)loadPhotoWithDelegate:(id<PhotoToolDelegate>)delegate{
    self.delegate = delegate;
    dispatch_queue_t queue = dispatch_queue_create("loadphoto", DISPATCH_QUEUE_CONCURRENT);
    dispatch_async(queue, ^{
        [self getThumbnailImages];
    });
}

//获取所有相册
- (void)loadAllAlbums:(id<PhotoToolDelegate>)delegate{
    self.delegate = delegate;
    
        // 获得所有的自定义相簿
        PHFetchResult<PHAssetCollection *> *assetCollections = [PHAssetCollection fetchAssetCollectionsWithType:PHAssetCollectionTypeAlbum subtype:PHAssetCollectionSubtypeAlbumRegular options:nil];
        // 遍历所有的自定义相簿
        for (PHAssetCollection *assetCollection in assetCollections) {
           [self enumerateAssetsInAssetCollection:assetCollection original:NO];
        }
    
    
        // 列出所有相册智能相册
        PHFetchResult *smartAlbums = [PHAssetCollection fetchAssetCollectionsWithType:PHAssetCollectionTypeSmartAlbum subtype:PHAssetCollectionSubtypeAlbumRegular options:nil];
    
        for (PHAssetCollection *albums in smartAlbums) {
            [self enumerateAssetsInAssetCollection:albums original:NO];
//            PHFetchResult *result = [PHAsset fetchAssetsInAssetCollection:albums options:nil];
//            for (PHAsset *asset in result) {
//                NSLog(@"%@",asset);
//                [[PHImageManager defaultManager] requestImageForAsset:asset targetSize:/*CGSizeMake(pixSize, pixSize) */PHImageManagerMaximumSize contentMode:PHImageContentModeAspectFill options:nil resultHandler:^(UIImage * _Nullable image, NSDictionary * _Nullable info) {
//
//                }];
//            }
        }
    
    //
    //    // 列出所有用户创建的相册
    //    PHFetchResult *topLevelUserCollections = [PHCollectionList fetchTopLevelUserCollectionsWithOptions:nil];
    //
    //    // 获取所有资源的集合，并按资源的创建时间排序
    //    PHFetchOptions *options = [[PHFetchOptions alloc] init];
    //    options.sortDescriptors = @[[NSSortDescriptor sortDescriptorWithKey:@"creationDate" ascending:YES]];
    //    PHFetchResult *assetsFetchResults = [PHAsset fetchAssetsWithOptions:options];
}

//获得所有相簿中的缩略图
- (void)getThumbnailImages
{

    // 获得相机胶卷
    PHAssetCollection *cameraRoll = [PHAssetCollection fetchAssetCollectionsWithType:PHAssetCollectionTypeSmartAlbum subtype:PHAssetCollectionSubtypeSmartAlbumUserLibrary options:nil].lastObject;
    [self enumerateAssetsInAssetCollection:cameraRoll original:NO];
}


/**
 *  遍历相簿中的所有图片
 *  @param assetCollection 相簿
 *  @param original        是否要原图
 */
- (void)enumerateAssetsInAssetCollection:(PHAssetCollection *)assetCollection original:(BOOL)original
{
    
    NSMutableArray *photos = [NSMutableArray new];
    NSMutableArray *originalPhotos = [NSMutableArray new];

    PHImageRequestOptions *options = [[PHImageRequestOptions alloc] init];
    // 同步获得图片, 只会返回1张图片
    options.synchronous = YES;
    
    // 获得某个相簿中的所有PHAsset对象
    PHFetchResult<PHAsset *> *assets = [PHAsset fetchAssetsInAssetCollection:assetCollection options:nil];
    for (PHAsset *asset in assets) {
        // 是否要原图
//        CGSize size = original ? CGSizeMake(asset.pixelWidth, asset.pixelHeight) : CGSizeZero;
        
        // 从asset中获得缩略图片
        [[PHImageManager defaultManager] requestImageForAsset:asset targetSize:CGSizeZero contentMode:PHImageContentModeDefault options:options resultHandler:^(UIImage * _Nullable result, NSDictionary * _Nullable info) {
        
            if (result) {
               // NSLog(@"图片大小 %@",NSStringFromCGSize(result.size));
                [photos addObject:result];
            }
        }];
        
        //原图
        [[PHImageManager defaultManager] requestImageForAsset:asset targetSize:CGSizeMake(asset.pixelWidth, asset.pixelHeight)  contentMode:PHImageContentModeDefault options:options resultHandler:^(UIImage * _Nullable result, NSDictionary * _Nullable info) {
            
            if (result) {
               // NSLog(@"图片大小 %@",NSStringFromCGSize(result.size));
                [originalPhotos addObject:result];
            }
        }];
    }
    
    dispatch_async(dispatch_get_main_queue(), ^{
        APPDelegate(self.delegate, PhotoToolDelegate, photoToolLoadPhotoCompleted:assetCollection.localizedTitle photos:photos originalPhotos:originalPhotos);
    });
}

@end
