//
//  TSNotification.h
//  TBSport
//
//  Created by 朗英·韩琼 on 15/4/3.
//  Copyright (c) 2015年 taobao. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ATNotification : UIWindow

+(instancetype)sharedInstance;

+ (void)showMessage:(NSString*)message;
+ (void)showFormatMessage:(NSString*)message, ... NS_FORMAT_FUNCTION(1,2);

+ (void)showNotify:(NSString*)message;
+ (void)showFormatNotify:(NSString*)message, ... NS_FORMAT_FUNCTION(1,2);

@end
