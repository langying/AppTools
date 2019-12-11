//
//  NSURL+Additions.m
//  TBBusiness
//
//  Created by 韩琼 on 14-5-21.
//  Copyright (c) 2014年 Taobao. All rights reserved.
//

#import "NSURL+Additions.h"
#import "NSString+Additions.h"

@implementation NSURL (Additions)

- (BOOL)isWebURL {
    return [self.scheme hasPrefix:@"http"];
}

- (NSString*)md5 {
    return self.absoluteString.md5;
}

- (NSString*)MD5 {
    return self.absoluteString.MD5;
}

- (NSString*)mimeType {
    NSString* extension = self.pathExtension.lowercaseString;
    if ([@"jpe" isEqualToString:extension] || [@"jpg" isEqualToString:extension] || [@"jpeg" isEqualToString:extension]) {
        return @"image/jpeg";
    }
    else if ([@"png" isEqualToString:extension]) {
        return @"image/png";
    }
    else if ([@"gif" isEqualToString:extension]) {
        return @"image/gif";
    }
    else if ([@"webp" isEqualToString:extension]) {
        return @"image/webp";
    }
    else if ([@"htm" isEqualToString:extension] || [@"html" isEqualToString:extension]) {
        return @"text/html";
    }
    else if ([@"zip" isEqualToString:extension]) {
        return @"application/zip";
    }
    else if ([@"css" isEqualToString:extension]) {
        return @"text/css";
    }
    else if ([@"js" isEqualToString:extension]) {
        return @"application/javascript";
    }
    return @"text/html";
}

- (NSString*)uniqueName {
    NSString* ext = self.pathExtension.lowercaseString;
    if (ext.length <= 0) {
        return [NSString stringWithFormat:@"%lx", self.absoluteString.hash];
    } else {
        return [NSString stringWithFormat:@"%lx.%@", self.absoluteString.hash, self.pathExtension];
    }
}

- (NSString*)stringByRemoveHash {
    NSString* URLString = [self absoluteString];
    NSRange hash = [URLString rangeOfString:@"#"];
    return hash.location == NSNotFound ? URLString : [URLString substringToIndex:hash.location];
}

- (NSString*)stringByReplaceHost:(NSString*)host {
    NSString* URLString = [self absoluteString];
    return [URLString stringByReplacingOccurrencesOfString:self.host withString:host];
}

@end
