//
//  AEActionDO.h
//  TBBusiness
//
//  Created by 韩琼 on 14-4-18.
//  Copyright (c) 2014年 Taobao. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void(^ATURLActionComplete)(BOOL success, NSString* msg);

typedef NS_ENUM(NSUInteger, ATMode) {
    ATModePush,
    ATModePresent,
};
typedef NS_ENUM(NSUInteger, ATFree) {
    ATFreeStrong,
    ATFreeWeak,
    ATFreeTemp
};
typedef NS_ENUM(NSInteger, ATURLActionType) {
    ATURLActionTypeUnknown = 0,
    ATURLActionTypePop,
    ATURLActionTypeNative,
    ATURLActionTypeSystem,
    ATURLActionTypeH5Online,
    ATURLActionTypeH5Offline
};

@interface ATURLAction : NSObject

@property(nonatomic, assign) ATURLActionType type;            // URL的Type
@property(nonatomic, strong) NSString* url;                   // 原始URL
@property(nonatomic, strong) NSString* host;                  // host
@property(nonatomic, strong) NSString* path;                  // path路径
@property(nonatomic, strong) NSString* scheme;                // url的scheme
@property(nonatomic, strong) NSString* fragment;              // fragment路径
@property(nonatomic, strong) NSMutableDictionary* parameters; // 参数对:默认添加一些字段，见实现类的代码

@property(nonatomic, strong) NSString* md5;
@property(nonatomic, strong) NSString* version;
@property(nonatomic, strong) NSString* downloadURL;

// sms:// 可以调用短信程序
// tel:// 可以拨打电话
// itms:// 可以打开MobileStore.app
// audio-player-event:// 可以打开iPod
// audio-player-event://?uicmd=show-purchased-playlist 可以打开iPod播放列表
// video-player-event:// 可以打开iPod中的视频
+ (instancetype)actionWithURLString:(NSString*)URLString;

- (ATMode)mode;
- (ATFree)free;
- (UIModalTransitionStyle)style;
- (BOOL)finish;
- (BOOL)animated;
- (BOOL)needLogin;

- (NSURL*)URL;
- (NSString*)URLString;

- (Class)clazz;
- (NSString*)clazzName;

- (SEL)method;
- (NSString*)methodName;

- (BOOL)isInnerURL;
- (BOOL)isDownload;
- (BOOL)isNotDownload;


@end

@protocol ATURLActionDelegate<NSObject>
@optional
- (instancetype)initWithAction:(ATURLAction*)action;
- (void)onLocate:(NSDictionary*)location;
- (void)onRestart:(id)userInfo;
+ (NSNumber*)needLogin;
+ (NSNumber*)needPersist;
@end
