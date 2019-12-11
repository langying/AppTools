//
//  UIView+Additions.h
//  TBBusiness
//
//  Created by 韩琼 on 14-5-11.
//  Copyright (c) 2014年 Taobao. All rights reserved.
//

#import <UIKit/UIKit.h>

#define RedColor         0xFF0000FF
#define BlueColor        0x0000FFFF
#define GrayColor        0x808080FF
#define BlackColor       0x000000FF
#define ClearColor       0x00000000
#define GreenColor       0x00FF00FF
#define WhiteColor       0xFFFFFFFF
#define LightBlueColor   0x2A75E6FF
#define LightGrayColor   0xAAAAAAFF
#define LightGreenColor  0x1AC382FF
#define LightWhiteColor  0xFBFBFBFF
#define SilverWhiteColor 0xECEBF3FF

typedef NS_ENUM(NSInteger, UILayout) {
    UILayoutLT, // 左上角
    UILayoutLB, // 左下角
    UILayoutRT, // 右上角
    UILayoutRB, // 右下角
    UILayoutTHC,    // 向上水平居中
    UILayoutBHC,    // 向下水平居中
    UILayoutLVC,    // 向左垂直居中
    UILayoutRVC,    // 向右垂直居中
    UILayoutCenter, // 居中对齐
    UILayoutOutsideBHC, // 外部向下水平居中
    UILayoutOutsideTHC, // 外部向上水平居中
    UILayoutOutsideLVC, // 外部向左垂直居中
    UILayoutOutsideRVC, // 外部向右垂直居中
};

@interface UIView (Additions)

@property(nonatomic, assign) CGFloat x;
@property(nonatomic, assign) CGFloat y;
@property(nonatomic, assign) CGFloat w;
@property(nonatomic, assign) CGFloat h;
@property(nonatomic, assign) CGFloat width;
@property(nonatomic, assign) CGFloat height;

@property(nonatomic, assign) CGFloat left;
@property(nonatomic, assign) CGFloat right;
@property(nonatomic, assign) CGFloat top;
@property(nonatomic, assign) CGFloat bottom;

@property(nonatomic, assign) CGSize size;
@property(nonatomic, assign) CGPoint midpoint;
@property(nonatomic, assign) CGPoint position;
@property(nonatomic, assign) CGPoint frontier;

@property(nonatomic, strong) NSString* text;

@property(nonatomic, readonly) CGFloat minSide;

@property(nonatomic, strong) id userInfo;

- (instancetype)initWithWidth:(CGFloat)width height:(CGFloat)height;
- (instancetype)initWithWidth:(CGFloat)width height:(CGFloat)height tag:(NSInteger)tag;
- (instancetype)initWithWidth:(CGFloat)width height:(CGFloat)height backgroudColor:(NSUInteger)color;
- (instancetype)initWithWidth:(CGFloat)width height:(CGFloat)height backgroudColor:(NSUInteger)color tag:(NSInteger)tag;

- (NSString*)textWithField:(NSInteger)tag;
- (CGFloat)valueWithSlider:(NSInteger)tag;
- (BOOL)valueWithSwitch:(NSInteger)tag;

- (UITextField*)tagField:(NSInteger)tag;

- (instancetype)addTarget:(id)target onClick:(SEL)selector;
- (instancetype)addTarget:(id)target onPress:(SEL)selector;
- (instancetype)addTarget:(id)target onDoubleClick:(SEL)selector;

- (instancetype)setImage:(NSInteger)tag name:(NSString*)name;
- (instancetype)setImage:(NSInteger)tag pathfile:(NSString*)pathfile;
- (instancetype)setImage:(NSInteger)tag sdImageURL:(NSString*)imageURL;
- (instancetype)setField:(NSInteger)tag text:(NSString*)text;
- (instancetype)setLabel:(NSInteger)tag text:(NSString*)text;
- (instancetype)setButton:(NSInteger)tag title:(NSString*)title;
- (instancetype)setSlider:(NSInteger)tag value:(CGFloat)value;
- (instancetype)setSwitch:(NSInteger)tag value:(BOOL)on;
- (instancetype)setControl:(NSInteger)tag enable:(BOOL)enable;
- (instancetype)setBorder:(CGFloat)border color:(NSUInteger)color corner:(CGFloat)corner;
- (instancetype)setShadowRadius:(CGFloat)radius color:(NSUInteger)color offset:(CGSize)offset;

- (CGRect)screenFrame;

- (UIView*)firstResponder;

- (UIViewController*)viewController;

- (void)removeAllSubviews;

// UILabel:preferredMaxLayoutWidth，约束最大宽度
// UIView: systemLayoutSizeFittingSize(UILayoutFittingCompressedSize)，强制布局
- (void)addSubview:(UIView*)view offset:(CGSize)size;
- (void)addSubview:(UIView*)view layout:(UILayout)layout offset:(CGSize)size;
- (void)layout:(UILayout)layout offset:(CGSize)size;
- (void)layout:(UILayout)layout offset:(CGSize)size inView:(UIView*)parent;

@end

