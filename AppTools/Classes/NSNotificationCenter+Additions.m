//
//  NSNotificationCenter+Additions.m
//  TBBusiness
//
//  Created by 韩琼·朗英 on 14/10/20.
//  Copyright (c) 2014年 Taobao. All rights reserved.
//

#import "NSNotificationCenter+Additions.h"

@implementation NSNotificationCenter (Additions)

- (void)postOnMainThreadName:(NSString*)name object:(id)obj {
    if( [NSThread isMainThread] ){
        [self postNotificationName:name object:obj];
    }
    else {
        dispatch_async(dispatch_get_main_queue(), ^{
            [self postNotificationName:name object:obj];
        });
    }
}

- (void)postOnMainThreadName:(NSString*)name object:(id)obj userInfo:(NSDictionary*)userInfo {
    if( [NSThread isMainThread] ){
        [self postNotificationName:name object:obj userInfo:userInfo];
    }
    else {
        dispatch_async(dispatch_get_main_queue(), ^{
            [self postNotificationName:name object:obj userInfo:userInfo];
        });
    }
}

@end
