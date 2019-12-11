//
//  UIView+Additions.h
//  TBBusiness
//
//  Created by 韩琼 on 14-5-11.
//  Copyright (c) 2014年 Taobao. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UILabel (Additions)

- (void)setFont:(NSInteger)font color:(NSUInteger)color text:(NSString*)text;
- (void)setFont:(NSInteger)font color:(NSUInteger)color text:(NSString*)text alignment:(NSTextAlignment)alignment;
- (void)setFont:(NSString*)font size:(NSInteger)size color:(NSUInteger)color text:(NSString*)text alignment:(NSTextAlignment)alignment;
- (void)setShadowColor:(NSUInteger)color offset:(CGSize)offset;
- (void)setLineNumber:(NSUInteger)number alignment:(NSTextAlignment)alignment lineBreak:(NSLineBreakMode)lineBreak;

@end
