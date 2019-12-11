//
//  UIViewController+Additions.m
//  TBBusiness
//
//  Created by 韩琼 on 14-5-9.
//  Copyright (c) 2014年 Taobao. All rights reserved.
//

#import "UIColor+Additions.h"
#import "UIViewController+Additions.h"

@import ObjectiveC.runtime;

static char pAction;

@implementation UIViewController (Additions)

- (ATURLAction*)action {
    return objc_getAssociatedObject(self, &pAction);
}
- (void)setAction:(ATURLAction*)action {
    objc_setAssociatedObject(self, &pAction, action, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (ATConfig*)config {
    return [ATConfig sharedInstance];
}
- (BOOL)isPresented {
    return self.presentingViewController != nil;
}

- (void)setLeftNaviBtnImage:(NSString*)name target:(id)target action:(SEL)action {
    UIImage* image = [UIImage imageNamed:name];
    self.navigationItem.leftBarButtonItem = [UIBarButtonItem.alloc initWithImage:image style:UIBarButtonItemStylePlain target:target action:action];
//    self.navigationController.interactivePopGestureRecognizer.delegate = (id)self;
}
- (void)setRightNaviBtnImage:(NSString*)name target:(id)target action:(SEL)action {
    UIImage* image = [UIImage imageNamed:name];
    image = [image imageWithAlignmentRectInsets:UIEdgeInsetsMake(0, -10, 0, 10)];
    self.navigationItem.rightBarButtonItem = [UIBarButtonItem.alloc initWithImage:image style:UIBarButtonItemStylePlain target:target action:action];
}

- (void)setLeftNaviBtnTitle:(NSString*)title target:(id)target action:(SEL)action {
    self.navigationItem.leftBarButtonItem = [UIBarButtonItem.alloc initWithTitle:title style:UIBarButtonItemStylePlain target:target action:action];
//    self.navigationController.interactivePopGestureRecognizer.delegate = (id)self;
}
- (void)setRightNaviBtnTitle:(NSString*)title target:(id)target action:(SEL)action {
    self.navigationItem.rightBarButtonItem = [UIBarButtonItem.alloc initWithTitle:title style:UIBarButtonItemStylePlain target:target action:action];
}

- (void)setNavigationBarTitle:(NSString*)title {
    if ([self.navigationItem.titleView isKindOfClass:UILabel.class]) {
        [self.navigationItem.titleView performSelector:@selector(setText:) withObject:title];
        [self.navigationItem.titleView sizeToFit];
        return;
    }
    [self setNavigationBarTitle:title fontSize:21 color:0x000000FF];
}
- (void)setNavigationBarTitle:(NSString*)title fontSize:(CGFloat)size color:(NSUInteger)color {
    UILabel* label = (UILabel*)self.navigationItem.titleView;
    if (label == nil) {
        label = [[UILabel alloc] init];
        label.font = [UIFont boldSystemFontOfSize:size];
        label.textColor = [UIColor RGBAColor:color];
        label.backgroundColor = [UIColor redColor];
        label.userInteractionEnabled = YES;
        self.navigationItem.titleView = label;
    }
    if ([label respondsToSelector:@selector(setText:)]) {
        label.text = title;
    }
    [label sizeToFit];
}

@end
