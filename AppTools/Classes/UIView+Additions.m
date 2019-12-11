//
//  UIView+Additions.m
//  TBBusiness
//
//  Created by 韩琼 on 14-5-11.
//  Copyright (c) 2014年 Taobao. All rights reserved.
//

#import "UIView+Additions.h"
#import "UIColor+Additions.h"
#import "UIImageView+Additions.h"

@import ObjectiveC.runtime;
@implementation UIView (Additions)

#pragma mark - x
- (CGFloat)x {
    return self.frame.origin.x;
}
- (void)setX:(CGFloat)x {
    CGRect frame = self.frame;
    frame.origin.x = x;
    self.frame = frame;
}
#pragma mark - y
- (CGFloat)y {
    return self.frame.origin.y;
}
- (void)setY:(CGFloat)y {
    CGRect frame = self.frame;
    frame.origin.y = y;
    self.frame = frame;
}
#pragma mark - w
- (CGFloat)w {
    return self.width;
}
- (void)setW:(CGFloat)w {
    self.width = w;
}
#pragma mark - h
- (CGFloat)h {
    return self.height;
}
- (void)setH:(CGFloat)h {
    self.height = h;
}
#pragma mark - width
- (CGFloat)width {
    return self.frame.size.width;
}
- (void)setWidth:(CGFloat)width {
    CGRect frame = self.frame;
    frame.size.width = width;
    self.frame = frame;
}
#pragma mark - height
- (CGFloat)height {
    return self.frame.size.height;
}
- (void)setHeight:(CGFloat)height {
    CGRect frame = self.frame;
    frame.size.height = height;
    self.frame = frame;
}
#pragma mark - left
- (CGFloat)left {
    return self.frame.origin.x;
}
- (void)setLeft:(CGFloat)left {
    CGRect frame = self.frame;
    frame.origin.x = left;
    self.frame = frame;
}
#pragma mark - right
- (CGFloat)right {
    CGRect frame = self.frame;
    return frame.origin.x + frame.size.width;
}
- (void)setRight:(CGFloat)right {
    CGRect frame = self.frame;
    frame.origin.x = right - frame.size.width;
    self.frame = frame;
}
#pragma mark - top
- (CGFloat)top {
    return self.frame.origin.y;
}
- (void)setTop:(CGFloat)top {
    CGRect frame = self.frame;
    frame.origin.y = top;
    self.frame = frame;
}
#pragma mark - bottom
- (CGFloat)bottom {
    CGRect frame = self.frame;
    return frame.origin.y + frame.size.height;
}
- (void)setBottom:(CGFloat)bottom {
    CGRect frame = self.frame;
    frame.origin.y = bottom - frame.size.height;
    self.frame = frame;
}
#pragma mark - size
- (CGSize)size {
    return self.frame.size;
}
- (void)setSize:(CGSize)size {
    CGRect frame = self.frame;
    frame.size = size;
    self.frame = frame;
}
#pragma mark - midpoint
- (CGPoint)midpoint {
    CGSize size = self.frame.size;
    return CGPointMake(size.width / 2, size.height / 2);
}
- (void)setMidpoint:(CGPoint)midpoint {
    CGRect frame = self.frame;
    frame.size.width  = midpoint.x * 2;
    frame.size.height = midpoint.y * 2;
    self.frame = frame;
}
#pragma mark - position
- (CGPoint)position {
    return self.frame.origin;
}
- (void)setPosition:(CGPoint)position {
    CGRect frame = self.frame;
    frame.origin = position;
    self.frame = frame;
}
#pragma mark - frontier
- (CGPoint)frontier {
    CGRect frame = self.frame;
    return CGPointMake(frame.origin.x + frame.size.width, frame.origin.y + frame.size.height);
}
- (void)setFrontier:(CGPoint)frontier {
    CGRect frame = self.frame;
    frame.origin.x = frontier.x - frame.size.width;
    frame.origin.y = frontier.y - frame.size.height;
    self.frame = frame;
}
#pragma mark - text
- (NSString*)text {
    if ([self isKindOfClass:UILabel.class]) {
        return [(UILabel*)self text];
    }
    if ([self isKindOfClass:UITextField.class]) {
        return [(UITextField*)self text];
    }
    if ([self isKindOfClass:UITextView.class]) {
        return [(UITextView*)self text];
    }
    if ([self isKindOfClass:UIButton.class]) {
        UIButton* btn = (UIButton*)self;
        return [btn titleForState:btn.state];
    }
    return nil;
}
- (void)setText:(NSString*)text {
    if ([self isKindOfClass:UILabel.class]) {
        [(UILabel*)self setText:text];
    }
    if ([self isKindOfClass:UITextField.class]) {
        [(UITextField*)self setText:text];
    }
    if ([self isKindOfClass:UITextView.class]) {
        [(UITextView*)self setText:text];
    }
    if ([self isKindOfClass:UIButton.class]) {
        UIButton* btn = (UIButton*)self;
        [btn setTitle:text forState:btn.state];
    }
}
#pragma mark - minWidth
- (CGFloat)minSide {
    CGFloat w = self.width;
    CGFloat h = self.height;
    return w < h ? w : h;
}
#pragma mark - userInfo
static char pUserInfo;
- (id)userInfo {
    return objc_getAssociatedObject(self, &pUserInfo);
}
- (void)setUserInfo:(id)userInfo {
    objc_setAssociatedObject(self, &pUserInfo, userInfo, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

#pragma mark - init mehtods
- (instancetype)initWithWidth:(CGFloat)width height:(CGFloat)height {
    if ((self = [self initWithFrame:CGRectMake(0, 0, width, height)]) == nil) {
        return nil;
    }
    return self;
}
- (instancetype)initWithWidth:(CGFloat)width height:(CGFloat)height tag:(NSInteger)tag {
    if ((self = [self initWithFrame:CGRectMake(0, 0, width, height)]) == nil) {
        return nil;
    }
    self.tag = tag;
    return self;
}
- (instancetype)initWithWidth:(CGFloat)width height:(CGFloat)height backgroudColor:(NSUInteger)color {
    if ((self = [self initWithFrame:CGRectMake(0, 0, width, height)]) == nil) {
        return nil;
    }
    self.backgroundColor = [UIColor RGBAColor:color];
    return self;
}
- (instancetype)initWithWidth:(CGFloat)width height:(CGFloat)height backgroudColor:(NSUInteger)color tag:(NSInteger)tag {
    if ((self = [self initWithFrame:CGRectMake(0, 0, width, height)]) == nil) {
        return nil;
    }
    self.tag = tag;
    self.backgroundColor = [UIColor RGBAColor:color];
    return self;
}

#pragma mark -viewWithTag扩展
- (NSString*)textWithField:(NSInteger)tag {
    UITextField* field = (UITextField*)[self viewWithTag:tag];
    return field.text ?: @"";
}
- (CGFloat)valueWithSlider:(NSInteger)tag {
    UISlider* slider = (UISlider*)[self viewWithTag:tag];
    return slider.value;
}
- (BOOL)valueWithSwitch:(NSInteger)tag {
    UISwitch* swit = (UISwitch*)[self viewWithTag:tag];
    return swit.on;
}

- (UITextField*)tagField:(NSInteger)tag {
    return (UITextField*)[self viewWithTag:tag];
}

#pragma mark - 点击事件相关
- (instancetype)addTarget:(id)target onClick:(SEL)selector {
    self.userInteractionEnabled = YES;
    [self addGestureRecognizer:[UITapGestureRecognizer.alloc initWithTarget:target action:selector]];
    return self;
}
- (instancetype)addTarget:(id)target onPress:(SEL)selector {
    self.userInteractionEnabled = YES;
    [self addGestureRecognizer:[UILongPressGestureRecognizer.alloc initWithTarget:target action:selector]];
    return self;
}
- (instancetype)addTarget:(id)target onDoubleClick:(SEL)selector {
    self.userInteractionEnabled = YES;
    UITapGestureRecognizer* tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:selector];
    tap.numberOfTapsRequired = 2;
    [self addGestureRecognizer:tap];
    return self;
}

- (instancetype)setImage:(NSInteger)tag name:(NSString*)name {
    UIImageView* image = (UIImageView*)[self viewWithTag:tag];
    image.image = [UIImage imageNamed:name];
    return self;
}
- (instancetype)setImage:(NSInteger)tag pathfile:(NSString*)pathfile {
    UIImageView* image = (UIImageView*)[self viewWithTag:tag];
    image.image = [UIImage imageWithContentsOfFile:pathfile];
    return self;
}
- (instancetype)setImage:(NSInteger)tag sdImageURL:(NSString*)imageURL {
    UIImageView* image = (UIImageView*)[self viewWithTag:tag];
    [image sd_setImageURL:imageURL];
    return self;
}
- (instancetype)setField:(NSInteger)tag text:(NSString*)text {
    UITextField* field = (UITextField*)[self viewWithTag:tag];
    field.text = text;
    return self;
}
- (instancetype)setLabel:(NSInteger)tag text:(NSString*)text {
    UILabel* label = (UILabel*)[self viewWithTag:tag];
    label.text = text;
    return self;
}
- (instancetype)setButton:(NSInteger)tag title:(NSString*)title {
    UIButton* button = (UIButton*)[self viewWithTag:tag];
    [button setTitle:title forState:UIControlStateNormal];
    return self;
}
- (instancetype)setSlider:(NSInteger)tag value:(CGFloat)value {
    UISlider* slider = (UISlider*)[self viewWithTag:tag];
    slider.value = value;
    return self;
}
- (instancetype)setSwitch:(NSInteger)tag value:(BOOL)on {
    UISwitch* swit = (UISwitch*)[self viewWithTag:tag];
    [swit setOn:on animated:YES];
    return self;
}
- (instancetype)setControl:(NSInteger)tag enable:(BOOL)enable {
    UIControl* control = (UIControl*)[self viewWithTag:tag];
    [control setEnabled:enable];
    return self;
}
- (instancetype)setBorder:(CGFloat)border color:(NSUInteger)color corner:(CGFloat)corner {
    self.clipsToBounds = YES;
    self.layer.borderWidth  = border;
    self.layer.borderColor  = [UIColor RGBAColor:color].CGColor;
    self.layer.cornerRadius = corner;
    return self;
}
- (instancetype)setShadowRadius:(CGFloat)radius color:(NSUInteger)color offset:(CGSize)offset {
    self.layer.shadowRadius = radius;
    self.layer.shadowColor  = [UIColor RGBAColor:color].CGColor;
    self.layer.shadowOffset = offset;
    return self;
}

#pragma mark - screenFrame
- (CGRect)screenFrame {
    CGRect frame = self.frame;
    for (UIView* view = self.superview; view != nil; view = view.superview) {
        frame.origin.x += view.left;
        frame.origin.y += view.top;
        if ([view isKindOfClass:[UIScrollView class]]) {
            UIScrollView* scrollView = (UIScrollView*)view;
            frame.origin.x -= scrollView.contentOffset.x;
            frame.origin.y -= scrollView.contentOffset.y;
        }
    }
    return frame;
}

- (UIView*)firstResponder {
    if ([self isFirstResponder]) {
        return self;
    }
    for (UIView* child in self.subviews) {
        UIView* view = [child firstResponder];
        if (view != nil) {
            return view;
        }
    }
    return nil;
}

#pragma mark - 根据UIView的superview查找UIViewController
- (UIViewController*)viewController {
    for (UIResponder* responder = [self nextResponder]; responder != nil; responder = [responder nextResponder]) {
        if ([responder isKindOfClass:UIViewController.class]) {
            return (UIViewController*)responder;
        }
    }
    return nil;
}

#pragma mark - 一键删除所有子视图
- (void)removeAllSubviews {
    [self.subviews makeObjectsPerformSelector:@selector(removeFromSuperview)];
}

#pragma mark - 页面布局
- (void)addSubview:(UIView*)view offset:(CGSize)size {
    UIView* last = [self.subviews lastObject];
    if (last == nil) {
        view.x = size.width;
        view.y = size.height;
    }
    else {
        view.x = last.left + size.width;
        view.y = last.bottom + size.height;
    }
    [self addSubview:view];
}
- (void)addSubview:(UIView*)view layout:(UILayout)layout offset:(CGSize)size {
    [view layout:layout offset:size inView:self];
    [self addSubview:view];
}

- (void)layout:(UILayout)layout offset:(CGSize)size {
    [self layout:layout offset:size inView:self.superview];
}

- (void)layout:(UILayout)layout offset:(CGSize)size inView:(UIView*)parent {
    CGRect frame = parent.frame;
    switch (layout) {
        case UILayoutLT:{
            self.position = CGPointMake(size.width, size.height);
            break;
        }
        case UILayoutLB:{
            self.position = CGPointMake(size.width, frame.size.height - self.height - size.height);
            break;
        }
        case UILayoutRT:{
            self.position = CGPointMake(frame.size.width - self.width - size.width, size.height);
            break;
        }
        case UILayoutRB:{
            CGFloat x = frame.size.width - self.bounds.size.width - size.width;
            CGFloat y = frame.size.height - self.bounds.size.height - size.height;
            self.position = CGPointMake(x, y);
            break;
        }
        case UILayoutTHC:{
            self.position = CGPointMake((frame.size.width - self.bounds.size.width) / 2 + size.width, size.height);
            break;
        }
        case UILayoutBHC:{
            CGFloat x = (frame.size.width - self.bounds.size.width) / 2 + size.width;
            CGFloat y = frame.size.height - self.bounds.size.height - size.height;
            self.position = CGPointMake(x, y);
            break;
        }
        case UILayoutLVC:{
            self.position = CGPointMake(size.width, (frame.size.height - self.bounds.size.height) / 2 + size.height);
            break;
        }
        case UILayoutRVC:{
            CGFloat x = frame.size.width - self.bounds.size.width - size.width;
            CGFloat y = (frame.size.height - self.bounds.size.height) / 2 + size.height;
            self.position = CGPointMake(x, y);
            break;
        }
        case UILayoutCenter:{
            CGFloat x = (frame.size.width - self.bounds.size.width) / 2 + size.width;
            CGFloat y = (frame.size.height - self.bounds.size.height) / 2 + size.height;
            self.position = CGPointMake(x, y);
            break;
        }
        case UILayoutOutsideBHC:{
            CGFloat x = (frame.size.width - self.bounds.size.width) / 2 + size.width;
            CGFloat y = frame.size.height + size.height;
            self.position = CGPointMake(x, y);
            break;
        }
        case UILayoutOutsideTHC:{
            CGFloat x = (frame.size.width - self.bounds.size.width) / 2 + size.width;
            CGFloat y = 0 - self.bounds.size.height - size.height;
            self.position = CGPointMake(x, y);
            break;
        }
        case UILayoutOutsideLVC:{
            CGFloat x = 0 - self.bounds.size.width - size.width;
            CGFloat y = (frame.size.height - self.bounds.size.height) / 2 + size.height;
            self.position = CGPointMake(x, y);
            break;
        }
        case UILayoutOutsideRVC:{
            CGFloat x = frame.size.width + size.width;
            CGFloat y = (frame.size.height - self.bounds.size.height) / 2 + size.height;
            self.position = CGPointMake(x, y);
            break;
        }
    }
}

@end
