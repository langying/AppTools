//
//  UIButton+Additions.h
//  TBImageCache
//
//  Created by 韩琼 on 14-2-8.
//  Copyright (c) 2014年 taobao. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIButton (Additions)

- (UIButton*)setColor1:(NSInteger)color1 color2:(NSInteger)color2;
- (UIButton*)setTitle1:(NSString*)title1 title2:(NSString*)title2;
- (UIButton*)setImage1:(NSString*)image1 image2:(NSString*)image2;
- (UIButton*)setBgImage1:(NSString*)image1 bgImage2:(NSString*)image2;

- (UIButton*)setImage:(NSString*)image target:(id)target action:(SEL)action;
- (UIButton*)setTitle:(NSString*)title font:(NSUInteger)font color:(NSUInteger)color bgImage:(NSString*)image target:(id)target action:(SEL)action;

@end
