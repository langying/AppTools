//
//  UINavigationController+Additions.h
//  TBBusiness
//
//  Created by 韩琼 on 14-7-22.
//  Copyright (c) 2014年 Taobao. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "ATURLAction.h"

typedef void(^UINavigationCallback)(UIViewController* controller);

@interface ATNavigationController : UINavigationController<UINavigationControllerDelegate>
@end

@interface UINavigationController (Additions)

+ (instancetype)sharedInstance;

+ (UIView*)topView;

+ (void)pop;
+ (void)pop:(UINavigationCallback)block;
+ (void)popToRoot;
+ (void)popToRoot:(UINavigationCallback)block;

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
 * _source 登录页面完成后，跳转的URL，如果为nil，则直接pop[注：如果已经有_login参数，则无需明文设置_source]
 */
+ (void)pushURL:(NSString*)URLString;
+ (void)pushURL:(NSString*)URLString parameters:(NSDictionary*)params;
+ (void)pushURL:(NSString*)URLString complete:(UINavigationCallback)callback;
+ (void)pushFormatURL:(NSString*)URLString, ... NS_FORMAT_FUNCTION(1,2);
+ (void)pushAction:(ATURLAction*)action;
+ (void)pushAction:(ATURLAction*)action complete:(UINavigationCallback)callback;

+ (void)hideNavigationBar;
+ (void)showNavigationBar;

+ (void)handleRRCode:(NSString*)qrocde;
+ (BOOL)handleURL:(NSURL*)url from:(NSString*)app;
+ (BOOL)handleNotification:(NSDictionary*)userInfo;

+ (UIViewController*)viewControllerWithURL:(NSString*)URLString;
+ (UIViewController*)viewControllerWithAction:(ATURLAction*)action;

+ (NSMutableArray*)stack;
+ (NSMutableArray*)history;
+ (void)record:(NSString*)url;
+ (void)didReceiveMemoryWarning;

@end
