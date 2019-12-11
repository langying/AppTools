//
//  NSURL+Additions.h
//  TBBusiness
//
//  Created by 韩琼 on 14-5-21.
//  Copyright (c) 2014年 Taobao. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSURL (Additions)

- (BOOL)isWebURL;

- (NSString*)md5;
- (NSString*)MD5;

- (NSString*)mimeType;

- (NSString*)uniqueName;

- (NSString*)stringByRemoveHash;

- (NSString*)stringByReplaceHost:(NSString*)host;

@end
