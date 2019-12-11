//
//  UIView+Additions.m
//  TBBusiness
//
//  Created by 韩琼 on 14-5-11.
//  Copyright (c) 2014年 Taobao. All rights reserved.
//

#import "UIView+Additions.h"
#import "UIColor+Additions.h"

@implementation UILabel(Additions)

- (void)setFont:(NSInteger)font color:(NSUInteger)color text:(NSString*)text {
    self.text      = text;
    self.font      = [UIFont systemFontOfSize:font];
    self.textColor = [UIColor RGBAColor:color];
}
- (void)setFont:(NSInteger)font color:(NSUInteger)color text:(NSString*)text alignment:(NSTextAlignment)alignment {
    self.text      = text;
    self.font      = [UIFont systemFontOfSize:font];
    self.textColor = [UIColor RGBAColor:color];
    self.textAlignment = alignment;
}
- (void)setFont:(NSString*)font size:(NSInteger)size color:(NSUInteger)color text:(NSString*)text alignment:(NSTextAlignment)alignment {
    self.text      = text;
    self.font      = [UIFont fontWithName:font size:size];
    self.textColor = [UIColor RGBAColor:color];
    self.textAlignment = alignment;
}
- (void)setShadowColor:(NSUInteger)color offset:(CGSize)offset {
    self.shadowColor  = [UIColor RGBAColor:color];
    self.shadowOffset = offset;
}
- (void)setLineNumber:(NSUInteger)number alignment:(NSTextAlignment)alignment lineBreak:(NSLineBreakMode)lineBreak {
    self.numberOfLines = number;
    self.lineBreakMode = lineBreak;
    self.textAlignment = alignment;
}

@end
