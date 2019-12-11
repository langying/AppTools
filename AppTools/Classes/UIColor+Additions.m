//
//  UIColor+ARGB.m
//  TBImageCache
//
//  Created by 韩 琼 on 13-10-7.
//  Copyright (c) 2013年 taobao. All rights reserved.
//

#import "UIColor+Additions.h"

@implementation UIColor (Additions)

- (NSUInteger)RGBA {
    CGFloat R, G, B, A;
    [self getRed:&R green:&G blue:&B alpha:&A];
    NSUInteger color = 0;
    color |= (((NSUInteger)(R * 255)) << 24);
    color |= (((NSUInteger)(G * 255)) << 16);
    color |= (((NSUInteger)(B * 255)) << 8 );
    color |= (((NSUInteger)(A * 255)) << 0 );
    return color;
}

+ (UIColor*)RGBAColor:(NSUInteger)value {
    CGFloat R = ((value & 0xFF000000) >> 24) / 255.0;
    CGFloat G = ((value & 0x00FF0000) >> 16) / 255.0;
    CGFloat B = ((value & 0x0000FF00) >> 8 ) / 255.0;
    CGFloat A = ((value & 0x000000FF) >> 0 ) / 255.0;
    return [UIColor colorWithRed:R green:G blue:B alpha:A];
}

@end
