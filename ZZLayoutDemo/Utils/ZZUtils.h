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
#define kCategoryHeight 50
#define kScrollHeight (SCREEN_HEIGHT-kNavTopHeight-kCategoryHeight)
//#define kScrollHeight 180

#ifndef weakify
#if DEBUG
#if __has_feature(objc_arc)
#define weakify(object) autoreleasepool{} __weak __typeof__(object) weak##_##object = object;
#else
#define weakify(object) autoreleasepool{} __block __typeof__(object) block##_##object = object;
#endif
#else
#if __has_feature(objc_arc)
#define weakify(object) try{} @finally{} {} __weak __typeof__(object) weak##_##object = object;
#else
#define weakify(object) try{} @finally{} {} __block __typeof__(object) block##_##object = object;
#endif
#endif
#endif


#ifndef strongify
#if DEBUG
#if __has_feature(objc_arc)
#define strongify(object) autoreleasepool{} __typeof__(object) object = weak##_##object;
#else
#define strongify(object) autoreleasepool{} __typeof__(object) object = block##_##object;
#endif
#else
#if __has_feature(objc_arc)
#define strongify(object) try{} @finally{} __typeof__(object) object = weak##_##object;
#else
#define strongify(object) try{} @finally{} __typeof__(object) object = block##_##object;
#endif
#endif
#endif

static NSString *kZZCellReuseIDCollection = @"collection";
static NSString *kZZCellReuseIDAd = @"ad";
static NSString *kZZCellReuseIDCategory = @"category";
static NSString *kZZCellReuseIDScroll = @"scroll";

static NSString *kCellHeaderDidScroll = @"kCellHeaderDidScroll";
static NSString *kCellItemDidScroll = @"kCellItemDidScroll";
