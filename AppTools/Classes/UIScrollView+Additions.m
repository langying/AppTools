//
//  UIScrollView+Additions.m
//  TBBusiness
//
//  Created by 韩琼·朗英 on 14/11/5.
//  Copyright (c) 2014年 Taobao. All rights reserved.
//

#import "UIView+Additions.h"
#import "UIScrollView+Additions.h"

@implementation UIScrollView (Additions)

#pragma mark - offsetX
- (CGFloat)offsetX {
    return self.contentOffset.x;
}
- (void)setOffsetX:(CGFloat)contentOffsetX {
    CGPoint point = self.contentOffset;
    point.x = contentOffsetX;
    self.contentOffset = point;
}
#pragma mark - offsetY
- (CGFloat)offsetY {
    return self.contentOffset.y;
}
- (void)setOffsetY:(CGFloat)contentOffsetY {
    CGPoint point = self.contentOffset;
    point.y = contentOffsetY;
    self.contentOffset = point;
}
#pragma mark - insetTop
- (CGFloat)insetTop {
    return self.contentInset.top;
}
- (void)setInsetTop:(CGFloat)insetTop {
    UIEdgeInsets inset = self.contentInset;
    inset.top          = insetTop;
    self.contentInset  = inset;
}
#pragma mark - insetBottom
- (CGFloat)insetBottom {
    return self.contentInset.bottom;
}
- (void)setInsetBottom:(CGFloat)insetBottom {
    UIEdgeInsets inset = self.contentInset;
    inset.bottom       = insetBottom;
    self.contentInset  = inset;
}
#pragma mark - showsScrollIndicator
- (BOOL)showIndicator {
    return self.showsVerticalScrollIndicator || self.showsVerticalScrollIndicator;
}
- (void)setShowIndicator:(BOOL)showIndicator {
    self.showsVerticalScrollIndicator   = showIndicator;
    self.showsHorizontalScrollIndicator = showIndicator;
}

- (void)fitToBounce {
    __block CGFloat height = 0;
    [self.subviews enumerateObjectsUsingBlock:^(UIView* view, NSUInteger idx, BOOL *stop) {
        if (!view.hidden) {
            height = height > view.bottom ? height : view.bottom;
        }
    }];
    height = height > self.height ? height : self.height + 1;
    self.contentSize = CGSizeMake(self.width, height);
}

- (void)scrollToBottom {
    CGFloat dy = self.contentSize.height + self.contentInset.bottom - self.frame.size.height;
    if (dy > 0) {
        [self setContentOffset:CGPointMake(0, dy) animated:YES];
    }
}

- (void)cancelAutoAdjustInsets {
    SEL method = NSSelectorFromString(@"setContentInsetAdjustmentBehavior:");
    if ([UIScrollView instancesRespondToSelector:method]) {
        [self performSelector:method withObject:@2];
    }
    [self setInsetContent:UIEdgeInsetsZero scrollIndicator:UIEdgeInsetsZero];
}

- (void)scrollToView:(UIView*)view bottom:(NSInteger)bottom {
    NSInteger height = view.height;
    do {
        height += view.top;
        view = view.superview;
    }
    while (view && view != self);
    
    NSInteger dy = ((self.offsetY + self.height) - height) - bottom;
    CGPoint offset = self.contentOffset;
    offset.y = offset.y - dy;
    [self setContentOffset:offset animated:YES];
}

- (void)setInsetContent:(UIEdgeInsets)content scrollIndicator:(UIEdgeInsets)scrollIndicator {
    self.contentInset = content;
    self.scrollIndicatorInsets = scrollIndicator;
}

@end
