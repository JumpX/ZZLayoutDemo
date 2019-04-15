//
//  UIColor+ZZAdd.h
//  ZZArtboardButton
//
//  Created by Jungle on 2019/3/26.
//  Copyright (c) 2019. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface UIColor (ZZAdd)

+ (UIColor *)randomColor;

+ (UIColor *)colorWithHex:(NSString *)hex;
+ (UIColor *)colorWithHex:(NSString *)hex alpha:(CGFloat)alpha;
+ (UIColor *)colorWithHex:(NSString *)hex defaultHex:(NSString *)defaultHex;
+ (UIColor *)colorWithHex:(NSString *)hex defaultHex:(NSString *)defaultHex alpha:(CGFloat)alpha;

@end

NS_ASSUME_NONNULL_END
