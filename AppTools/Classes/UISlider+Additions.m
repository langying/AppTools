//
//  UIView+Additions.m
//  TBBusiness
//
//  Created by 韩琼 on 14-5-11.
//  Copyright (c) 2014年 Taobao. All rights reserved.
//

#import "UISlider+Additions.h"

@implementation UISlider(Additions)

- (void)setMin:(CGFloat)min max:(CGFloat)max value:(CGFloat)value {
    self.minimumValue = min;
    self.maximumValue = max;
    self.value = value;
}

@end
