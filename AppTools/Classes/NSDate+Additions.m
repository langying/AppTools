//
//  NSDate+Formatter.m
//  TBImageCache
//
//  Created by 韩 琼 on 13-10-10.
//  Copyright (c) 2013年 taobao. All rights reserved.
//

#import "NSDate+Additions.h"

@implementation NSDate (Additions)

+(UInt64)currentTime {
    return [[NSDate date] timeIntervalSince1970] * 1000;
}

- (NSInteger)timeInterval {
    return [self timeIntervalSince1970];
}

-(NSString*)stringWithFormat:(NSString*)format {
    NSDateFormatter* dateFormatter = [[NSDateFormatter alloc] init];
    dateFormatter.dateFormat = format;
    return [dateFormatter stringFromDate:self];
}

@end
