//
//  AEActionDO.m
//  TBBusiness
//
//  Created by 韩琼 on 14-4-18.
//  Copyright (c) 2014年 Taobao. All rights reserved.
//

#import <objc/runtime.h>
#import "ATConfig.h"
#import "ATURLAction.h"
#import "NSString+Additions.h"

@implementation ATURLAction

+ (instancetype)actionWithURLString:(NSString*)URLString {
    // 将$://替换为sechme://
    ATConfig* config = [ATConfig sharedInstance];
    NSString* scheme = [NSString stringWithFormat:@"%@://", config.appScheme];
    NSURL* url = [NSURL URLWithString:[URLString stringByReplacingOccurrencesOfString:@"$://" withString:scheme]];
    if (url == nil) {
        return nil;
    }
    
    ATURLAction* action = [[ATURLAction alloc] init];
    action.url      = URLString;
    action.host     = url.host;
    action.path     = url.path;
    action.scheme   = url.scheme;
    action.fragment = url.fragment;
    [action.parameters addEntriesFromDictionary:url.query.dictionaryForURL]; // 获取userInfo数据，必须是json格式
    
    action.parameters[@"_bdid"] = config.appBundleId   ?: @"";
    action.parameters[@"_name"] = config.deviceName.encodeURL ?: @"";
    action.parameters[@"_sysv"] = config.deviceVersion ?: @"";
    action.parameters[@"_ttid"] = config.appTTID       ?: @"";
    action.parameters[@"_uuid"] = config.deviceUDID    ?: @"";
    action.parameters[@"_appv"] = config.appVersion    ?: @"";
    action.parameters[@"_mmid"] = config.mmId          ?: @"";
    
    if ([action.scheme isEqualToString:config.appScheme]) {
        if (action.host.length <= 0) {
            action.type = ATURLActionTypeUnknown;
        }
        else if (action.isDownload) {
            action.type = ATURLActionTypeH5Offline;
        }
        else if (action.nativeClass) {
            action.type = ATURLActionTypeNative;
        }
        else if ([action.host isEqualToString:@"pop"]) {
            action.type = ATURLActionTypePop;
        }
        else {
            action.type = ATURLActionTypeH5Online;
        }
    }
    else if ([action.scheme hasPrefix:@"http"]) {
        // 直接打开在线URL
        action.type = ATURLActionTypeH5Online;
    }
    else if ([[UIApplication sharedApplication] canOpenURL:url]) {
        // 交给系统处理
        action.type = ATURLActionTypeSystem;
    }
    else {
        // 未知的URL，就跳转到错误页面吧
        action.type = ATURLActionTypeUnknown;
    }

    return action;
}

- (instancetype)init {
    if ((self = [super init]) == nil) {
        return nil;
    }
    self.parameters = [NSMutableDictionary dictionaryWithCapacity:4];
    return self;
}

/**
 * _free   默认0:不释放；1：可释放可恢复；2：可释放不需恢复
 * _mmid   阿里妈妈点击id，用户跟踪用户点击
 * _mode   打开模式，默认是0:push;1:present
 * _time   用户点击时间，精度到秒的整数
 * _type   默认0：不可释放；1：可以释放，可以恢复；2：直接释放，不需要恢复
 * _anim   是否启用动画，默认是YES
 * _style  打开动画方式
 * _title  设置NavigationViewController的标题
 * _finish 启动新的视图后，是否结束当前视图
 * _tabimg 视图在tabbarController中显示，tabbar的icon设置
 * _rburl  右上角点击后跳转URL
 * _rbname 右上角按钮的标题
 * _rbicon 右上角按钮的图片
 * _login  默认0:不需要登录;1:需要登录
 */
- (ATMode)mode {
    return [self.parameters[@"_mode"] integerValue];
}
- (ATFree)free {
    return [self.parameters[@"_free"] integerValue];
}
- (UIModalTransitionStyle)style {
    return [self.parameters[@"_style"] integerValue];
}
- (BOOL)finish {
    NSString* anim = self.parameters[@"_finish"];
    return anim.length > 0 ? [anim boolValue] : YES;
}
- (BOOL)animated {
    NSString* anim = self.parameters[@"_anim"];
    return anim.length > 0 ? [anim boolValue] : YES;
}
- (BOOL)needLogin {
    NSString* value = self.parameters[@"_login"];
    if (value && ![value boolValue]) { // 强制指定不需要登录，就会忽略[Class needLogin]方法
        return NO;
    }
    id clazz = objc_getClass(self.clazzName.UTF8String);
    if ([clazz respondsToSelector:@selector(needLogin)]) {
        NSNumber* ret = [clazz performSelector:@selector(needLogin) withObject:nil];
        return [ret boolValue] || [value boolValue];
    }
    return [value boolValue];
}

- (NSURL*)URL {
    return [NSURL URLWithString:self.URLString];
}

- (NSString*)URLString {
    NSString* url = nil;
    ATConfig* config = [ATConfig sharedInstance];
    switch (self.type) {
        case ATURLActionTypePop:
        case ATURLActionTypeNative:
        case ATURLActionTypeSystem:
        case ATURLActionTypeUnknown:
        case ATURLActionTypeH5Online: {
            NSMutableString* query = [NSMutableString stringWithString:self.url.stringByRomoveQuery];
            [query appendString:@"?"];
            for (NSString* key in self.parameters.allKeys) {
                [query appendFormat:@"%@=%@&", key, [self.parameters[key] encodeURL]];
            }
            [query deleteCharactersInRange:NSMakeRange(query.length - 1, 1)];
            [query appendString:@"#"];
            [query appendString:self.fragment ?: @""];
            url = query;
            if (self.type == ATURLActionTypeH5Online) {
                NSString* scheme = [NSString stringWithFormat:@"%@://", config.appScheme];
                url = [url stringByReplacingOccurrencesOfString:@"$://" withString:scheme];
                url = [url stringByReplacingOccurrencesOfString:scheme withString:@"http://"];
            }
            break;
        }
        case ATURLActionTypeH5Offline: {
            url = [NSString stringWithFormat:@"%@/%@/index.html", config.pathPluginsH5, self.host];
            if (url.isFileNotExist) {
                url = [NSString stringWithFormat:@"%@/%@/index.html", config.pathWeb, self.host];
            }
            NSMutableString* buf = [NSMutableString string];
            for (NSString* key in self.parameters) {
                [buf appendFormat:@"%@=%@&", key, self.parameters[key]];
            }
            [buf deleteCharactersInRange:NSMakeRange(buf.length - 1, 1)];
            url = [NSString stringWithFormat:@"file://%@?%@", url, buf];
            break;
        }
    }
    return url;
}
- (BOOL)isInnerURL {
    if ([@"http" isEqualToString:self.scheme] || [@"https" isEqualToString:self.scheme]) {
        return [self.parameters[@"_inner"] boolValue];
    }
    return NO;
}


- (BOOL)isDownload {
    ATConfig* config = [ATConfig sharedInstance];
    NSString* pathfile = [NSString stringWithFormat:@"%@/%@/index.html", config.pathPluginsH5, self.host];
    if ([pathfile isFileExist]) {
        return YES;
    }
    pathfile = [NSString stringWithFormat:@"%@/%@/index.html", config.pathWeb, self.host];
    return pathfile.isFileExist;
}
- (BOOL)isNotDownload {
    return !self.isDownload;
}

- (Class)clazz {
    Class clazz = nil;
    switch (self.type) {
        case ATURLActionTypeH5Online:
        case ATURLActionTypeH5Offline:
            clazz = NSClassFromString(@"ATWebViewController") ?: NSClassFromString(@"TSViewController");
            break;
        case ATURLActionTypeNative:
            clazz = [self nativeClass];
            break;
        case ATURLActionTypeSystem:
        case ATURLActionTypeUnknown:
            break;
        default:
            break;
    }
    return clazz;
}
- (NSString*)clazzName {
    return NSStringFromClass(self.clazz);
}

- (SEL)method {
    return NSSelectorFromString(self.path);
}
- (NSString*)methodName {
    return self.path;
}

#pragma mark Private_Methods
- (Class)nativeClass {
    ATConfig* config = [ATConfig sharedInstance];
    NSString* className = [NSString stringWithFormat:@"%@%@ViewController", config.appPrefix, self.host];
    Class clazz = NSClassFromString(className);
    if (clazz == nil) {
        className = [NSString stringWithFormat:@"AE%@ViewController", self.host];
        clazz = NSClassFromString(className);
    }
    return clazz;
}

@end
