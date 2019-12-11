//
//  UIButton+Additions.m
//  TBImageCache
//
//  Created by 韩琼 on 14-2-8.
//  Copyright (c) 2014年 taobao. All rights reserved.
//

#import "UIColor+Additions.h"
#import "UIButton+Additions.h"

@implementation UIButton (Additions)

- (UIButton*)setColor1:(NSInteger)color1 color2:(NSInteger)color2 {
    [self setTitleColor:[UIColor RGBAColor:color1] forState:UIControlStateNormal];
    [self setTitleColor:[UIColor RGBAColor:color2] forState:UIControlStateHighlighted];
    return self;
}
- (UIButton*)setTitle1:(NSString*)title1 title2:(NSString*)title2 {
    [self setTitle:title1 forState:UIControlStateNormal];
    [self setTitle:title2 forState:UIControlStateHighlighted];
    return self;
}
- (UIButton*)setImage1:(NSString*)image1 image2:(NSString*)image2 {
    [self setImage:[UIImage imageNamed:image1] forState:UIControlStateNormal];
    [self setImage:[UIImage imageNamed:image2] forState:UIControlStateHighlighted];
    return self;
}
- (UIButton*)setBgImage1:(NSString*)image1 bgImage2:(NSString*)image2 {
    [self setBackgroundImage:[UIImage imageNamed:image1] forState:UIControlStateNormal];
    [self setBackgroundImage:[UIImage imageNamed:image2] forState:UIControlStateHighlighted];
    return self;
}

- (UIButton*)setImage:(NSString*)image target:(id)target action:(SEL)action {
    [self setImage:[UIImage imageNamed:image] forState:UIControlStateNormal];
    [self addTarget:target action:action forControlEvents:UIControlEventTouchUpInside];
    return self;
}
- (UIButton*)setTitle:(NSString*)title font:(NSUInteger)font color:(NSUInteger)color bgImage:(NSString*)image target:(id)target action:(SEL)action {
    self.titleLabel.font = [UIFont systemFontOfSize:font];
    [self setTitle:title forState:UIControlStateNormal];
    [self setTitleColor:[UIColor RGBAColor:color] forState:UIControlStateNormal];
    [self setBackgroundImage:[UIImage imageNamed:image] forState:UIControlStateNormal];
    [self addTarget:target action:action forControlEvents:UIControlEventTouchUpInside];
    return self;
}

@end
