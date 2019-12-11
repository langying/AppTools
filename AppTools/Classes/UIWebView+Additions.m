//
//  UIWebView+Additions.m
//  TBBusiness
//
//  Created by 韩琼·朗英 on 14-8-4.
//  Copyright (c) 2014年 Taobao. All rights reserved.
//

#import "UIWebView+Additions.h"

@implementation UIWebView (Additions)

- (BOOL)isPageLoaded {
    NSString* readyState = [self stringByEvaluatingJavaScriptFromString:@"document.readyState"];
    return [readyState isEqualToString:@"loaded"] || [readyState isEqualToString:@"complete"];
}

- (NSString*)locationHref {
    return [self execute:@"location.href" async:NO];
}

- (NSString*)execute:(NSString*)script async:(BOOL)async {
    if (async) {
        script = [NSString stringWithFormat:@"window.setTimeout(function(){%@}, 0);", script];
    }
    return [self stringByEvaluatingJavaScriptFromString:script];
}

@end
