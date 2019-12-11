//
//  EKEventStore+Additions.h
//  TBSport
//
//  Created by 韩 琼 on 13-10-7.
//  Copyright (c) 2013年 taobao. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <EventKit/EventKit.h>

typedef void(^EKEventStoreSuccess)(BOOL granted);
typedef void(^EKEventStoreFailure)(BOOL granted, NSString* error);

@interface EKEventStore (Additions)

+ (void)addEvent:(NSString*)title location:(NSString*)location start:(NSDate*)start end:(NSDate*)end userInfo:(NSDictionary*)userInfo success:(EKEventStoreSuccess)success failure:(EKEventStoreFailure)failure;

@end
