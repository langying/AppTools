//
//  TSNotificationWindow.m
//  TBSport
//
//  Created by 朗英·韩琼 on 15/4/3.
//  Copyright (c) 2015年 taobao. All rights reserved.
//

#import "ATNotification.h"
#import "UIView+Additions.h"
#import "UILabel+Additions.h"

#define HEIGHT 20

@implementation ATNotification

+ (instancetype)sharedInstance {
    static id instance = nil;
    if (instance == nil) {
        instance = [[ATNotification alloc] init];
    }
    return instance;
}

- (void)dealloc {
    [NSNotificationCenter.defaultCenter removeObserver:self];
}

- (id)init {
    CGFloat width = [UIApplication sharedApplication].statusBarFrame.size.width;
    if ((self = [self initWithWidth:width height:HEIGHT backgroudColor:0]) == nil) {
        return nil;
    }
    self.hidden           = NO;
    self.userInteractionEnabled = NO;
    self.windowLevel      = UIWindowLevelStatusBar + 1.0f;
    self.autoresizingMask = UIViewAutoresizingFlexibleWidth;
    
    NSString* notification = UIApplicationWillChangeStatusBarOrientationNotification;
    [NSNotificationCenter.defaultCenter addObserver:self selector:@selector(onOrientation:) name:notification object:nil];
    return self;
}

+ (void)showMessage:(NSString*)message {
    ATNotification* window = [ATNotification sharedInstance];
    UILabel* label = [[UILabel alloc] initWithWidth:window.width height:HEIGHT backgroudColor:LightGreenColor];
    label.textAlignment = NSTextAlignmentCenter;
    [label setFont:12 color:WhiteColor text:message];
    [window addSubview:label layout:UILayoutOutsideTHC offset:CGSizeZero];
    [UIView animateWithDuration:0.5 animations:^{
        label.top = 0;
    } completion:^(BOOL finished) {
        [UIView animateWithDuration:0.5 delay:2 options:UIViewAnimationOptionCurveEaseInOut animations:^{
            label.bottom = 0;
        } completion:^(BOOL finished) {
            [label removeFromSuperview];
        }];
    }];
}
+ (void)showFormatMessage:(NSString*)message, ... {
    va_list args;
    va_start(args, message);
    message = [[NSString alloc] initWithFormat:message arguments:args];
    va_end(args);
    [ATNotification showMessage:message];
}

+ (void)showNotify:(NSString*)message {
    UIApplication* application = [UIApplication sharedApplication];
    switch (application.applicationState) {
        case UIApplicationStateActive: {
            [ATNotification showMessage:message];
            break;
        }
        case UIApplicationStateInactive:
        case UIApplicationStateBackground: {
            [application scheduleLocalNotification:({
                UILocalNotification* notification = [[UILocalNotification alloc] init];
                notification.alertBody   = message;
                notification.alertAction = @"朗英测试";
                notification;
            })];
            break;
        }
    }
}
+ (void)showFormatNotify:(NSString*)message, ... {
    va_list args;
    va_start(args, message);
    message = [[NSString alloc] initWithFormat:message arguments:args];
    va_end(args);
    [ATNotification showNotify:message];
}

#pragma mark - 内部方法
- (void)onOrientation:(NSNotification*)notify {
    CGSize screen = [UIScreen mainScreen].bounds.size;
    UIInterfaceOrientation newOrientation = [[notify.userInfo valueForKey:UIApplicationStatusBarOrientationUserInfoKey] integerValue];
    switch (newOrientation) {
        case UIInterfaceOrientationPortrait: {
            self.transform = CGAffineTransformIdentity;
            self.frame = CGRectMake(0, 0, screen.width, HEIGHT);
            break;
        }
        case UIInterfaceOrientationPortraitUpsideDown: {
            // 先转矩阵，坐标系统落在屏幕有右下角，朝上是y，朝左是x
            self.transform = CGAffineTransformMakeRotation(M_PI);
            self.center = CGPointMake(screen.width / 2, screen.height - HEIGHT / 2);
            self.bounds = CGRectMake(0, 0, screen.width, HEIGHT);
            break;
        }
        case UIInterfaceOrientationLandscapeLeft: {
            self.transform = CGAffineTransformMakeRotation(-M_PI_2);
            // 这个时候坐标轴已经转了90°，调整x相当于调节竖向调节，y相当于横向调节
            self.center = CGPointMake(HEIGHT / 2, screen.height / 2);
            self.bounds = CGRectMake(0, 0, screen.height, HEIGHT);
            break;
        }
        case UIInterfaceOrientationLandscapeRight: {
            // 先设置transform，在设置位置和大小
            self.transform = CGAffineTransformMakeRotation(M_PI_2);
            self.center = CGPointMake(screen.width - HEIGHT / 2, screen.height / 2);
            self.bounds = CGRectMake(0, 0, screen.height, HEIGHT);
            break;
        }
        default: {
            break;
        }
    }
}

@end
