//
//  UIColor+ARGB.m
//  TBImageCache
//
//  Created by 韩 琼 on 13-10-7.
//  Copyright (c) 2013年 taobao. All rights reserved.
//

#import "UIView+Additions.h"
#import "UIColor+Additions.h"
#import "UITextView+Additions.h"

typedef NS_ENUM(NSUInteger, Tag) {
    TagLeft = 1,
    TagRight,
};

@implementation UITextView (Additions)

- (void)setIcon:(NSString*)icon {
    [[self leftWidthView:44] addSubview:({
        [[UIImageView alloc] initWithImage:[UIImage imageNamed:icon]];
    }) layout:UILayoutCenter offset:CGSizeZero];
}
- (void)setDelegate:(id<UITextViewDelegate>)delegate returnKeyType:(UIReturnKeyType)type {
    self.delegate        = delegate;
    self.returnKeyType   = type;
    self.enablesReturnKeyAutomatically = YES;
}
- (void)setFont:(NSInteger)font color:(NSUInteger)color alignment:(NSTextAlignment)alignment text:(NSString*)text {
    self.font          = [UIFont systemFontOfSize:font];
    self.textColor     = [UIColor RGBAColor:color];
    self.textAlignment = alignment;
    self.text          = text;
}

- (UIView*)leftView {
    return [self viewWithTag:TagLeft];
}
- (UIView*)rightView {
    return [self viewWithTag:TagRight];
}
- (UIView*)leftWidthView:(CGFloat)width {
    UIView* view = [self viewWithTag:TagLeft];
    if (view == nil) {
        view = [[UIView alloc] initWithWidth:width height:self.height backgroudColor:0 tag:TagLeft];
        [self addSubview:view layout:UILayoutLVC offset:CGSizeZero];
    }
    if (view.width != width) {
        view.width = width;
    }
    UIEdgeInsets insets = self.textContainerInset;
    insets.left = width;
    self.textContainerInset = insets;
    return view;
}
- (UIView*)rightWidthView:(CGFloat)width {
    UIView* view = [self viewWithTag:TagRight];
    if (view == nil) {
        view = [[UIView alloc] initWithWidth:width height:self.height backgroudColor:0 tag:TagRight];
        [self addSubview:view layout:UILayoutLVC offset:CGSizeZero];
    }
    if (view.width != width) {
        view.width = width;
    }
    UIEdgeInsets insets = self.textContainerInset;
    insets.right = width;
    self.textContainerInset = insets;
    return view;
}

@end
