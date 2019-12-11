//
//  UIViewController+Additions.h
//  TBBusiness
//
//  Created by 韩琼 on 14-5-9.
//  Copyright (c) 2014年 Taobao. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ATConfig.h"
#import "ATURLAction.h"

@interface UIViewController (Additions)

@property(nonatomic, strong) ATURLAction* action;

@property(nonatomic, assign, readonly) ATConfig* config;
@property(nonatomic, assign, readonly) BOOL isPresented;

- (void)setLeftNaviBtnImage:(NSString*)name target:(id)target action:(SEL)action;
- (void)setRightNaviBtnImage:(NSString*)name target:(id)target action:(SEL)action;

- (void)setLeftNaviBtnTitle:(NSString*)title target:(id)target action:(SEL)action;
- (void)setRightNaviBtnTitle:(NSString*)title target:(id)target action:(SEL)action;

- (void)setNavigationBarTitle:(NSString*)title;
- (void)setNavigationBarTitle:(NSString*)title fontSize:(CGFloat)size color:(NSUInteger)color;

@end
