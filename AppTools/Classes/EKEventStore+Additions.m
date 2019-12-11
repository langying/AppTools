//
//  EKEventStore+Additions.h
//  TBSport
//
//  Created by 韩 琼 on 13-10-7.
//  Copyright (c) 2013年 taobao. All rights reserved.
//

#import <objc/runtime.h>
#import "MBProgressHUD.h"
#import "NSDate+Additions.h"
#import "UIActionSheet+Blocks.h"
#import "EKEventStore+Additions.h"

@implementation EKEventStore (Additions)

+ (void)addEvent:(NSString*)title location:(NSString*)location start:(NSDate*)start end:(NSDate*)end userInfo:(NSDictionary*)userInfo success:(EKEventStoreSuccess)success failure:(EKEventStoreFailure)failure {
    EKEventStore* store = [[EKEventStore alloc] init];
    [store requestAccessToEntityType:EKEntityTypeEvent completion:^(BOOL granted, NSError* error) {
        dispatch_async(dispatch_get_main_queue(), ^{
            if (error) {
                [[UIApplication sharedApplication] scheduleLocalNotification:({
                    UILocalNotification* notification = [[UILocalNotification alloc] init];
                    notification.alertAction      = title;
                    notification.alertBody        = [start stringWithFormat:@"即将开启(mm:ss)"];
                    notification.fireDate         = [start dateByAddingTimeInterval:-60*15];
                    notification.userInfo         = userInfo;
                    notification.soundName        = UILocalNotificationDefaultSoundName;
                    notification;
                })];
                if (failure) { failure(granted, error.domain); }
                return;
            }
            
            NSError* err = nil;
            EKEvent* event = [EKEvent eventWithEventStore:store];
            event.title     = title;
            event.location  = location;
            event.startDate = start;
            event.endDate   = end;
            event.calendar  = [store defaultCalendarForNewEvents];
            [event addAlarm:[EKAlarm alarmWithRelativeOffset:-60*60]];
            [event addAlarm:[EKAlarm alarmWithRelativeOffset:-60*15]];
            [store saveEvent:event span:EKSpanThisEvent error:&err];
            if (err) {
                [[UIApplication sharedApplication] scheduleLocalNotification:({
                    UILocalNotification* notification = [[UILocalNotification alloc] init];
                    notification.alertAction      = title;
                    notification.alertBody        = [start stringWithFormat:@"即将开启(mm:ss)"];
                    notification.fireDate         = [start dateByAddingTimeInterval:-60*15];
                    notification.userInfo         = userInfo;
                    notification.soundName        = UILocalNotificationDefaultSoundName;
                    notification;
                })];
                if (failure) { failure(granted, err.domain); }
                return;
            }
            
            if (success) { success(granted); }
        });
    }];
}

@end
