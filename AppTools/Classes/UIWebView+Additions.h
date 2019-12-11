//
//  UIWebView+Additions.h
//  TBBusiness
//
//  Created by 韩琼·朗英 on 14-8-4.
//  Copyright (c) 2014年 Taobao. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIWebView (Additions)

- (BOOL)isPageLoaded;

- (NSString*)locationHref;

- (NSString*)execute:(NSString*)script async:(BOOL)async;

@end
