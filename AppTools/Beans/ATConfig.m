//
//  TBConfigManager.m
//  tbreader-universal
//
//  Created by 韩 琼 on 13-5-25.
//  Copyright (c) 2013年 tbreader. All rights reserved.
//

#import <net/if.h>
#import <ifaddrs.h>
#import <arpa/inet.h>
#import <sys/sysctl.h>
#import <AudioToolbox/AudioToolbox.h>

#import "ATConfig.h"
#import "ATURLCache.h"
#import "AFNetworking.h"
#import "UIColor+Additions.h"
#import "NSString+Additions.h"
#import "UIAlertView+Blocks.h"
#import "NSFileManager+Additions.h"

#define PATH1 @"/Applications/Cydia.app"
#define PATH2 @"/private/var/lib/apt/"

@interface ATConfig()

@end

@implementation ATConfig

static ATConfig* instance = nil;

+ (instancetype)sharedInstance {
    if (instance == nil) {
        instance = [[ATConfig alloc] init];
    }
    return instance;
}

- (instancetype)init {
    if ((self = [super init]) == nil) {
        return nil;
    }
    
    NSDictionary* bundleInfo = [NSBundle.mainBundle infoDictionary];
    self.appKey = @"";
    self.appSecret = @"";
    self.appName = bundleInfo[@"CFBundleDisplayName"];
    self.appVersion = bundleInfo[@"CFBundleShortVersionString"];
    self.appAppleId = @"544654590";
    self.appBundleId = bundleInfo[@"CFBundleIdentifier"];
    self.appBuildVersion = bundleInfo[@"CFBundleVersion"];
    self.appScheme = @"aese";//[[[self.appBundleId componentsSeparatedByString:@"."] lastObject] lowercaseString];
    self.appTTID = [NSString stringWithFormat:@"201200@%@_iphone_%@", self.appScheme, self.appVersion];
    self.appUUID = @"E2C56DB5-DFFB-48D2-B060-D0F5A71096E0";
    self.appPrefix = @"GD";
    
    self.mapKey = @"06c7747319dfc5b74525ebc4eba89d6e";
#ifdef TAGERT_MTL
    self.mapKey = @"1202c62138c0502589705c64d480ca34";
#endif
    self.URLHost = @"http://m.taobao.com";
    self.URLConfig = @"http://10.68.196.165/1.0/config.json";
    
    self.deviceName = [self platformName];
    self.deviceIMEI = self.deviceIMSI = self.deviceUDID = [self UDID];
    self.deviceVersion = [UIDevice.currentDevice systemVersion];
    
    self.pathWeb = [NSBundle.mainBundle pathForResource:@"www" ofType:nil];
    self.pathBundle = [NSBundle.mainBundle resourcePath];
    self.pathDocument = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES)[0];
    self.pathInbox = [self.pathDocument stringByAppendingPathComponent:@"Inbox"];
    self.pathCache = NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES)[0];
    self.pathApplicationSupport = NSSearchPathForDirectoriesInDomains(NSApplicationSupportDirectory, NSUserDomainMask, YES)[0];
    self.pathDataBase = [self.pathApplicationSupport stringByAppendingPathComponent:@"config1.db"];
    self.pathWebCache = [self.pathCache stringByAppendingPathComponent:@"com.hackemist.SDWebImageCache.default"]; // Libary/Cache/com.xxxxx
    self.pathPluginsH5 = [self.pathApplicationSupport stringByAppendingPathComponent:@"plugins.h5"];
    self.pathPluginsWax = [self.pathApplicationSupport stringByAppendingPathComponent:@"plugins.wax"];
    self.pathPluginsWaxTmp = [self.pathApplicationSupport stringByAppendingPathComponent:@"plugins.wax.tmp"];
    self.pathTBImageDecoded = [self.pathApplicationSupport stringByAppendingPathComponent:@"plugins.tbimage"];
    
    self.alipayId = @"2013092600001699";
    
    NSDictionary* configs = [NSDictionary dictionaryWithContentsOfFile:[NSBundle.mainBundle pathForResource:@"config" ofType:@"plist"]];
    self.localHost = configs[@"localHost"];
    self.localPort = configs[@"localPort"];
    self.urlBase   = @"http://www.taobao.com";
    self.urlMtop   = @"http://api.m.taobao.com/rest/api3.do";
    self.urlMtopHttps = @"https://api.m.taobao.com/rest/api3.do";
    self.platform     = @"ios";
    self.h5UrlBase    = @"http://h5.m.taobao.com";
    
    self.scale = [UIScreen mainScreen].scale;
    self.isSimulator = [self.deviceName rangeOfString:@"Simulator"].location != NSNotFound;
    self.isJailbroken = [NSFileManager.defaultManager fileExistsAtPath:PATH1] || [NSFileManager.defaultManager fileExistsAtPath:PATH2];
    self.isFisrtStartApp = [self.appVersion floatValue] > [[NSUserDefaults.standardUserDefaults stringForKey:@"config_app_version"] floatValue];
    self.isOpenUserTrack = [configs[@"isOpenUserTrack"] boolValue];
    
    self.scriptSuccess = @"aebridge.nativeCallback('%@', true, %@);";
    self.scriptFailure = @"aebridge.nativeCallback('%@', false, %@);";
    self.scriptDispatch = @"document.dispatchEvent(aetools.createEvent('%@', %@));";
    
    self.mmId = nil;
    
    self.words = [NSMutableArray array];
    self.sounds = [NSMutableDictionary dictionary];
    
    [NSNotificationCenter.defaultCenter addObserver:self selector:@selector(onStop) name:UIApplicationDidEnterBackgroundNotification object:nil];
    [NSNotificationCenter.defaultCenter addObserver:self selector:@selector(onResume) name:UIApplicationWillEnterForegroundNotification object:nil];
    
    // ------------创建iCloud不同步的文件夹------------
    [NSFileManager.defaultManager addSkipBackupAttributeForPath:self.pathWebCache];
    [NSFileManager.defaultManager addSkipBackupAttributeForPath:self.pathPluginsH5];
    [NSFileManager.defaultManager addSkipBackupAttributeForPath:self.pathPluginsWax];
    [NSFileManager.defaultManager addSkipBackupAttributeForPath:self.pathPluginsWaxTmp];
    [NSFileManager.defaultManager addSkipBackupAttributeForPath:self.pathTBImageDecoded];
    // ------------保存当前到版本号到配置文件中----------
    [NSUserDefaults.standardUserDefaults setObject:self.appVersion forKey:@"config_app_version"];
    [NSUserDefaults.standardUserDefaults synchronize];
    
    return self;
}

- (void)debugEnvironmentRun:(void(^)(void))block {
    if ([[NSUserDefaults.standardUserDefaults objectForKey:kSettingEnvironment] integerValue] == ATEnvironmentDeveloper) {
        block();
    }
}

- (void)runWithVersion:(NSString *)version before:(void (^)(void))beforeBlock after:(void (^)(void))afterBlock {
    NSComparisonResult result = [self.deviceVersion compare:version options:NSNumericSearch];
    switch (result) {
        case NSOrderedAscending: {
            if (beforeBlock != nil) {
                beforeBlock();
            }
            break;
        }
        case NSOrderedSame:
        case NSOrderedDescending: {
            if (afterBlock != nil) {
                afterBlock();
            }
            break;
        }
        default: {
            break;
        }
    }
}

- (BOOL)isEnabledNotification {
    return [UIApplication.sharedApplication isRegisteredForRemoteNotifications];
}

- (void)checkOnlineVersion {
    NSString* url = [@"http://itunes.apple.com/lookup?id=%@" stringByAppendingString:self.appAppleId];
    
    NSURLRequest* request = [NSURLRequest.alloc initWithURL:[NSURL URLWithString:url]];
    [AFHTTPSessionManager.manager dataTaskWithRequest:request completionHandler:^(NSURLResponse* response, NSDictionary* rets, NSError* error) {
        if (error || ![rets isKindOfClass:NSDictionary.class]) {
            return;
        }
        @try {
            NSString* version = [rets[@"results"][0] objectForKey:@"version"];
            NSString* message = [rets[@"results"][0] objectForKey:@"releaseNotes"];
            if (version == nil) {
                return;
            }
            BOOL hasUpdate = [self.appVersion compare:version options:NSNumericSearch] == NSOrderedAscending;
            if (hasUpdate) {
                RIButtonItem* cancel = [RIButtonItem itemWithLabel:@"好"];
                RIButtonItem* update = [RIButtonItem itemWithLabel:@"更新" action:^{
                    [[UIApplication sharedApplication] openURL:@"http://www.taobao.com".URL];;
                }];
                [[UIAlertView.alloc initWithTitle:@"发现新版本" message:message cancelButtonItem:cancel otherButtonItems:update, nil] show];
            }
        }
        @catch (NSException* e) {
        }
    }];
}

/** 获取当前局域网IP地址 */
- (NSString*)ipAddress {
    NSString* address = nil;
    struct ifaddrs* addresses;
    if (getifaddrs(&addresses) == 0) {
        const struct ifaddrs* cursor = addresses;
        while (cursor != NULL) {
            if (cursor->ifa_addr->sa_family == AF_INET && (cursor->ifa_flags & IFF_LOOPBACK) == 0) {
                address = [NSString stringWithUTF8String:inet_ntoa(((struct sockaddr_in*)cursor->ifa_addr)->sin_addr)];
                break;
            }
            cursor = cursor->ifa_next;
        }
        freeifaddrs(addresses);
    }
    return address;
}

- (void)playSound:(NSString*)filename {
    if (self.sounds[filename] == nil) {
        SystemSoundID soundId;
        NSURL* pathfile = [NSBundle.mainBundle URLForResource:filename withExtension:nil];
        AudioServicesCreateSystemSoundID((__bridge CFURLRef)pathfile, &soundId);
        if (soundId > 0) {
            self.sounds[filename] = @(soundId);
        }
    }
    NSNumber* soundId = self.sounds[filename];
    AudioServicesPlaySystemSound(soundId.unsignedIntValue);
}

- (void)updateAppStyle {    
    [NSURLCache setSharedURLCache:ATURLCache.new];
    
    switch (ATEnvironmentDeveloper) {
        case ATEnvironmentRelease: {
            self.urlMtop      = @"http://api.m.taobao.com/rest/api3.do";
            self.urlMtopHttps = @"https://api.m.taobao.com/rest/api3.do";
            self.h5UrlBase    = @"http://h5.m.taobao.com";
            break;
        }
        case ATEnvironmentPrepare: {
            self.urlMtop      = @"http://api.wapa.taobao.com/rest/api3.do";
            self.urlMtopHttps = @"https://api.wapa.taobao.com/rest/api3.do";
            self.h5UrlBase    = @"http://h5.m.taobao.com";
            break;
        }
        case ATEnvironmentDeveloper: {
            self.urlMtop      = @"http://api.waptest.taobao.com/rest/api3.do";
            self.urlMtopHttps = @"http://api.waptest.taobao.com/rest/api3.do";
            self.h5UrlBase    = @"http://wapp.waptest.taobao.com";
            break;
        }
    }
    
    [UITabBar.appearance setTranslucent:YES]; // 朗英：这句话会动态调整UIWebView的大小,从iOS8.0开始支持
    // [UITabBar.appearance setTintColor:UIColor.whiteColor];
    // [UITabBar.appearance setBarTintColor:[UIColor RGBAColor:0x464646FF]];

    NSDictionary* map = @{NSForegroundColorAttributeName:UIColor.whiteColor, NSFontAttributeName:[UIFont boldSystemFontOfSize:20]};
    [UINavigationBar.appearance setTranslucent:YES];
    [UINavigationBar.appearance setTintColor:UIColor.whiteColor]; // 返回按钮字体颜色
    [UINavigationBar.appearance setBarTintColor:[UIColor RGBAColor:0x2D83F0FF]]; // 导航栏背景颜色
    [UINavigationBar.appearance setTitleTextAttributes:map];
    [UIBarButtonItem.appearance setBackButtonTitlePositionAdjustment:UIOffsetMake(-100, 0) forBarMetrics:UIBarMetricsDefault]; // 不显示返回文字
    
    [UISegmentedControl.appearance setBackgroundColor:UIColor.whiteColor];
    [UISegmentedControl.appearance setTintColor:[UIColor RGBAColor:0x2A75E6FF]];
    [UISegmentedControl.appearance setTitleTextAttributes:@{NSForegroundColorAttributeName:[UIColor RGBAColor:0x2A75E6FF]} forState:UIControlStateNormal];
    [UISegmentedControl.appearance setTitleTextAttributes:@{NSForegroundColorAttributeName:UIColor.whiteColor} forState:UIControlStateHighlighted];
}

- (NSAttributedString*)randomWord {
    return self.words[arc4random() % self.words.count];
}

#pragma mark 内部方法
- (void)onStop {
    self.mmId = nil;
}

- (void)onResume {
}

- (NSString*)UDID {
//    KeychainItemWrapper* wrapper = [[KeychainItemWrapper.alloc initWithIdentifier:@"config_device_udid" accessGroup:nil] autorelease];
//    NSString* udid = [wrapper objectForKey:kSecValueData];
//    if (udid != nil && udid.length > 0) {
//        return udid;
//    }
//    udid = [[[UIDevice.currentDevice identifierForVendor] UUIDString] md5];
//    [wrapper setObject:udid forKey:kSecValueData];
//    return udid;
    return [[[UIDevice.currentDevice identifierForVendor] UUIDString] md5];
}

// 内部方法，获取设备的型号名
-(NSString*)platformName {
    size_t size;
    sysctlbyname("hw.machine", NULL, &size, NULL, 0);
    char* machine = malloc(size);
    sysctlbyname("hw.machine", machine, &size, NULL, 0);
    NSString* platform = [NSString stringWithUTF8String:machine];
    free(machine);
    

    if ([platform isEqualToString:@"iPhone1,1"])    return @"iPhone 1G";
    if ([platform isEqualToString:@"iPhone1,2"])    return @"iPhone 3G";
    if ([platform isEqualToString:@"iPhone2,1"])    return @"iPhone 3GS";
    if ([platform isEqualToString:@"iPhone3,1"])    return @"iPhone 4 (GSM)";
    if ([platform isEqualToString:@"iPhone3,2"])    return @"iPhone 4 (GSM Rev A)";
    if ([platform isEqualToString:@"iPhone3,3"])    return @"iPhone 4 (CDMA)";
    if ([platform isEqualToString:@"iPhone4,1"])    return @"iPhone 4S";
    if ([platform isEqualToString:@"iPhone5,1"])    return @"iPhone 5 (GSM)";
    if ([platform isEqualToString:@"iPhone5,2"])    return @"iPhone 5 (Global)";
    if ([platform isEqualToString:@"iPhone5,3"])    return @"iPhone 5c (GSM)";
    if ([platform isEqualToString:@"iPhone5,4"])    return @"iPhone 5c (Global)";
    if ([platform isEqualToString:@"iPhone6,1"])    return @"iPhone 5s (GSM)";
    if ([platform isEqualToString:@"iPhone6,2"])    return @"iPhone 5s (Global)";
    if ([platform isEqualToString:@"iPhone7,1"])    return @"iPhone 6 Plus";
    if ([platform isEqualToString:@"iPhone7,2"])    return @"iPhone 6";
    
    // iPad http://theiphonewiki.com/wiki/IPad
    if ([platform isEqualToString:@"iPad1,1"])      return @"iPad 1G";
    if ([platform isEqualToString:@"iPad2,1"])      return @"iPad 2 (WiFi)";
    if ([platform isEqualToString:@"iPad2,2"])      return @"iPad 2 (GSM)";
    if ([platform isEqualToString:@"iPad2,3"])      return @"iPad 2 (CDMA)";
    if ([platform isEqualToString:@"iPad2,4"])      return @"iPad 2 (Rev A)";
    if ([platform isEqualToString:@"iPad3,1"])      return @"iPad 3 (WiFi)";
    if ([platform isEqualToString:@"iPad3,2"])      return @"iPad 3 (GSM)";
    if ([platform isEqualToString:@"iPad3,3"])      return @"iPad 3 (Global)";
    if ([platform isEqualToString:@"iPad3,4"])      return @"iPad 4 (WiFi)";
    if ([platform isEqualToString:@"iPad3,5"])      return @"iPad 4 (GSM)";
    if ([platform isEqualToString:@"iPad3,6"])      return @"iPad 4 (Global)";
    if ([platform isEqualToString:@"iPad4,1"])      return @"iPad Air (WiFi)";
    if ([platform isEqualToString:@"iPad4,2"])      return @"iPad Air (Cellular)";
    
    // iPad Mini http://theiphonewiki.com/wiki/IPad_mini
    if ([platform isEqualToString:@"iPad2,5"])      return @"iPad mini 1G (WiFi)";
    if ([platform isEqualToString:@"iPad2,6"])      return @"iPad mini 1G (GSM)";
    if ([platform isEqualToString:@"iPad2,7"])      return @"iPad mini 1G (Global)";
    if ([platform isEqualToString:@"iPad4,4"])      return @"iPad mini 2G (WiFi)";
    if ([platform isEqualToString:@"iPad4,5"])      return @"iPad mini 2G (Cellular)";
    
    // iPod http://theiphonewiki.com/wiki/IPod
    if ([platform isEqualToString:@"iPod1,1"])      return @"iPod touch 1G";
    if ([platform isEqualToString:@"iPod2,1"])      return @"iPod touch 2G";
    if ([platform isEqualToString:@"iPod3,1"])      return @"iPod touch 3G";
    if ([platform isEqualToString:@"iPod4,1"])      return @"iPod touch 4G";
    if ([platform isEqualToString:@"iPod5,1"])      return @"iPod touch 5G";
    
    // Simulator
    if ([platform hasSuffix:@"86"] || [platform isEqual:@"x86_64"]) {
        BOOL smallerScreen = ([[UIScreen mainScreen] bounds].size.width < 768.0);
        return (smallerScreen ? @"iPhone Simulator" : @"iPad Simulator");
    }
    
    return platform;
}

@end
