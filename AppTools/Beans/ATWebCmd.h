//
//  AECommand.h
//  TBImageCache
//
//  Created by 韩琼 on 14-3-28.
//  Copyright (c) 2014年 taobao. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ATWebCmd : NSObject

@property(nonatomic, strong) NSString* clazz;
@property(nonatomic, strong) NSString* method;
@property(nonatomic, strong) id params;
@property(nonatomic, strong) NSString* callbackId;
@property(nonatomic, strong) NSMutableDictionary* result;
@property(nonatomic, strong) id userInfo;

+ (instancetype)cmdWithInfo:(NSArray*)info;

- (NSArray*)paramArray;
- (NSString*)paramString;
- (NSDictionary*)paramMap;

@end
