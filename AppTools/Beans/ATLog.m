//
//  TT.m
//  TBSport
//
//  Created by 朗英·韩琼 on 15/6/2.
//  Copyright (c) 2015年 taobao. All rights reserved.
//

#import "ATLog.h"

@implementation ATLog

static NSString* last = nil;

+ (void)show:(NSString*)page {
    if (last) {
//        [MobClick endLogPageView:last];
    }
    last = page;
//    [MobClick beginLogPageView:page];
}

+ (void)log:(NSString*)name {
//    [MobClick event:name];
}

@end
