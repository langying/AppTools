//
//  NSDate+Formatter.h
//  TBImageCache
//
//  Created by 韩 琼 on 13-10-10.
//  Copyright (c) 2013年 taobao. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSDate (Additions)

+ (UInt64)currentTime;
- (NSInteger)timeInterval;
- (NSString*)stringWithFormat:(NSString*)format;

@end
