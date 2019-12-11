//
//  UIColor+ARGB.m
//  TBImageCache
//
//  Created by 韩 琼 on 13-10-7.
//  Copyright (c) 2013年 taobao. All rights reserved.
//

#import "UIView+Additions.h"
#import "UIColor+Additions.h"
#import "UITextField+Additions.h"

@implementation UITextField (Additions)

- (void)setIcon:(NSString*)icon {
    [[self leftWidthView:44] addSubview:({
        [[UIImageView alloc] initWithImage:[UIImage imageNamed:icon]];
    }) layout:UILayoutCenter offset:CGSizeZero];
}
- (void)setFont:(NSInteger)font color:(NSUInteger)color alignment:(NSTextAlignment)alignment text:(NSString*)text holder:(NSString*)holder {
    self.font          = [UIFont systemFontOfSize:font];
    self.textColor     = [UIColor RGBAColor:color];
    self.textAlignment = alignment;
    self.text          = text;
    self.placeholder   = holder;
}
- (void)setDelegate:(id<UITextFieldDelegate>)delegate clearMode:(UITextFieldViewMode)mode returnKeyType:(UIReturnKeyType)type {
    self.delegate        = delegate;
    self.clearButtonMode = mode;
    self.returnKeyType   = type;
    self.enablesReturnKeyAutomatically = YES;
}

- (UIView*)leftWidthView:(CGFloat)width {
    if (self.leftView) {
        return self.leftView;
    }
    self.leftViewMode = UITextFieldViewModeAlways;
    self.leftView = [[UIView alloc] initWithWidth:width height:self.height];
    return self.leftView;
}
- (UIView*)rightWidthView:(CGFloat)width {
    if (self.rightView) {
        return self.rightView;
    }
    self.rightViewMode = UITextFieldViewModeAlways;
    self.rightView = [[UIView alloc] initWithWidth:width height:self.height];
    return self.rightView;
}

@end
