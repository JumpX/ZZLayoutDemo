//
//  ZZArtboardButton.h
//  ZZArtboardButton
//
//  Created by Jungle on 2019/3/25.
//  Copyright (c) 2019. All rights reserved.
//
//  加强版
//  定制全局按钮：带有圆角、背景图渐变色（或许有1px的框）

/**
 
 Sample Code:
 
 ************************** 类型一（蓝条）**************************
 @code
 ZZArtboardButton *button = [ZZArtboardButton buttonWithType:UIButtonTypeCustom];
 button.frame = CGRectMake(0, 0, 100.0, 44.0);
 [button setType:ZZArtboardTypeUp textColor:[UIColor whiteColor] font:[UIFont systemFontOfSize:16.0 weight:UIFontWeightMedium] text:@"开始派单"];
 [self addSubview:button];
 @endcode
 
 ************************** 类型二（白条）**************************
 @code
 ZZArtboardButton *button = [ZZArtboardButton buttonWithType:UIButtonTypeCustom];
 button.frame = CGRectMake(0, 0, 100.0, 44.0);
 [button setType:ZZArtboardTypeDown textColor:[UIColor colorWithHexString:@"#1D9AFF"] font:[UIFont systemFontOfSize:16.0 weight:UIFontWeightMedium] text:@"关闭"];
 [self addSubview:button];
 @endcode
 
 ***************************** 自定义 *****************************
 @code
 ZZArtboardButton *button = [ZZArtboardButton buttonWithType:UIButtonTypeCustom];
 button.frame = CGRectMake(0, 0, 100.0, 44.0);
 [button setType:ZZArtboardTypeCustom textColor:[UIColor whiteColor] font:[UIFont systemFontOfSize:16.0 weight:UIFontWeightMedium] text:@"自定义一"];
 [button setBackgroundImageWithColors:@[[UIColor blackColor], [UIColor redColor], [UIColor greenColor]] forState:UIControlStateNormal directionType:ZZArtboardDirectionTypeLeftTopToRightBottom];
 [self setTitle:@"自定义一 正常状态" forState:UIControlStateNormal];
 [self setTitle:@"自定义一 高亮状态" forState:UIControlStateHighlighted];
 [self setTitle:@"自定义一 高亮状态" forState:UIControlStateHighlighted | UIControlStateSelected];
 [self setTitle:@"自定义一 无效状态" forState:UIControlStateDisabled];
 [self addSubview:button];
 @endcode
 
 @code
 ZZArtboardButton *button = [ZZArtboardButton buttonWithType:UIButtonTypeCustom];
 [button setType:ZZArtboardTypeCustom textColor:[UIColor whiteColor] font:[UIFont systemFontOfSize:16.0 weight:UIFontWeightMedium] text:@"自定义二"];
 button.bxAdjustsWhenHighlighted = NO;
 button.layoutCustomBackgroundImageBlock = ^{
 [button setUpNormalStyleWithNormalState];
 [button setBackgroundImageWithColors:@[[UIColor blackColor], [UIColor redColor], [UIColor greenColor]] borderColor:[UIColor blueColor] forState:UIControlStateSelected directionType:ZZArtboardDirectionTypeLeftTopToRightBottom];
 };
 [self setTitle:@"自定义二 正常状态" forState:UIControlStateNormal];
 [self setTitle:@"自定义二 选中状态" forState:UIControlStateSelected];
 [self addSubview:button];
 [button mas_makeConstraints:^(MASConstraintMaker *make) {
 make.left.equalTo(self).offset(20.0f);
 make.centerY.equalTo(self);
 make.width.mas_equalTo(100.0f);
 make.height.mas_equalTo(44.f);
 }];
 @endcode
 
 */

#import <UIKit/UIKit.h>
#import "UIColor+ZZAdd.h"

// 字体（类型一）
#define kArtboardUpFont [UIFont systemFontOfSize:16.0f weight:UIFontWeightMedium]
// 字体（类型二）
#define kArtboardDownFont [UIFont systemFontOfSize:16.0f]
// 高度（类型一、二）
FOUNDATION_EXPORT CGFloat const kArtboardUpDownHeight;

NS_ASSUME_NONNULL_BEGIN

// 按钮类型
typedef NS_ENUM(NSInteger, ZZArtboardType) {
    ZZArtboardTypeCustom,           // 自定义（普通的UIButton，不带任何效果）
    ZZArtboardTypeUp,               // 类型一（蓝条：背景渐变色）
    ZZArtboardTypeDown              // 类型二（白条：不渐变）
};

// 渐变方向
typedef NS_ENUM(NSInteger, ZZArtboardDirectionType) {
    ZZArtboardDirectionTypeDefault,                 // 左下 -> 右上（默认）
    ZZArtboardDirectionTypeTopToBottom,             // 上 -> 下
    ZZArtboardDirectionTypeLeftToRight,             // 左 -> 右
    ZZArtboardDirectionTypeLeftTopToRightBottom     // 左上 -> 右下
};

@interface ZZArtboardButton : UIButton

/* 主要方法 */
- (void)setType:(ZZArtboardType)type textColor:(UIColor *)textColor font:(UIFont *)font text:(NSString *)text;/* textColor只在自定义类型起作用 */

/* test */
- (void)setCustomTitles;
- (void)setUpTitles;
- (void)setDownTitles;


/************************** 以下为可选方法 **************************/
/*********** 建议只在 type = ZZArtboardTypeCustom 时使用 ************/

/* 系统高亮，默认YES */
@property (nonatomic, assign) BOOL bxAdjustsWhenHighlighted;/* 比adjustsImageWhenHighlighted准确 */

/* 自定义类型 背景图适配frame */
@property (nonatomic, copy) void(^layoutCustomBackgroundImageBlock)(void);/*  渐变或带框的背景图需在此设置，背景图才会适配frame；否则背景图可能会变形 */

/* 自定义类型 使用蓝条 */
- (void)setUpNormalStyleWithNormalState;
- (void)setUpHighlightedStyleWithHighlightedState;
- (void)setUpDisabledStyleWithDisabledState;
- (void)setUpNormalStyleWithState:(UIControlState)state;
- (void)setUpHighlightedStyleWithState:(UIControlState)state;
- (void)setUpDisabledStyleWithState:(UIControlState)state;
/* 自定义类型 使用白条 */
- (void)setDownNormalStyleWithNormalState;
- (void)setDownHighlightedStyleWithHighlightedState;
- (void)setDownDisabledStyleWithDisabledState;
- (void)setDownNormalStyleWithState:(UIControlState)state;
- (void)setDownHighlightedStyleWithState:(UIControlState)state;
- (void)setDownDisabledStyleWithState:(UIControlState)state;

/* 清除所有状态下背景图 */
- (void)clearAllBackgroundImages;

#pragma mark - 设置背景图

/**
 设置背景图（纯色）
 
 @param backgroundColor     背景色
 @param state               UIControlState
 */
- (void)setBackgroundImageWithColor:(UIColor *)backgroundColor
                           forState:(UIControlState)state;
/**
 设置背景图（纯色、带1px的框）
 
 @param backgroundColor     背景色
 @param boderColor          框颜色
 @param state               UIControlState
 */
- (void)setBackgroundImageWithColor:(UIColor *)backgroundColor
                         boderColor:(UIColor *)boderColor
                           forState:(UIControlState)state;
/**
 设置背景图（渐变色）
 
 @param backgroundColors    背景色数组
 @param state               UIControlState
 */
- (void)setBackgroundImageWithColors:(NSArray <UIColor *>*)backgroundColors
                            forState:(UIControlState)state;
/**
 设置背景图（渐变色、带1px的框）
 
 @param backgroundColors    背景色数组
 @param boderColor          框颜色
 @param state               UIControlState
 */
- (void)setBackgroundImageWithColors:(NSArray <UIColor *>*)backgroundColors
                          boderColor:(UIColor *)boderColor
                            forState:(UIControlState)state;
/**
 设置背景图（多个渐变色）
 
 @param backgroundColors    背景色数组
 @param state               UIControlState
 @param directionType       ZZArtboardDirectionType（默认左下->右上）
 */
- (void)setBackgroundImageWithColors:(NSArray <UIColor *>*)backgroundColors
                            forState:(UIControlState)state
                       directionType:(ZZArtboardDirectionType)directionType;
/**
 设置背景图（多个渐变色、带1px的框）
 
 @param backgroundColors    背景色数组
 @param boderColor          框颜色
 @param state               UIControlState
 @param directionType       ZZArtboardDirectionType（默认左下->右上）
 */
- (void)setBackgroundImageWithColors:(NSArray <UIColor *>*)backgroundColors
                          boderColor:(UIColor *)boderColor
                            forState:(UIControlState)state
                       directionType:(ZZArtboardDirectionType)directionType;

#pragma mark - 图层

/**
 渐变图层
 
 @param frame               frame
 @param colors              渐变颜色数组
 @param directionType       ZZArtboardDirectionType（默认左下->右上）
 @return                    渐变图层
 */
- (CAGradientLayer *)gradientLayerWithFrame:(CGRect)frame
                                     colors:(NSArray <UIColor *>*)colors
                              directionType:(ZZArtboardDirectionType)directionType;

/**
 图层（背景色、带1px框）
 
 @param frame               frame
 @param bgColor             背景色
 @param borderColor         框颜色
 @return                    图层
 */
- (CALayer *)createLayerWithFrame:(CGRect)frame
                          bgColor:(UIColor *)bgColor
                      borderColor:(UIColor *)borderColor;

/**
 图层（背景色）
 
 @param frame               frame
 @param color               背景色
 @return                    图层
 */
- (CALayer *)maskLayerWithFrame:(CGRect)frame
                          color:(UIColor *)color;

/**
 阴影
 */
+ (void)setShadowWithLayer:(CALayer *)layer
                     color:(UIColor *)color
                    offset:(CGSize)offset
                    radius:(CGFloat)radius
                   opacity:(CGFloat)opacity
                    height:(CGFloat)height;

@end

NS_ASSUME_NONNULL_END
