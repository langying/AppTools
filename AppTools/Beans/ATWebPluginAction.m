//
//  ATWebPluginAction.m
//  AppTools
//
//  Created by 韩琼 on 2018/11/3.
//  Copyright © 2018 Amaze. All rights reserved.
//

#import "ATWebPluginAction.h"
#import "ATWebViewController.h"

#import "UIView+Additions.h"
#import "UINavigationController+Additions.h"

@implementation ATWebPluginAction

- (BOOL)handleRequest:(NSURLRequest*)resquest navigationType:(UIWebViewNavigationType)navigationType {
    return NO;
}

- (void)pop:(ATWebCmd*)command {
    [UINavigationController pop:^(UIViewController* vc) {
        ATWebViewController* controller = (ATWebViewController*)vc;
        if (![controller isKindOfClass:ATWebViewController.class]) {
            return;
        }
        if (command.paramMap.count > 0) {
            NSData* data = [NSJSONSerialization dataWithJSONObject:command.paramMap options:NSJSONWritingPrettyPrinted error:nil];
            NSString* JSONString = [NSString stringWithUTF8String:data.bytes];
            [self dispatchEvent:@"app.frompop" params:JSONString];
        }
    }];
    [self success:command];
}

- (void)popToRoot:(ATWebCmd*)command {
    [UINavigationController popToRoot];
    [self success:command];
}

- (void)pushURL:(ATWebCmd*)command {
    [UINavigationController pushURL:command.params[@"url"]];
    [self success:command];
}

- (void)openBrowser:(ATWebCmd*)command {
    if (command.params[@"url"] != nil && [UIApplication.sharedApplication canOpenURL:command.params[@"url"]]) {
        [UIApplication.sharedApplication openURL:command.params[@"url"]];
        [self success:command];
    }
    else {
        command.result[@"msg"] = @"无法解析的url";
        [self failure:command];
    }
}

- (void)setNavLeftTitle:(ATWebCmd*)command {
    self.webview.viewController.navigationItem.leftBarButtonItem.title = command.params[@"title"];
    [self success:command];
}

- (void)setNavCenterTitle:(ATWebCmd*)command {
    self.webview.viewController.title = command.params[@"title"];
    [self success:command];
}

- (void)setNavRightTitle:(ATWebCmd*)command {
    self.webview.viewController.navigationItem.rightBarButtonItem.title = command.params[@"title"] ?: @"";
    [self success:command];
}

// UINavigationControllerHideShowBarDuration，这个参数是导航栏的动画时间
- (void)hideNavBar:(ATWebCmd*)command {
    BOOL hidden = [command.params[@"hidden"] boolValue];
    [[UINavigationController sharedInstance] setNavigationBarHidden:hidden animated:YES];
    [self success:command];
}

- (void)hideStatusBar:(ATWebCmd*)command {
    BOOL hidden = [command.params[@"hidden"] boolValue];
    [[UINavigationController sharedInstance] setNavigationBarHidden:hidden animated:YES];
    [self success:command];
}

- (void)clearCache:(ATWebCmd*)command {
    [[NSURLCache sharedURLCache] removeAllCachedResponses];
    [self removeApplicationLibraryDirectoryWithDirectory:@"Caches"];
    [self removeApplicationLibraryDirectoryWithDirectory:@"WebKit"];
    for (NSHTTPCookie *cookie in [[NSHTTPCookieStorage sharedHTTPCookieStorage] cookies]) {
        [[NSHTTPCookieStorage sharedHTTPCookieStorage] deleteCookie:cookie];
    }
    [self removeApplicationLibraryDirectoryWithDirectory:@"Cookies"];
}

- (void)removeApplicationLibraryDirectoryWithDirectory:(NSString *)dirName {
    NSString *dir = [[[[NSSearchPathForDirectoriesInDomains(NSApplicationDirectory, NSUserDomainMask, YES) lastObject] stringByDeletingLastPathComponent] stringByAppendingPathComponent:@"Library"] stringByAppendingPathComponent:dirName];
    if ([[NSFileManager defaultManager] fileExistsAtPath:dir]) {
        [[NSFileManager defaultManager] removeItemAtPath:dir error:nil];
    }
}

@end
