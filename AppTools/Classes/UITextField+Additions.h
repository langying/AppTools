//
//  UIColor+ARGB.h
//  TBImageCache
//
//  Created by 韩 琼 on 13-10-7.
//  Copyright (c) 2013年 taobao. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UITextField (Additions)

- (void)setIcon:(NSString*)icon;
- (void)setFont:(NSInteger)font color:(NSUInteger)color alignment:(NSTextAlignment)alignment text:(NSString*)text holder:(NSString*)holder;
- (void)setDelegate:(id<UITextFieldDelegate>)delegate clearMode:(UITextFieldViewMode)mode returnKeyType:(UIReturnKeyType)type;

- (UIView*)leftWidthView:(CGFloat)width;
- (UIView*)rightWidthView:(CGFloat)width;
@end
