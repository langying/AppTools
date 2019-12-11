//
//  UIView+Additions.m
//  TBBusiness
//
//  Created by 韩琼 on 14-5-11.
//  Copyright (c) 2014年 Taobao. All rights reserved.
//

//#import <Photos/Photos.h>
#import "ALAssetsLibrary+Additions.h"

@implementation ALAssetsLibrary(Additions)

+ (instancetype)sharedInstance {
    static id instance = nil;
    if (instance == nil) {
        instance = [[ALAssetsLibrary alloc] init];
    }
    return instance;
}

+ (void)albumWithName:(NSString*)album callback:(ALAssetsCallback)callback {
    ALAssetsLibrary* library = [ALAssetsLibrary sharedInstance];
    [library enumerateGroupsWithTypes:ALAssetsGroupAlbum usingBlock:^(ALAssetsGroup* group, BOOL* stop) {
        if (*stop) {
            return;
        }
        if ([album isEqualToString:[group valueForProperty:ALAssetsGroupPropertyName]]) {
            *stop = YES;
            if (callback) {callback(library, group, nil);}
            return;
        }
        if (group == nil) {
            *stop = YES;
            [library addAssetsGroupAlbumWithName:album resultBlock:^(ALAssetsGroup* group) {
                if (callback) {callback([ALAssetsLibrary sharedInstance], group, nil);}
            } failureBlock:^(NSError* error) {
                if (callback) {callback(nil, nil, error.domain);}
            }];
//            [[TBConfig sharedInstance] runWithVersion:@"8.0" before:^{
//                [library addAssetsGroupAlbumWithName:album resultBlock:^(ALAssetsGroup* group) {
//                    if (callback) {callback([ALAssetsLibrary sharedInstance], group, nil);}
//                } failureBlock:^(NSError* error) {
//                    if (callback) {callback(nil, nil, error.domain);}
//                }];
//            } after:^{
//                [[PHPhotoLibrary sharedPhotoLibrary] performChanges:^{
//                    [PHAssetCollectionChangeRequest creationRequestForAssetCollectionWithTitle:album];
//                } completionHandler:^(BOOL success, NSError* error) {
//                    dispatch_async(dispatch_get_main_queue(), ^{
//                        if (success) {
//                            [ALAssetsLibrary albumWithName:album callback:callback];
//                        }
//                        else {
//                            if (callback) {callback(nil, nil, error.domain);}
//                        }
//                    });
//                }];
//            }];
            return;
        }
    } failureBlock:^(NSError* error) {
        if (callback) {callback(nil, nil, @"请在设置-隐私-照片中设置权限");}
    }];
}

+ (void)saveImage:(UIImage*)image success:(ALAssetsSuccess)success failure:(ALAssetsFailure)failure {
    if (image == nil) {
        if (failure) {failure(@"图片不能为空");}
        return;
    }
    
    NSString* album = @"溪牛";
    ALAssetsLibrary* library = [ALAssetsLibrary sharedInstance];
    [library enumerateGroupsWithTypes:ALAssetsGroupAlbum usingBlock:^(ALAssetsGroup* group, BOOL* stop) {
        if (*stop) {
            return;
        }
        if ([album isEqualToString:[group valueForProperty:ALAssetsGroupPropertyName]]) {
            *stop = YES;
            [ALAssetsLibrary saveImage:image toGroup:group success:success failure:failure];
            return;
        }
        if (group == nil) {
            *stop = YES;
            [library addAssetsGroupAlbumWithName:album resultBlock:^(ALAssetsGroup* group) {
                [ALAssetsLibrary saveImage:image toGroup:group success:success failure:failure];
            } failureBlock:^(NSError* error) {
                if (failure) {failure(error.domain);}
            }];
//            [[TBConfig sharedInstance] runWithVersion:@"8.0" before:^{
//                [library addAssetsGroupAlbumWithName:album resultBlock:^(ALAssetsGroup* group) {
//                    [ALAssetsLibrary saveImage:image toGroup:group success:success failure:failure];
//                } failureBlock:^(NSError* error) {
//                    if (failure) {failure(error.domain);}
//                }];
//            } after:^{
//                [[PHPhotoLibrary sharedPhotoLibrary] performChanges:^{
//                    [PHAssetCollectionChangeRequest creationRequestForAssetCollectionWithTitle:album];
//                } completionHandler:^(BOOL flag, NSError* error) {
//                    dispatch_async(dispatch_get_main_queue(), ^{
//                        if (flag) {
//                            [ALAssetsLibrary saveImage:image success:success failure:failure];
//                        }
//                        else {
//                            if (failure) {failure(error.domain);}
//                        }
//                    });
//                }];
//            }];
            return;
        }
    } failureBlock:^(NSError* error) {
        if (failure) {failure(@"请在设置-隐私-照片中设置权限");}
    }];
}

+ (void)saveImage:(UIImage*)image toGroup:(ALAssetsGroup*)group success:(ALAssetsSuccess)success failure:(ALAssetsFailure)failure {
    if (group == nil) {
        if (failure) {failure(@"创建相册失败");}
        return;
    }
    
    ALAssetsLibrary* library = [ALAssetsLibrary sharedInstance];
    ALAssetOrientation orientation = (ALAssetOrientation)image.imageOrientation;
    [library writeImageToSavedPhotosAlbum:image.CGImage orientation:orientation completionBlock:^(NSURL* assetURL, NSError* error) {
        if (error || assetURL == nil) {
            if (failure) {failure(error.domain ?: @"保存图片失败");}
            return;
        }
        [library assetForURL:assetURL resultBlock:^(ALAsset* asset) {
            if (!group.isEditable) {
                if (failure) {failure([NSString stringWithFormat:@"相册<%@>是只读的", [group valueForProperty:ALAssetsGroupPropertyName]]);}
                return;
            }
            BOOL flag = [group addAsset:asset];
            if (flag) {
                if (success) {success(@"已保存到相册");}
            }
            else {
                if (failure) {failure([NSString stringWithFormat:@"无法添加到相册<%@>", [group valueForProperty:ALAssetsGroupPropertyName]]);}
            }
        } failureBlock:^(NSError* error) {
            if (failure) {failure(error.domain);}
        }];
    }];
}

+ (void)saveData:(NSData*)data toGroup:(ALAssetsGroup*)group success:(ALAssetsSuccess)success failure:(ALAssetsFailure)failure {
    if (group == nil) {
        if (failure) {failure(@"创建相册失败");}
        return;
    }
    
    ALAssetsLibrary* library = [ALAssetsLibrary sharedInstance];
    [library writeImageDataToSavedPhotosAlbum:data metadata:nil completionBlock:^(NSURL* assetURL, NSError* error) {
        if (error || assetURL == nil) {
            if (failure) {failure(error.domain ?: @"保存图片失败");}
            return;
        }
        [library assetForURL:assetURL resultBlock:^(ALAsset* asset) {
            if (!group.isEditable) {
                if (failure) {failure([NSString stringWithFormat:@"相册<%@>是只读的", [group valueForProperty:ALAssetsGroupPropertyName]]);}
                return;
            }
            BOOL flag = [group addAsset:asset];
            if (flag) {
                if (success) {success(@"已保存到相册");}
            }
            else {
                if (failure) {failure([NSString stringWithFormat:@"无法添加到相册<%@>", [group valueForProperty:ALAssetsGroupPropertyName]]);}
            }
        } failureBlock:^(NSError* error) {
            if (failure) {failure(error.domain);}
        }];
    }];
}

@end
