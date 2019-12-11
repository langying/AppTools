//
//  UIColor+ARGB.h
//  TBImageCache
//
//  Created by 韩 琼 on 13-10-7.
//  Copyright (c) 2013年 taobao. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UITableView (Additions)

- (void)setRow:(CGFloat)row section:(CGFloat)section separator:(NSUInteger)separator;
- (void)setDelegate:(id<UITableViewDelegate>)delegate dataSource:(id<UITableViewDataSource>)dataSource;
- (void)setInsetSeparator:(UIEdgeInsets)separator content:(UIEdgeInsets)content scrollIndicator:(UIEdgeInsets)scrollIndicator;
- (void)setSectionIndexColor:(NSUInteger)color backgroundColor:(NSUInteger)backgroundColor trackingBackgroundColor:(NSUInteger)trackingBackgroundColor;

- (void)reloadSection:(NSInteger)section;

@end
