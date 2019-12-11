//
//  UIView+Additions.m
//  TBBusiness
//
//  Created by 韩琼 on 14-5-11.
//  Copyright (c) 2014年 Taobao. All rights reserved.
//

#import "UIView+Additions.h"
#import "NSString+Additions.h"
#import "UIImageView+WebCache.h"
#import "UIImageView+Additions.h"

@implementation UIImageView (Additions)

- (void)sd_setImageURL:(NSString*)imageURL {
    NSString* url = [imageURL imageURLWithExt:self.width];
    [self sd_setImageWithURL:url.URL];
}
- (void)sd_setImageURL:(NSString*)imageURL placeholderImage:(NSString*)imageName {
    NSString* url = [imageURL imageURLWithExt:self.width];
    [self sd_setImageWithURL:url.URL placeholderImage:[UIImage imageNamed:imageName]];
}

@end
