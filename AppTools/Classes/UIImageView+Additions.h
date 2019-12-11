//
//  UIView+Additions.h
//  TBBusiness
//
//  Created by 韩琼 on 14-5-11.
//  Copyright (c) 2014年 Taobao. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIImageView (Additions)

- (void)sd_setImageURL:(NSString*)imageURL;
- (void)sd_setImageURL:(NSString*)imageURL placeholderImage:(NSString*)image;

@end
