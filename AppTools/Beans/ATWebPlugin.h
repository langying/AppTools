//
//  AEPlugin.h
//  TBBusiness
//
//  Created by 韩琼·朗英 on 14-8-4.
//  Copyright (c) 2014年 Taobao. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "ATWebCmd.h"
#import "ATWebViewController.h"

@interface ATWebPlugin : NSObject

// 此处改为assign,避免循环引用
@property(nonatomic, assign) UIWebView* webview;

- (instancetype)initWithWebview:(UIWebView*)webview;

- (void)onInit;

- (void)onResume;

- (void)onPause;

- (void)onDestory;

- (void)onDeviceOrientation;

- (void)error:(ATWebCmd*)command;

- (void)failure:(ATWebCmd*)command;

- (void)success:(ATWebCmd*)command;

- (void)execute:(NSString*)script async:(BOOL)async;

- (void)dispatchEvent:(NSString*)event params:(NSString*)params;

@end
