//
//  BXPageContentView.h
//  ZZLayoutDemo
//
//  Created by Jungle on 2019/3/3.
//  Copyright (c) 2019. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@class BXPageContentView;

@protocol BXPageContentViewDelegate <NSObject>

@optional

/**
 BXPageContentView开始滑动
 
 @param contentView BXPageContentView
 */
- (void)BXContentViewWillBeginDragging:(BXPageContentView *)contentView;

/**
 BXPageContentView滑动调用
 
 @param contentView BXPageContentView
 @param startIndex 开始滑动页面索引
 @param endIndex 结束滑动页面索引
 @param progress 滑动进度
 */
- (void)BXContentViewDidScroll:(BXPageContentView *)contentView startIndex:(NSInteger)startIndex endIndex:(NSInteger)endIndex progress:(CGFloat)progress;

/**
 BXPageContentView结束滑动
 
 @param contentView BXPageContentView
 @param startIndex 开始滑动索引
 @param endIndex 结束滑动索引
 */
- (void)BXContenViewDidEndDecelerating:(BXPageContentView *)contentView startIndex:(NSInteger)startIndex endIndex:(NSInteger)endIndex;

@end

@interface BXPageContentView : UIView

/**
 对象方法创建BXPageContentView
 
 @param frame frame
 @param childVCs 子VC数组
 @param parentVC 父视图VC
 @param delegate delegate
 @return BXPageContentView
 */
- (instancetype)initWithFrame:(CGRect)frame childVCs:(NSArray *)childVCs parentVC:(UIViewController *)parentVC delegate:(id<BXPageContentViewDelegate>)delegate;

@property (nonatomic, weak) id<BXPageContentViewDelegate>delegate;

/**
 设置contentView当前展示的页面索引，默认为0
 */
@property (nonatomic, assign) NSInteger contentViewCurrentIndex;

/**
 设置contentView能否左右滑动，默认YES
 */
@property (nonatomic, assign) BOOL contentViewCanScroll;

@end


NS_ASSUME_NONNULL_END
