//
//  UIScrollView+Additions.h
//  TBBusiness
//
//  Created by 韩琼·朗英 on 14/11/5.
//  Copyright (c) 2014年 Taobao. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface UIScrollView (Additions)

@property(nonatomic, assign) CGFloat offsetX;
@property(nonatomic, assign) CGFloat offsetY;
@property(nonatomic, assign) CGFloat insetTop;
@property(nonatomic, assign) CGFloat insetBottom;
@property(nonatomic, assign) BOOL    showIndicator;

- (void)fitToBounce;
- (void)scrollToBottom;
- (void)cancelAutoAdjustInsets;
- (void)scrollToView:(UIView*)view bottom:(NSInteger)bottom;
- (void)setInsetContent:(UIEdgeInsets)content scrollIndicator:(UIEdgeInsets)scrollIndicator;

@end
