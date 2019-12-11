//
//  TBMtopTool.m
//  TBImageCache
//
//  Created by 韩 琼 on 13-10-9.
//  Copyright (c) 2013年 taobao. All rights reserved.
//

#import "Base64.h"
#import "ATConfig.h"
#import "ATMtop.h"
#import "NSData+Additions.h"
#import "NSDate+Additions.h"
#import "NSString+Additions.h"

@implementation ATMtop

+ (NSString*)urlWithAPI:(NSString*)api version:(NSString*)version sid:(NSString*)sid ecode:(NSString*)ecode data:(NSDictionary*)datas {
    NSDictionary* prams = [ATMtop paramsWithAPI:api version:version sid:sid ecode:ecode data:datas];
    NSMutableString* content = [NSMutableString stringWithCapacity:1024];
    for (id key in [prams allKeys]) {
        [content appendFormat:@"%@=%@&", key, ([key isEqualToString:@"data"] ? [prams[key] encodeURL] : prams[key])];
    }
    [content deleteCharactersInRange:NSMakeRange(content.length - 1, 1)];
    return [NSString stringWithFormat:@"%@?%@", [ATConfig sharedInstance].urlMtop, content];
}

+ (NSDictionary*)paramsWithAPI:(NSString*)api version:(NSString*)version sid:(NSString*)sid ecode:(NSString*)ecode data:(NSDictionary*)datas {
    version = (version == nil ? @"*" : version);
    NSString* data = [datas JSONString];
    NSString* time = [NSDate.date stringWithFormat:@"yyyyMMddHHmmss"];
    ATConfig* config = [ATConfig sharedInstance];
    
    NSMutableDictionary* params = [NSMutableDictionary dictionary];
    [params setObject:@"md5" forKey:@"authType"];
    [params setObject:api forKey:@"api"];
    [params setObject:version forKey:@"v"];
    [params setObject:time forKey:@"t"];
    [params setObject:config.deviceIMEI forKey:@"imei"];
    [params setObject:config.deviceIMSI forKey:@"imsi"];
    [params setObject:config.deviceUDID forKey:@"deviceId"];
    [params setObject:config.appKey forKey:@"appKey"];
    [params setObject:config.appTTID forKey:@"ttid"];
    [params setObject:data forKey:@"data"];
    [params setObject:[ATMtop signWithAPI:api version:version sid:sid ecode:ecode data:data time:time] forKey:@"sign"];
    [params setObject:(sid == nil ? @"" : sid) forKey:@"sid"];
    return params;
}

+ (NSString*)signWithAPI:(NSString*)api version:(NSString*)version sid:(NSString*)sid ecode:(NSString*)ecode data:(NSString*)data time:(NSString*)time {
    NSString* content = [ATConfig sharedInstance].appSecret;
    content = [content stringByAppendingFormat:@"&%@", [[ATConfig sharedInstance].appKey md5]];
    content = [content stringByAppendingFormat:@"&%@", api];
    content = [content stringByAppendingFormat:@"&%@", version];
    content = [content stringByAppendingFormat:@"&%@", [ATConfig sharedInstance].deviceIMEI];
    content = [content stringByAppendingFormat:@"&%@", [ATConfig sharedInstance].deviceIMSI];
    content = [content stringByAppendingFormat:@"&%@", [data md5]];
    content = [content stringByAppendingFormat:@"&%@", time];
    if ([ecode length] > 0) {
        content = [NSString stringWithFormat:@"%@&%@", ecode, content];
    }
    return [content md5];
}

@end
