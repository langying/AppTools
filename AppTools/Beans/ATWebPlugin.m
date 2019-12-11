//
//  AEPlugin.m
//  TBBusiness
//
//  Created by 韩琼·朗英 on 14-8-4.
//  Copyright (c) 2014年 Taobao. All rights reserved.
//

#import "ATConfig.h"
#import "ATWebPlugin.h"
#import "UIView+Additions.h"
#import "NSString+Additions.h"
#import "UIWebView+Additions.h"

@implementation ATWebPlugin

- (instancetype)initWithWebview:(UIWebView*)webview {
    if ((self = [super init]) == nil) {
        return nil;
    }
    self.webview = webview;
    return self;
}

- (void)onInit {
}

- (void)onResume {
}

- (void)onPause {
}

- (void)onDestory {
}

- (void)onDeviceOrientation {
}

- (void)error:(ATWebCmd*)command {
    [self failure:command];
}

- (void)failure:(ATWebCmd*)command {
    if (command.callbackId.length <= 0) {
        return;
    }
    NSData* data = [NSJSONSerialization dataWithJSONObject:command.paramMap options:NSJSONWritingPrettyPrinted error:nil];
    NSString* JSONString = [NSString stringWithUTF8String:data.bytes];
    [self execute:[NSString stringWithFormat:[ATConfig sharedInstance].scriptFailure, command.callbackId, JSONString] async:YES];
}

- (void)success:(ATWebCmd*)command {
    if (command.callbackId.length <= 0) {
        return;
    }
    NSData* data = [NSJSONSerialization dataWithJSONObject:command.result options:NSJSONWritingPrettyPrinted error:nil];
    NSString* JSONString = [NSString.alloc initWithData:data encoding:NSUTF8StringEncoding];
    [self execute:[NSString stringWithFormat:[ATConfig sharedInstance].scriptSuccess, command.callbackId, JSONString] async:YES];
}

- (void)execute:(NSString*)script async:(BOOL)async {
    if (async) {
        script = [NSString stringWithFormat:@"window.setTimeout(function(){%@}, 0);", script];
    }
    [self.webview stringByEvaluatingJavaScriptFromString:script];
}

- (void)dispatchEvent:(NSString*)event params:(NSString*)params {
    ATWebViewController* controller = (ATWebViewController*)[self.webview viewController];
    [controller dispatchEvent:event params:params];
}

@end
