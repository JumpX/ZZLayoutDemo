//
//  ZZUtils.h
//  ZZLayoutDemo
//
//  Created by Jungle on 2019/3/1.
//  Copyright (c) 2019. All rights reserved.
//

#import <Foundation/Foundation.h>

#define SCREEN_WIDTH [UIScreen mainScreen].bounds.size.width
#define SCREEN_HEIGHT [UIScreen mainScreen].bounds.size.height
#define NAVIGATION_BAR_HEIGHT           44
#define KNewStatusBarHeight                [[UIApplication sharedApplication] statusBarFrame].size.height
#define kNavTopHeight  (KNewStatusBarHeight+NAVIGATION_BAR_HEIGHT)
#define kSearchHeight 50
#define kCollectionHeight 80
#define kAdHeight 100
#define kCategoryHeight 40
#define kScrollHeight (SCREEN_HEIGHT-kNavTopHeight-kCategoryHeight)
//#define kScrollHeight 180

static NSString *kZZCellReuseIDCollection = @"collection";
static NSString *kZZCellReuseIDAd = @"ad";
static NSString *kZZCellReuseIDCategory = @"category";
static NSString *kZZCellReuseIDScroll = @"scroll";

static NSString *kCellHeaderDidScroll = @"kCellHeaderDidScroll";
static NSString *kCellItemDidScroll = @"kCellItemDidScroll";

NS_ASSUME_NONNULL_BEGIN

@interface ZZUtils : NSObject

@end

NS_ASSUME_NONNULL_END
