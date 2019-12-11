//
//  TBConfigManager.h
//  tbreader-universal
//
//  Created by 韩 琼 on 13-5-25.
//  Copyright (c) 2013年 tbreader. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreGraphics/CoreGraphics.h>

#define kTBConfigNetwork @"kTBConfigNetwork"

static NSString* kSettingEnvironment = @"kSettingEnvironment";       // type NSNumber NSInteger

typedef NS_ENUM(NSInteger, ATEnvironment) {
	ATEnvironmentRelease = 0,
    ATEnvironmentPrepare,
    ATEnvironmentDeveloper
};

@interface ATConfig : NSObject

#pragma mark AppInfo
@property(nonatomic, strong) NSString* appKey;          // appId
@property(nonatomic, strong) NSString* appSecret;       // appId对应的密钥
@property(nonatomic, strong) NSString* appName;         // app中文名（字符串)
@property(nonatomic, strong) NSString* appVersion;      // app版本号（字符串）
@property(nonatomic, strong) NSString* appAppleId;      // app在AppStore对应的苹果ID
@property(nonatomic, strong) NSString* appBundleId;     // app标识符(com.***.***)
@property(nonatomic, strong) NSString* appBuildVersion; // app编译对应的svn版本号
@property(nonatomic, strong) NSString* appScheme;       // app的scheme:标识符的最后一个名子
@property(nonatomic, strong) NSString* appTTID;         // appId对应的渠道id
@property(nonatomic, strong) NSString* appUUID;         // app的UUID，用于iBeancon技术
@property(nonatomic, strong) NSString* appPrefix;       // app所有类的前缀

@property(nonatomic, strong) NSString* mapKey;      // 高德地图SDK对应的appKey

@property(nonatomic, strong) NSString* URLHost;     // app对应的基础域名:http://m.taobao.com/
@property(nonatomic, strong) NSString* URLConfig;   // app对应的配置项URL

#pragma mark DeviceInfo
@property(nonatomic, strong) NSString* deviceName;   // 设备的型号名
@property(nonatomic, strong) NSString* deviceIMEI;   // 设备的唯一ID
@property(nonatomic, strong) NSString* deviceIMSI;   // 设备的唯一ID
@property(nonatomic, strong) NSString* deviceUDID;   // 设备的唯一ID
@property(nonatomic, strong) NSString* deviceVersion;// 系统版本号
@property(nonatomic, strong) NSString* deviceToken;

#pragma mark PathInfo
@property(nonatomic, strong) NSString* pathWeb;               // @"**.app/www"
@property(nonatomic, strong) NSString* pathBundle;             // @"**.app"
@property(nonatomic, strong) NSString* pathDocument;           // @"Documents"
@property(nonatomic, strong) NSString* pathInbox;              // @"Documents/Inbox"
@property(nonatomic, strong) NSString* pathCache;              // @"Library/Cache"
@property(nonatomic, strong) NSString* pathApplicationSupport; // @"Library/Application Support"
@property(nonatomic, strong) NSString* pathDataBase;           // @"Library/Application Support/config.db"
@property(nonatomic, strong) NSString* pathWebCache;           // @"Library/Application Support/webcahe"
@property(nonatomic, strong) NSString* pathPluginsH5;          // @"Library/Application Support/plugins.h5"
@property(nonatomic, strong) NSString* pathPluginsWax;         // @"Library/Application Support/plugins.wax"
@property(nonatomic, strong) NSString* pathPluginsWaxTmp;      // @"Library/Application Support/plugins.wax.tmp
@property(nonatomic, strong) NSString* pathTBImageDecoded;     // @"Library/Application Support/plugins.tbimage"

#pragma mark AlipayInfo
@property(nonatomic, strong) NSString* alipayId;     // 支付宝提供淘宝app的id

#pragma mark WebInfo
@property(nonatomic, strong) NSString* localHost;    // 本地WebSever的域名
@property(nonatomic, strong) NSString* localPort;    // 本地WebSever的端口号
@property(nonatomic, strong) NSString* urlBase;      // 动态配置:app对应的服务器的域名，有日常、预发、线上等环境配置
@property(nonatomic, strong) NSString* urlMtop;      // 动态配置:mtop的域名，有日常、预发、线上，三种环境
@property(nonatomic, strong) NSString* urlMtopHttps; // 动态配置:mtop的域名，有日常、预发、线上，三种环境
@property(nonatomic, strong) NSString* platform;     // 动态配置:android=1；iphone=2；ipad=3；apad=4；
@property(nonatomic, strong) NSString* h5UrlBase;    // h5URL地址

#pragma mark SystemInfo
@property(nonatomic, assign) CGFloat scale;        // 屏幕的密度
@property(nonatomic, assign) BOOL isSimulator;    // 是否是模拟器
@property(nonatomic, assign) BOOL isJailbroken;    // 是否越狱
@property(nonatomic, assign) BOOL isFisrtStartApp; // 是否首次启动
@property(nonatomic, assign) BOOL isOpenUserTrack; // 是否打开用户跟踪

#pragma mark JSBridge回调脚本
@property(nonatomic, strong) NSString* scriptSuccess;  // @"aebridge.nativeCallback('%@', true, '%@')";
@property(nonatomic, strong) NSString* scriptFailure;  // @"aebridge.nativeCallback('%@', false, '%@')";
@property(nonatomic, strong) NSString* scriptDispatch; // @"document.dispatchEvent(aetools.createEvent('%@', '%@'));";

#pragma mark App间跳转的参数，mm是为了纪念alimama
@property(nonatomic, strong) NSString* mmId;

#pragma mark 自定义的小于30s的短音频文件，使用这个播放，高效简单
@property(nonatomic, strong) NSMutableArray* words;
@property(nonatomic, strong) NSMutableDictionary* sounds;

+ (instancetype)sharedInstance;

/** debug环境 */
- (void)debugEnvironmentRun:(void(^)(void))block;

/** 版本兼容判断 */
- (void)runWithVersion:(NSString*)version before:(void(^)(void))beforeBlock after:(void(^)(void))afterBlock;

/** 是否开启了消息推送机制 */
- (BOOL)isEnabledNotification;

/** 获取AppStore最新的版本号和更新信息：result:BOOL，message:message */
- (void)checkOnlineVersion;

/** 获取当前局域网IP地址 */
- (NSString*)ipAddress;

/** 播放自定义的小于30s的音频文件 */
- (void)playSound:(NSString*)filename;

/** 设置全局的皮肤风格 */
- (void)updateAppStyle;

- (NSAttributedString*)randomWord;
@end
