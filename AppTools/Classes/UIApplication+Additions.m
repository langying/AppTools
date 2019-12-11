//
//  UIApplication+Additions.m
//  TBBusiness
//
//  Created by 韩琼 on 14-5-5.
//  Copyright (c) 2014年 Taobao. All rights reserved.
//

#import <MediaPlayer/MediaPlayer.h>
#import <AudioToolbox/AudioToolbox.h>

#import "UIApplication+Additions.h"

@implementation UIApplication (Additions)

- (void)_suspend {
    [self performSelector:@selector(suspend)];
}

- (UIWindow*)windowForLevel:(UIWindowLevel)level {
    UIWindow* window = [[UIApplication sharedApplication] keyWindow];
    if(window.windowLevel == level) {
        return window;
    }
    NSArray* windows = [[UIApplication sharedApplication] windows];
    for (UIWindow* win in windows) {
        if (win.windowLevel == level) {
            return win;
        }
    }
    return nil;
}
- (UIViewController*)keyViewController {
    UIWindow* window = [self windowForLevel:UIWindowLevelNormal];
    if ([window subviews].count <= 0) {
        return nil;
    }
    UIViewController* controller = nil;
    UIResponder* responder = [[[window subviews] objectAtIndex:0] nextResponder];
    if ([responder isKindOfClass:[UIViewController class]]) {
        controller = (UIViewController*)responder;
    }
    else {
        controller = window.rootViewController;
    }
    return controller;
}
- (UINavigationController*)navigationController {
    UIWindow* window = [self windowForLevel:UIWindowLevelNormal];
    if ([window.rootViewController isKindOfClass:UINavigationController.class]) {
        return (UINavigationController*)window.rootViewController;
    }
    return nil;
}

- (UIViewController*)visibleViewController {
    UIViewController* controller = [self keyViewController];
    if ([controller isKindOfClass:UINavigationController.class]) {
        return ((UINavigationController*)controller).visibleViewController;
    }
    return controller;
}

- (UINetworkType)networkType {
    Class clazz = [NSClassFromString(@"UIStatusBarDataNetworkItemView") class];
    NSArray* subviews = [[[self valueForKey:@"statusBar"] valueForKey:@"foregroundView"] subviews];
    for (UIView* view in subviews) {
        if([view isKindOfClass:clazz])     {
            NSNumber* value = [view valueForKey:@"dataNetworkType"];
            return [value integerValue];
        }
    }
    return UINetworkTypeNone;
}
@end
