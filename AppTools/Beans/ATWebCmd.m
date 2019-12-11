//
//  TSCommand.m
//  TBImageCache
//
//  Created by 韩琼 on 14-3-28.
//  Copyright (c) 2014年 taobao. All rights reserved.
//

#import "ATWebCmd.h"

@implementation ATWebCmd

+ (instancetype)cmdWithInfo:(NSArray*)info {
    if (info == nil || info.count < 4) {
        return nil;
    }
    
    ATWebCmd* command = [[ATWebCmd alloc] init];
    command.clazz = info[0];
    command.method = [NSString stringWithFormat:@"%@:", info[1]];
    command.params = info[2];
    command.callbackId = info[3];
    command.result = [NSMutableDictionary dictionaryWithCapacity:8];
    
    // 兼容手淘，虽然，但我(朗英)仍坚持自己的命名规则
    if ([@"MtopWVPlugin" isEqualToString:command.clazz]) {
        command.clazz = @"Mtop";
    }
    else if ([@"Base" isEqualToString:command.clazz]) {
        command.clazz = @"BasePlugin";
    }
    return command;
}

- (NSArray*)paramArray {
    if ([self.params isKindOfClass:NSArray.class]) {
        return self.params;
    }
    return nil;
}

- (NSString*)paramString {
    if ([self.params isKindOfClass:NSString.class]) {
        return self.params;
    }
    return nil;
}

- (NSDictionary*)paramMap {
    if ([self.params isKindOfClass:NSDictionary.class]) {
        return self.params;
    }
    return nil;
}

- (NSString*)description {
    return [NSString stringWithFormat:@"%@:%@.%@%@;\nresult:%@", self.callbackId, self.clazz, self.method, self.params, self.result];
}
@end
