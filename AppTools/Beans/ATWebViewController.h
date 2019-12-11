//
//  ATWebViewController.h
//  TBBusiness
//
//  Created by 韩琼 on 14-4-19.
//  Copyright (c) 2014年 Taobao. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "ATURLAction.h"
#define BRIDGE_KEY_ELEMENT_ID @"elementId"
#define ATWebViewControllerNotification @"ATWebViewControllerNotification"


@interface ATWebRefreshView : UIView

@property(nonatomic, strong) UILabel* title;
@property(nonatomic, strong) UIImageView* icon;
@property(nonatomic, assign) BOOL uping;
@property(nonatomic, assign) CGFloat maxOffset;

- (void)setOffset:(CGFloat)offset;

@end


@interface ATWebViewController : UIViewController

- (instancetype)initWithAction:(ATURLAction*)action;

- (void)loadURL:(NSString*)url;

- (void)dispatchEvent:(NSString*)event params:(NSString*)params;

@end
