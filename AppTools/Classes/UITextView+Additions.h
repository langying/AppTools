//
//  UIColor+ARGB.h
//  TBImageCache
//
//  Created by 韩 琼 on 13-10-7.
//  Copyright (c) 2013年 taobao. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UITextView (Additions)

- (void)setIcon:(NSString*)icon;
- (void)setDelegate:(id<UITextViewDelegate>)delegate returnKeyType:(UIReturnKeyType)type;
- (void)setFont:(NSInteger)font color:(NSUInteger)color alignment:(NSTextAlignment)alignment text:(NSString*)text;

- (UIView*)leftView;
- (UIView*)rightView;
- (UIView*)leftWidthView:(CGFloat)width;
- (UIView*)rightWidthView:(CGFloat)width;
@end
