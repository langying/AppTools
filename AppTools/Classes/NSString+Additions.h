//
//  NSString+Additions.h
//  TBBusiness
//
//  Created by 韩琼 on 14-5-7.
//  Copyright (c) 2014年 Taobao. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Foundation/Foundation.h>
#import <CoreGraphics/CoreGraphics.h>

@interface NSArray (Additions)
- (NSString*)JSONString;
@end
@interface NSMutableArray(Additions)
- (id)deleteAtIndex:(NSInteger)index;
@end

@interface NSDictionary (Additions)
- (NSString*)JSONString;
- (NSString*)stringForKey:(NSString*)key placeholder:(NSString*)placeholder;
@end

@interface NSString (Additions)

- (BOOL)isEmail;
- (BOOL)isAppURL;
- (BOOL)isBusLine;
- (BOOL)isWebURL;
- (BOOL)isFileExist;
- (BOOL)isFileNotExist;

- (void)mkdir;
- (void)removePathfile;
- (void)renameFile:(NSString*)name;
- (void)renamePathfile:(NSString*)pathfile;

- (NSURL*)URL;
- (NSURLRequest*)request;

- (UInt64)timeWithFormat:(NSString*)format;
- (NSDate*)dateWithFormat:(NSString*)format;

- (NSString*)md5;
- (NSString*)MD5;

- (NSString*)sha1;
- (NSString*)SHA1;

- (NSString*)hmacsha1:(NSString*)key;
- (NSString*)HMACSHA1:(NSString*)key;

- (NSString*)trim;

- (NSString*)fileMD5;

- (NSString*)encodeURL;
- (NSString*)decodeURL;
- (NSString*)imageURLWithExt:(CGFloat)size;

- (NSString*)bundlePath;

- (NSString*)uniqueName;

- (NSString*)httpResponse;

- (NSString*)firstUppercase;
- (NSString*)firstPinyinLetter;

- (NSString*)stringByRemoveHash;
- (NSString*)stringByRomoveQuery;
- (NSString*)stringByAppendParameter:(NSString*)parameter;
+ (NSString*)stringWithTime:(NSUInteger)time format:(NSString*)format;

- (const char*)GBKString;

- (NSMutableDictionary*)dictionaryForURL;

- (id)objectFromJSONString;

- (NSTextContainer*)containerWithFont:(UIFont*)font size:(CGSize)size color:(NSInteger)color line:(CGFloat)line paragraph:(CGFloat)paragraph indent:(CGFloat)indent;

- (CGSize)textSizeWithFont:(UIFont *)font constrainedToSize:(CGSize)size;

@end
