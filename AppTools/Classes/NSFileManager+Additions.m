//
//  NSFileManager+Additions.m
//  TBBusiness
//
//  Created by 韩琼 on 14-4-16.
//  Copyright (c) 2014年 Taobao. All rights reserved.
//

#import "NSFileManager+Additions.h"

@implementation NSFileManager (Additions)

/** 取消文件夹icloud同步选项 */
- (BOOL)addSkipBackupAttributeForPath:(NSString*)path {
    [self createPathFile:path isDir:YES];
    NSURL* fileURL = [NSURL fileURLWithPath:path];
    BOOL success = [fileURL setResourceValue:@YES forKey:NSURLIsExcludedFromBackupKey error:nil];
    
    return success;
}

/** 针对提供的pathfile，检查并生成父文件夹 */
- (void)createPathFile:(NSString*)pathfile isDir:(BOOL)isDir {
    if (pathfile == nil) {
        return;
    }
    if (!isDir) {
        pathfile = [pathfile stringByDeletingLastPathComponent];
    }
    if (![NSFileManager.defaultManager fileExistsAtPath:pathfile]) {
        [NSFileManager.defaultManager createDirectoryAtPath:pathfile withIntermediateDirectories:YES attributes:nil error:NULL];
    }
}

/** 文件拷贝，自动创建文件路径 */
- (void)copyFile:(NSString*)srcFile to:(NSString*)destFile {
    if (srcFile == nil || destFile == nil || [srcFile isEqualToString:destFile]) {
        return;
    }
    if (![self fileExistsAtPath:srcFile]) {
        return ;
    }
    
    if ([self fileExistsAtPath:destFile]) {
        [self removeItemAtPath:destFile error:nil];
    }
    NSString* destFileDir = [destFile stringByDeletingLastPathComponent];
    if (![self fileExistsAtPath:destFileDir]) {
        [self createDirectoryAtPath:destFileDir withIntermediateDirectories:YES attributes:nil error:nil];
    }
    [self copyItemAtPath:srcFile toPath:destFile error:nil];
}

@end
