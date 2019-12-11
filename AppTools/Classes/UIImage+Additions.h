//
//  UIImage+Additions.h
//  TBSport
//
//  Created by 赵敏行 on 15-4-9.
//  Copyright (c) 2015年 taobao. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIImage (Additions)

- (void)_setHomeScreen;
- (void)_setLockScreen;
- (void)_setHomeAndLockScreen;

- (UIImage*)orientationFixedImage;

+ (UIImage*)imageWithImageSimple:(UIImage*)image scaledCompress:(CGFloat)scaledCompress;

/** 圆角: size.width=size.height && size.width <= cornerRadius */
+ (UIImage*)rectImage:(CGSize)size backgroundColor:(UIColor *)bgColor cornerRadius:(float)cornerRadius;

@end
