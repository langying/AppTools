//
//  NSFileManager+Additions.h
//  TBBusiness
//
//  Created by 韩琼 on 14-4-16.
//  Copyright (c) 2014年 Taobao. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSFileManager (Additions)

/** 取消文件夹icloud同步选项 */
- (BOOL)addSkipBackupAttributeForPath:(NSString*)path;

/** 针对提供的pathfile，检查并生成父文件夹 */
- (void)createPathFile:(NSString*)pathfile isDir:(BOOL)isDir;

/** 文件拷贝，自动创建文件路径 */
- (void)copyFile:(NSString*)srcFile to:(NSString*)destFile;

@end
