//
//  UIApplication+Additions.h
//  TBBusiness
//
//  Created by 韩琼 on 14-5-5.
//  Copyright (c) 2014年 Taobao. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSUInteger, UINetworkType) {
    UINetworkTypeNone,
    UINetworkType2G,
    UINetworkType3G,
    UINetworkType4G,
    UINetworkType5G,
    UINetworkTypeWifi
};

@interface UIApplication (Additions)

- (void)_suspend;
- (UIWindow*)windowForLevel:(UIWindowLevel)level;
- (UIViewController*)keyViewController;
- (UINavigationController*)navigationController;

- (UIViewController*)visibleViewController;

- (UINetworkType)networkType;

@end
