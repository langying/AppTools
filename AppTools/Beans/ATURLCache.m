//
//  AEURLCache.m
//  TBBusiness
//
//  Created by 韩琼 on 14-5-21.
//  Copyright (c) 2014年 Taobao. All rights reserved.
//

#import "ATConfig.h"
#import "ATURLCache.h"
#import "NSURL+Additions.h"

@interface ATURLCache()

@property(nonatomic, strong) NSString* cachePath;
@property(nonatomic, strong) NSString* cacheExtensions;

@end

@implementation ATURLCache

- (id)initWithMemoryCapacity:(NSUInteger)memoryCapacity diskCapacity:(NSUInteger)diskCapacity diskPath:(NSString*)path {
    if ((self = [super initWithMemoryCapacity:memoryCapacity diskCapacity:diskCapacity diskPath:path]) == nil) {
        return nil;
    }
    self.cachePath = [ATConfig sharedInstance].pathWebCache;
    self.cacheExtensions = @"jpe,jpg,jpeg,png,webp";
    return self;
}

#pragma mark - NSURLCache
- (NSCachedURLResponse*)cachedResponseForRequest:(NSURLRequest*)req {
    NSCachedURLResponse* cachedResponse = [super cachedResponseForRequest:req];
    if (cachedResponse != nil || [self isNotSupport:req]) {
        return cachedResponse;
    }
    NSData* data = [NSData dataWithContentsOfFile:[self pathfile:req]];
    if (data == nil || data.length <= 0) {
        return cachedResponse;
    }
    
    NSURLResponse* res = [NSURLResponse.alloc initWithURL:req.URL MIMEType:req.URL.mimeType expectedContentLength:data.length textEncodingName:nil];
    cachedResponse = [NSCachedURLResponse.alloc initWithResponse:res data:data];
    [self storeCachedResponse:cachedResponse forRequest:req];
    return cachedResponse;
}

- (void)storeCachedResponse:(NSCachedURLResponse*)response forRequest:(NSURLRequest*)request {
    [super storeCachedResponse:response forRequest:request];
    if ([self isNotSupport:request]) {
        return;
    }
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        [NSFileManager.new createFileAtPath:[self pathfile:request] contents:response.data attributes:nil];
    });
}

- (void)removeCachedResponseForRequest:(NSURLRequest*)request {
    [super removeCachedResponseForRequest:request];
}

- (void)removeAllCachedResponses {
    [super removeAllCachedResponses];
}

#pragma mark - private_methods
- (BOOL)isNotSupport:(NSURLRequest*)request {
    NSString* ext = [[request.URL pathExtension] lowercaseString];
    return ext.length <= 0 || [self.cacheExtensions rangeOfString:ext].location == NSNotFound;
}

- (NSString*)pathfile:(NSURLRequest*)request {
    return [self.cachePath stringByAppendingPathComponent:request.URL.md5];
}

@end
