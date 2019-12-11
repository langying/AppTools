//
//  UIView+Additions.h
//  TBBusiness
//
//  Created by 韩琼 on 14-5-11.
//  Copyright (c) 2014年 Taobao. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <AssetsLibrary/AssetsLibrary.h>

typedef void(^ALAssetsSuccess)();
typedef void(^ALAssetsFailure)(NSString* error);
typedef void(^ALAssetsCallback)(ALAssetsLibrary* library, ALAssetsGroup* group, NSString* error);

@interface ALAssetsLibrary(Additions)

+ (instancetype)sharedInstance;

+ (void)albumWithName:(NSString*)album callback:(ALAssetsCallback)callback;

+ (void)saveImage:(UIImage*)image success:(ALAssetsSuccess)success failure:(ALAssetsFailure)failure;

+ (void)saveImage:(UIImage*)image toGroup:(ALAssetsGroup*)group success:(ALAssetsSuccess)success failure:(ALAssetsFailure)failure;

+ (void)saveData:(NSData*)data toGroup:(ALAssetsGroup*)group success:(ALAssetsSuccess)success failure:(ALAssetsFailure)failure;
@end
