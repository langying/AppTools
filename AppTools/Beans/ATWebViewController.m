//
//  ATWebViewController.m
//  TBBusiness
//
//  Created by 韩琼 on 14-4-19.
//  Copyright (c) 2014年 Taobao. All rights reserved.
//


#import "UIView+Additions.h"
#import "UILabel+Additions.h"
#import "NSString+Additions.h"
#import "UIWebView+Additions.h"
#import "UIActionSheet+Blocks.h"
#import "UIScrollView+Additions.h"
#import "UIViewController+Additions.h"
#import "UINavigationController+Additions.h"

#import "ATWebCmd.h"
#import "ATWebPlugin.h"
#import "MBProgressHUD.h"
#import "NJKWebViewProgress.h"
#import "ATWebViewController.h"
#import "NJKWebViewProgressView.h"

@implementation ATWebRefreshView

- (instancetype)initWithFrame:(CGRect)frame {
    if ((self = [super initWithFrame:frame]) == nil) {
        return nil;
    }
    CGFloat width1 = frame.size.width * 0.4;
    CGFloat width2 = frame.size.width * 0.6 - 10;
    self.maxOffset = -self.height;
    [self addSubview:({
        UIImageView* image = [UIImageView.alloc initWithWidth:40 height:40 backgroudColor:ClearColor];
        image.image = [UIImage imageNamed:@"icon_arrow"];
        self.icon = image;
    }) layout:UILayoutLVC offset:CGSizeMake(width1-50, 0)];
    [self addSubview:({
        UILabel* label = [UILabel.alloc initWithWidth:width2 height:16 backgroudColor:ClearColor];
        [label setFont:14 color:GrayColor text:@"有一种爱叫做放手"];
        self.title = label;
    }) layout:UILayoutRVC offset:CGSizeMake(10, 0)];
    return self;
}

- (void)setOffset:(CGFloat)offset {
    if (offset > _maxOffset) {
        if (_uping) {
            _uping = NO;
            [UIView animateWithDuration:0.25 animations:^{
                self.icon.transform = CGAffineTransformMakeRotation(0);
            }];
        }
    }
    else {
        if (!_uping) {
            _uping = YES;
            [UIView animateWithDuration:0.25 animations:^{
                self.icon.transform = CGAffineTransformMakeRotation(M_PI);
            }];
        }
    }
}

@end



@interface ATWebViewController()<UITextViewDelegate, UIWebViewDelegate, UIScrollViewDelegate, NJKWebViewProgressDelegate>

@property(nonatomic, assign) BOOL           pullRefresh;
@property(nonatomic, strong) NSString*      url;
@property(nonatomic, strong) UIWebView*     webview;
@property(nonatomic, strong) ATURLAction*   action;
@property(nonatomic, strong) ATWebRefreshView* refresh;
@property(nonatomic, strong) NSMutableDictionary* plugins;
@property(nonatomic, strong) NJKWebViewProgress     *progress;
@property(nonatomic, strong) NJKWebViewProgressView *progressView;

@end

@implementation ATWebViewController

- (void)dealloc {
    [self.webview stopLoading];
    [self.plugins enumerateKeysAndObjectsUsingBlock:^(NSString* key, ATWebPlugin* plugin, BOOL *stop) {
        [plugin onDestory];
    }];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

- (instancetype)initWithAction:(ATURLAction*)action {
    if ((self = [super init]) == nil) {
        return nil;
    }
    
    self.action      = action;
    self.plugins     = [NSMutableDictionary dictionaryWithCapacity:8];
    self.pullRefresh = YES; //[action.parameters[@"_pr"] boolValue];
    self.automaticallyAdjustsScrollViewInsets = NO;
    return self;
}

#pragma mark - UIViewController的生命周期
- (void)viewDidLoad {
    [super viewDidLoad];
    CGSize size = self.view.frame.size;
    self.view.backgroundColor = UIColor.whiteColor;
    if (self.action.parameters[@"_rbname"]) {
        [self setRightNaviBtnTitle:self.action.parameters[@"_rbname"] target:self action:@selector(onNext)];
    }
    else if (self.action.parameters[@"_rbicon"]) {
        [self setRightNaviBtnImage:self.action.parameters[@"_rbicon"] target:self action:@selector(onNext)];
    }
    
    //progress view
    self.progress = ({
        NJKWebViewProgress* progress = NJKWebViewProgress.new;
        progress.progressDelegate = self;
        progress.webViewProxyDelegate = self;
        progress;
    });
    
    self.progressView = ({
        [NJKWebViewProgressView.alloc initWithWidth:self.navigationController.navigationBar.width height:2];
    });
    
    [self.view addSubview:({
        UIWebView* webView = [[UIWebView alloc] initWithWidth:size.width height:size.height-64 backgroudColor:ClearColor];
        webView.opaque                           = NO;
        webView.delegate                         = self.progress;
        webView.scalesPageToFit                  = YES;
        webView.dataDetectorTypes                = UIDataDetectorTypeNone; // 禁止检测网页中所有的链接、电话号码等
        webView.scrollView.bounces               = YES;
        webView.scrollView.delegate              = self;
        webView.scrollView.decelerationRate      = UIScrollViewDecelerationRateNormal;
        webView.scrollView.keyboardDismissMode   = UIScrollViewKeyboardDismissModeOnDrag;
        webView.scrollView.showsVerticalScrollIndicator = YES;
        webView.scrollView.showsHorizontalScrollIndicator = NO;
        [webView.scrollView setInsetContent:UIEdgeInsetsZero scrollIndicator:UIEdgeInsetsZero];
        [webView loadRequest:[NSURLRequest requestWithURL:self.action.URL]];
        [webView.scrollView addSubview:({
            self.refresh = [ATWebRefreshView.alloc initWithWidth:size.width height:64 backgroudColor:ClearColor];
        }) layout:UILayoutOutsideTHC offset:CGSizeZero];
        [webView.scrollView.subviews enumerateObjectsUsingBlock:^(UIView* view, NSUInteger index, BOOL* stop) {
            view.hidden = [view isKindOfClass:UIImageView.class];
        }];
        self.webview = webView;
    }) layout:UILayoutBHC offset:CGSizeZero];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [NSNotificationCenter.defaultCenter addObserver:self selector:@selector(appResume:) name:UIApplicationDidBecomeActiveNotification object:nil];
    [NSNotificationCenter.defaultCenter addObserver:self selector:@selector(appPause:) name:UIApplicationWillResignActiveNotification object:nil];
    [NSNotificationCenter.defaultCenter addObserver:self selector:@selector(appDestory:) name:UIApplicationWillTerminateNotification object:nil];
    [NSNotificationCenter.defaultCenter addObserver:self selector:@selector(deviceOrientation:) name:UIDeviceOrientationDidChangeNotification object:nil];
    [self.navigationController.navigationBar addSubview:self.progressView layout:UILayoutBHC offset:CGSizeZero];
    [self.plugins enumerateKeysAndObjectsUsingBlock:^(id name, ATWebPlugin* plugin, BOOL *stop) {
        [plugin onResume];
    }];
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    [NSNotificationCenter.defaultCenter removeObserver:self];
    [self.progressView removeFromSuperview];
    [self.plugins enumerateKeysAndObjectsUsingBlock:^(id name, ATWebPlugin* plugin, BOOL *stop) {
        [plugin onPause];
    }];
}

- (void)loadURL:(NSString*)url {
    [self.webview loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:url]]];
}

- (void)dispatchEvent:(NSString*)event params:(NSString*)params {
    NSString* script = [NSString stringWithFormat:[ATConfig sharedInstance].scriptDispatch, event, params?:@"''"];
    [self.webview execute:script async:YES];
}

#pragma mark - NJKWebViewProgressDelegate
-(void)webViewProgress:(NJKWebViewProgress*)webViewProgress updateProgress:(float)progress {
    [self.progressView setProgress:progress animated:YES];
}

#pragma mark - UIScrollViewDelegate
- (void)scrollViewDidScroll:(UIScrollView*)scroll {
    [self.refresh setOffset:scroll.contentOffset.y];
}
- (void)scrollViewDidEndDragging:(UIScrollView*)scroll willDecelerate:(BOOL)decelerate {
    if (scroll.contentOffset.y <= -64) {
        if (self.pullRefresh) {
            if (self.webview.request.URL.absoluteString.length) {
                [self.webview reload];
            }
            else {
                [self.webview loadRequest:self.url.request];
            }
        }
        else {
            [self dispatchEvent:@"pullRefresh" params:nil];
        }
    }
}

#pragma mark - NotificationCenter在App的生命周期:resume/pause/destory/keyboard/device
- (void)appResume:(NSNotification*)notify {
    [self  dispatchEvent:@"app.resume" params:nil];
    [self.plugins enumerateKeysAndObjectsUsingBlock:^(id name, ATWebPlugin* plugin, BOOL *stop) {
        [plugin onResume];
    }];
}

- (void)appPause:(NSNotification*)notify {
    [self dispatchEvent:@"app.pause" params:nil];
    [self.plugins enumerateKeysAndObjectsUsingBlock:^(id name, ATWebPlugin* plugin, BOOL *stop) {
        [plugin onPause];
    }];
}

- (void)appDestory:(NSNotification*)notify {
    [self dispatchEvent:@"app.destory" params:nil];
    [self.plugins enumerateKeysAndObjectsUsingBlock:^(id name, ATWebPlugin* plugin, BOOL *stop) {
        [plugin onDestory];
    }];
}

- (void)deviceOrientation:(NSNotification*)notify {
    [self dispatchEvent:@"app.orientation" params:nil];
    [self.plugins enumerateKeysAndObjectsUsingBlock:^(id name, ATWebPlugin* plugin, BOOL *stop) {
        [plugin onDeviceOrientation];
    }];
}

- (void)onNext {
    [UINavigationController pushURL:self.action.parameters[@"_rburl"]];
}

- (void)onMore {
    [[UIActionSheet.alloc initWithTitle:nil cancelButtonItem:[RIButtonItem itemWithLabel:@"关闭" action:^{
    }] destructiveButtonItem:[RIButtonItem itemWithLabel:@"在Safari中打开" action:^{
        [UIApplication.sharedApplication openURL:self.webview.request.URL];
    }] otherButtonItems:[RIButtonItem itemWithLabel:@"刷新" action:^{
        [self.webview reload];
    }], [RIButtonItem itemWithLabel:@"显示或隐藏滚动条" action:^{
        UIScrollView* scroll = self.webview.scrollView;
        scroll.showsVerticalScrollIndicator = !scroll.showsVerticalScrollIndicator;
        scroll.showsHorizontalScrollIndicator = !scroll.showsHorizontalScrollIndicator;
    }], [RIButtonItem itemWithLabel:@"开始或关闭果冻效果" action:^{
        UIScrollView* scroll = self.webview.scrollView;
        scroll.bounces = !scroll.bounces;
    }], nil] showInView:self.view];
}


#pragma mark - UIWebViewDelegate用于拦截URL请求，AEBridge的scheme为：aebridge
- (void)webViewDidFinishLoad:(UIWebView*)webView {
    NSString* title = [webView stringByEvaluatingJavaScriptFromString:@"document.title"];
    if (title.length > 0) {
        self.title = title;
    }
    
    [webView stringByEvaluatingJavaScriptFromString:({
        NSString* pathfile = [[NSBundle mainBundle] pathForResource:@"aebridge.js" ofType:nil];
        [NSString stringWithContentsOfFile:pathfile encoding:NSUTF8StringEncoding error:nil];
    })];
}

- (void)webView:(UIWebView*)webView didFailLoadWithError:(NSError*)error {
    self.pullRefresh = YES;
}

- (BOOL)webView:(UIWebView*)webView shouldStartLoadWithRequest:(NSURLRequest*)request navigationType:(UIWebViewNavigationType)navigationType {
    if (navigationType == UIWebViewNavigationTypeReload || navigationType == UIWebViewNavigationTypeBackForward) {
        return YES;
    }
    NSURL* url = request.URL;
    if ([url.scheme isEqualToString:@"aebridge"]) {
        [self fetchAndExecuteCommands:webView];
        return NO;
    }
    if (navigationType == UIWebViewNavigationTypeOther || navigationType == UIWebViewNavigationTypeFormSubmitted) {
        return YES;
    }
    ATURLAction* action = [ATURLAction actionWithURLString:url.absoluteString];
    if (action.isInnerURL) {
        return YES;
    }
    else {
        [UINavigationController pushAction:action];
        return NO;
    }
//    BOOL start = NO;
//    if ([url isFileURL]) {
//        start = YES;
//    }
//    else if ([url.scheme isEqualToString:@"http"] || [url.scheme isEqualToString:@"https"]) {
//        start = YES;
//    }
//    else if ([url.scheme isEqualToString:@"tel"]) {
//        start = YES;
//    }
//    else if ([url.scheme isEqualToString:@"about"]) {
//        start = NO;
//    }
//    else if ([url.scheme isEqualToString:@"data"]) {
//        start = YES;
//    }
//    else if ([UIApplication.sharedApplication openURL:url]) {
//        start = NO;
//    }
//    else {
//        [NSNotificationCenter.defaultCenter postNotification:[NSNotification notificationWithName:ATWebViewControllerNotification object:url]];
//        start = YES;
//    }
//    self.url = [url absoluteString];
//    // self.pullRefresh = [url.query.dictionaryForURL[@"_pr"] boolValue];
//    return start;
}

- (void)fetchAndExecuteCommands:(UIWebView*)webView {
    NSString* jsonCommands = [webView execute:@"aebridge.nativeFetchJsonCommands();" async:NO];
    if (jsonCommands == nil || jsonCommands.length <= 0) {
        return;
    }
    NSArray* commands = [jsonCommands objectFromJSONString];
    for (NSArray* cmdInfo in commands) {
        @try {
            ATWebCmd* command = [ATWebCmd cmdWithInfo:cmdInfo];
            if (command == nil) {
                continue;
            }
            ATWebPlugin* plugin = self.plugins[command.clazz];
            if (plugin == nil) {
                Class clazz = NSClassFromString([NSString stringWithFormat:@"ATWebPlugin%@", command.clazz]);
                plugin = clazz == nil ? nil : [[clazz alloc] initWithWebview:self.webview];
                if (plugin != nil) {
                    self.plugins[command.clazz] = plugin;
                }
            }
            
            if (plugin == nil) {
                continue;
            }
            
            SEL selector = NSSelectorFromString(command.method);
            if (selector == nil) {
                continue;
            }
            
            if ([plugin respondsToSelector:selector]) {
                [plugin performSelector:selector withObject:command];
            }
        }
        @catch (NSException* e) {
            NSLog(@"AEViewController.executeCommands:%@", e);
        }
    }
    
    // 递归的获取下一次的请求命令
    [self fetchAndExecuteCommands:webView];
}

@end
