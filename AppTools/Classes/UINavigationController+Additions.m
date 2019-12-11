//
//  UINavigationController+Additions.m
//  TBBusiness
//
//  Created by 韩琼 on 14-7-22.
//  Copyright (c) 2014年 Taobao. All rights reserved.
//

#import "ATLog.h"
#import "MBProgressHUD.h"
#import "ATNotification.h"
#import "ATWebViewController.h"
#import "NSString+Additions.h"
#import "UIAlertView+Blocks.h"
#import "UIApplication+Additions.h"
#import "UIViewController+Additions.h"
#import "UINavigationController+Additions.h"

static NSMutableArray* stack = nil;
static NSMutableArray* history = nil;

@implementation ATNavigationController
- (instancetype)init {
    if ((self = [super init]) == nil) {
        return nil;
    }
    self.delegate = self;
    return self;
}

- (void)pushViewController:(UIViewController*)viewController animated:(BOOL)animated {
    [super pushViewController:viewController animated:animated];
}

- (UIViewController*)popViewControllerAnimated:(BOOL)animated {
    NSArray* stack = [UINavigationController stack];
    NSArray* controllers = self.viewControllers;
    if (controllers.count > stack.count) {
#ifdef DEBUG
        [ATNotification showMessage:@"部分页面的跳转没有使用BusLine"];
#endif
    }
    else if (stack.count < 2 || controllers.count < 2) {
#ifdef DEBUG
        [ATNotification showMessage:@"BusLine与Navigation堆栈要崩溃了"];
        NSLog(@"%@", [UINavigationController history]);
#endif
    }
    else {
        NSString* stackURL = stack[stack.count-2];
        UIViewController* controller = controllers[controllers.count-2];
        if (![stackURL isEqualToString:controller.action.url]) {
            UIViewController* contoller = [UINavigationController viewControllerWithURL:stackURL];
            NSMutableArray* viewControllers = [NSMutableArray arrayWithArray:self.viewControllers];
            [viewControllers insertObject:contoller atIndex:viewControllers.count-1];
            self.viewControllers = viewControllers;
        }
        [UINavigationController record:nil]; // 因为侧滑手势不一定返回上一页面，所以不能每次pop都要调用该代码
    }
    
    return [super popViewControllerAnimated:animated];
}

#pragma mark - UINavigationControllerDelegate
- (void)navigationController:(UINavigationController*)navigation didShowViewController:(UIViewController*)controller animated:(BOOL)animated {
    [ATLog show:NSStringFromClass(controller.class)];
}

@end

@implementation UINavigationController (Additions)

+ (instancetype)sharedInstance {
    return [[UIApplication sharedApplication] navigationController];
}

+ (UIView*)topView {
    return [UINavigationController sharedInstance].topViewController.view;
}

#pragma mark - 【pop】相关
+ (void)pop {
    [UINavigationController pop:nil];
}
+ (void)pop:(UINavigationCallback)complete {
    UINavigationController* navigation = [UINavigationController sharedInstance];
    if (navigation.visibleViewController.presentingViewController) {
        [navigation.visibleViewController dismissViewControllerAnimated:YES completion:^{
            [UINavigationController record:nil];
            if (complete) {
                complete(navigation.visibleViewController);
            }
        }];
        return;
    }
    [navigation popViewControllerAnimated:YES];
    if (complete) {
        complete(navigation.topViewController);
    }
}
+ (void)popToRoot {
    [UINavigationController popToRoot:nil];
}
+ (void)popToRoot:(UINavigationCallback)complete {
    UINavigationController* navigation = [UINavigationController sharedInstance];
    [navigation popToRootViewControllerAnimated:YES];
    if (complete != nil) {
        complete(navigation.topViewController);
    }
}

#pragma mark - 【push】相关
+ (void)pushURL:(NSString*)URLString {
    [UINavigationController pushURL:URLString complete:nil];
}
+ (void)pushURL:(NSString*)URLString parameters:(NSDictionary*)params {
    NSMutableString* parameters = [NSMutableString string];
    [params enumerateKeysAndObjectsUsingBlock:^(NSString* key, NSString* value, BOOL *stop) {
        [parameters appendString:@"&"];
        [parameters appendString:key];
        [parameters appendString:@"="];
        [parameters appendString:value];
    }];
    if (parameters.length > 0) {
        [parameters deleteCharactersInRange:NSMakeRange(0, 1)];
    }
    if ([URLString rangeOfString:@"?"].location == NSNotFound) {
        [UINavigationController pushURL:[URLString stringByAppendingFormat:@"?%@", parameters]];
    }
    else {
        [UINavigationController pushURL:[URLString stringByAppendingFormat:@"&%@", parameters]];
    }
}
+ (void)pushURL:(NSString*)URLString complete:(UINavigationCallback)complete {
    [UINavigationController pushAction:[ATURLAction actionWithURLString:URLString] complete:complete];
}
+ (void)pushFormatURL:(NSString*)URLString, ... {
    va_list args;
    va_start(args, URLString);
    URLString = [[NSString alloc] initWithFormat:URLString arguments:args];
    va_end(args);
    [UINavigationController pushAction:[ATURLAction actionWithURLString:URLString] complete:nil];
}

#pragma mark - [pushAction:complete:]所有的跳转函数都是通过该方法跳转
+ (void)pushAction:(ATURLAction*)action {
    [UINavigationController pushAction:action complete:nil];
}
+ (void)pushAction:(ATURLAction*)action complete:(UINavigationCallback)complete {
//    if (action.needLogin && ![TBConfig sharedInstance].user.isLogin && [action.clazzName rangeOfString:@"Login"].location == NSNotFound) {
//        [UINavigationController pushFormatURL:@"$://Login?_source=%@", action.url.encodeURL];
//        return;
//    }
    
    UIViewController* controller = nil;
    [UINavigationController record:action.url];
    UINavigationController* navigation = [UINavigationController sharedInstance];
    switch (action.type) {
        case ATURLActionTypePop: {
            [UINavigationController pop];
            break;
        }
        case ATURLActionTypeNative:
        case ATURLActionTypeH5Online:
        case ATURLActionTypeH5Offline: {
            controller = [UINavigationController viewControllerWithAction:action];
            switch (action.mode) {
                case ATModePush: {
                    [navigation pushViewController:controller animated:action.animated];
                    break;
                }
                case ATModePresent: {
                    controller.modalTransitionStyle = action.style;
                    [navigation presentViewController:controller animated:action.animated completion:nil];
                    break;
                }
            }
            break;
        }
        case ATURLActionTypeSystem: {
            [[UIApplication sharedApplication] openURL:action.URL];
            break;
        }
        case ATURLActionTypeUnknown: {
            UIView* rootView = [UIApplication.sharedApplication keyViewController].view;
            MBProgressHUD* HUD = [MBProgressHUD showHUDAddedTo:rootView animated:YES];
            HUD.removeFromSuperViewOnHide = YES;
            HUD.labelText = @"无法识别的URL";
            [HUD hide:YES afterDelay:1.0];
            break;
        }
    }
    if (complete) {
        complete(controller);
    }
    if (action.type != ATURLActionTypeUnknown && [action.parameters[@"_finish"] boolValue]) {
        [[UINavigationController stack] deleteAtIndex:-2];
        NSMutableArray* viewControllers = [NSMutableArray arrayWithArray:navigation.viewControllers];
        [viewControllers removeObjectAtIndex:viewControllers.count-2];
        navigation.viewControllers = viewControllers;
    }
}

+ (void)hideNavigationBar {
    UINavigationController* navigation = [UINavigationController sharedInstance];
    if (!navigation.navigationBarHidden) {
        [navigation setNavigationBarHidden:YES animated:YES];
    }
}
+ (void)showNavigationBar {
    UINavigationController* navigation = [UINavigationController sharedInstance];
    if (navigation.navigationBarHidden) {
        [navigation setNavigationBarHidden:NO animated:YES];
    }
}

#pragma mark - 【推送】相关
+ (void)handleRRCode:(NSString*)qrcode {
    if (qrcode.isAppURL) {
        [UINavigationController showNavigationBar];
        [UINavigationController pop];
        [[UIApplication sharedApplication] openURL:qrcode.URL];
    }
    else if (qrcode.isWebURL || qrcode.isBusLine) {
        [UINavigationController showNavigationBar];
        [UINavigationController pushURL:qrcode];
    }
    else if (qrcode.length > 0) {
        [[UIAlertView.alloc initWithTitle:@"二维码" message:qrcode cancelButtonItem:[RIButtonItem itemWithLabel:@"好" action:^{
        }] otherButtonItems:[RIButtonItem itemWithLabel:@"复制" action:^{
            [UIPasteboard generalPasteboard].string = qrcode;
        }], nil] show];
    }
    else {
        [[UIAlertView.alloc initWithTitle:@"无法识别" message:nil delegate:nil cancelButtonTitle:@"好" otherButtonTitles:nil] show];
    }
}
+ (BOOL)handleURL:(NSURL*)url from:(NSString*)app {
    UIViewController* controller = [UIApplication.sharedApplication visibleViewController];
    CGFloat delay = 3.0;
    if (controller) {
        delay = 1.0;
        MBProgressHUD* HUD = [MBProgressHUD showHUDAddedTo:controller.view animated:YES];
        HUD.removeFromSuperViewOnHide = YES;
        [HUD hide:YES afterDelay:delay];
    }
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(delay * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [UINavigationController pushURL:url.absoluteString];
    });
    return YES;
}
+ (BOOL)handleNotification:(NSDictionary*)userInfo {
    [UIApplication sharedApplication].applicationIconBadgeNumber = 0; // 清空AppIcon的提示数字
    switch ([UIApplication sharedApplication].applicationState) {
        case UIApplicationStateActive: {
            [UINavigationController pushURL:userInfo[@"url"]];
            break;
        }
        case UIApplicationStateInactive:
        case UIApplicationStateBackground: {
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                [UINavigationController pushURL:userInfo[@"url"]];
            });
            break;
        }
        default: {
            break;
        }
    }
    return YES;
}

#pragma mark - 通过URL获取Controller实例
+ (UIViewController*)viewControllerWithURL:(NSString*)URLString {
    ATURLAction* action = [ATURLAction actionWithURLString:URLString];
    if (action == nil) {
        return nil;
    }
    return [UINavigationController viewControllerWithAction:action];
}
+ (UIViewController*)viewControllerWithAction:(ATURLAction*)action {
    switch (action.type) {
        case ATURLActionTypeNative:
        case ATURLActionTypeH5Online:
        case ATURLActionTypeH5Offline: {
            UIViewController<ATURLActionDelegate>* controller = nil;
            if ([action.clazz instancesRespondToSelector:@selector(initWithAction:)]) {
                controller = [[action.clazz alloc] initWithAction:action];
            }
            else {
                controller = [[action.clazz alloc] init];
            }
            controller.action = action;
            if (action.parameters[@"_title"]) {
                controller.title = action.parameters[@"_title"];
            }
            if (action.parameters[@"_tabimg"]) {
                NSString* image = action.parameters[@"_tabimg"];
                controller.tabBarItem.image         = [UIImage imageNamed:[NSString stringWithFormat:@"%@1", image]];
                controller.tabBarItem.selectedImage = [UIImage imageNamed:[NSString stringWithFormat:@"%@2", image]];
            }
            return controller;
        }
        case ATURLActionTypePop:
        case ATURLActionTypeSystem:
        case ATURLActionTypeUnknown: {
            return nil;
        }
    }
    return nil;
}

#pragma mark - 【堆栈】历史URL堆栈
+ (NSMutableArray*)stack {
    if (stack == nil) {
        stack = [NSMutableArray array];
    }
    return stack;
}
+ (NSMutableArray*)history {
    if (history == nil) {
        history = [NSMutableArray array];
    }
    return history;
}
+ (void)record:(NSString*)url {
    if (url) {
        [[UINavigationController stack] addObject:url];
        [[UINavigationController history] addObject:url];
    }
    else {
        [[UINavigationController stack] removeLastObject];
        [[UINavigationController history] addObject:@"$://pop"];
    }
}

+ (void)didReceiveMemoryWarning {
    UINavigationController* navigation = [UINavigationController sharedInstance];
    if (navigation.viewControllers.count <= 2) {
        UIViewController* controller = navigation.viewControllers.lastObject;
        NSString* url = controller.action.url;
#ifndef TAGERT_MTL
        [ATNotification showFormatMessage:@"谁写的垃圾代码，二级以内页面就内存警告啦?\n%@", url];
#endif
        return;
    }
    
    NSMutableArray* controllers = [NSMutableArray array];
    [navigation.viewControllers enumerateObjectsUsingBlock:^(UIViewController* controller, NSUInteger idx, BOOL *stop) {
        if (idx == 0 || idx == navigation.viewControllers.count - 1) {
            [controllers addObject:controller];
            return;
        }
        if (![controller isKindOfClass:ATWebViewController.class]) {
            [controllers addObject:controller];
        }
    }];
    if (controllers.count == navigation.viewControllers.count) {
#ifndef TAGERT_MTL
        [ATNotification showMessage:@"只剩下首页、尾页、不可删除的页面了!"];
#endif
        // [controllers removeObjectsInRange:NSMakeRange(1, controllers.count - 2)];
        NSMutableArray* array = [NSMutableArray array];
        [controllers enumerateObjectsUsingBlock:^(UIViewController* controller, NSUInteger idx, BOOL *stop) {
            if (idx == 0 || idx == navigation.viewControllers.count - 1) {
                [array addObject:controller];
            }
            else if ([controller respondsToSelector:@selector(needPersist)]) {
                NSNumber* persist = [controller performSelector:@selector(needPersist)];
                if (persist.boolValue) {
                    [array addObject:controller];
                }
            }
        }];
        controllers = array;
    }
    else {
#ifndef TAGERT_MTL
        [ATNotification showMessage:@"H5页面被清空了！"];
#endif
    }
    navigation.viewControllers = controllers;
}

@end
