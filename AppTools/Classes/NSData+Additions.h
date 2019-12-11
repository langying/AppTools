//
//  NSData+Cryptor.h
//  TBImageCache
//
//  Created by 韩 琼 on 13-10-11.
//  Copyright (c) 2013年 taobao. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface NSData (Additions)

- (NSString*)md5;

- (NSString*)hexString;

- (NSString*)stringWithEncoding:(NSStringEncoding)encoding;

- (NSData*)AES256Decrypt:(NSData*)key;

- (NSData*)AES256Encrypt:(NSData*)key;

- (id)objectFromJSONString;

@end
