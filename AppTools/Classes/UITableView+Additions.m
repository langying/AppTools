//
//  UIColor+ARGB.m
//  TBImageCache
//
//  Created by 韩 琼 on 13-10-7.
//  Copyright (c) 2013年 taobao. All rights reserved.
//

#import "UIColor+Additions.h"
#import "UITableView+Additions.h"

@implementation UITableView (Additions)

- (void)setRow:(CGFloat)row section:(CGFloat)section separator:(NSUInteger)separator {
    self.rowHeight           = row;
    self.sectionHeaderHeight = section;
    self.separatorColor = [UIColor RGBAColor:separator];
}
- (void)setDelegate:(id<UITableViewDelegate>)delegate dataSource:(id<UITableViewDataSource>)dataSource {
    self.delegate   = delegate;
    self.dataSource = dataSource;
    self.keyboardDismissMode = UIScrollViewKeyboardDismissModeOnDrag;
}
- (void)setInsetSeparator:(UIEdgeInsets)separator content:(UIEdgeInsets)content scrollIndicator:(UIEdgeInsets)scrollIndicator {
    self.separatorInset        = separator;
    self.contentInset          = content;
    self.scrollIndicatorInsets = scrollIndicator;
}
- (void)setSectionIndexColor:(NSUInteger)color backgroundColor:(NSUInteger)backgroundColor trackingBackgroundColor:(NSUInteger)trackingBackgroundColor {
    self.sectionIndexColor                   = [UIColor RGBAColor:color];
    self.sectionIndexBackgroundColor         = [UIColor RGBAColor:backgroundColor];
    self.sectionIndexTrackingBackgroundColor = [UIColor RGBAColor:trackingBackgroundColor];
}

- (void)reloadSection:(NSInteger)section {
    [self reloadSections:[NSIndexSet indexSetWithIndex:section] withRowAnimation:UITableViewRowAnimationAutomatic];
}

@end
