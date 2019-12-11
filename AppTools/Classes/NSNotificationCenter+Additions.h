//
//  NSNotificationCenter+Additions.h
//  TBBusiness
//
//  Created by 韩琼·朗英 on 14/10/20.
//  Copyright (c) 2014年 Taobao. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSNotificationCenter (Additions)

- (void)postOnMainThreadName:(NSString*)name object:(id)obj;

- (void)postOnMainThreadName:(NSString*)name object:(id)obj userInfo:(NSDictionary*)userInfo;

@end
