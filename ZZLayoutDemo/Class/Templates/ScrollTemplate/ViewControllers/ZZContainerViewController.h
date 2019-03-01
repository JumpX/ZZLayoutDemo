//
//  ZZContainerViewController.h
//  ZZLayoutDemo
//
//  Created by Jungle on 2019/3/1.
//  Copyright (c) 2019. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN
@class ZZSectionModel;
@interface ZZContainerViewController : UIViewController

@property (nonatomic, strong) UIScrollView *scrollView;

- (void)bindDataWithViewModel:(ZZSectionModel *)viewData;

@end

NS_ASSUME_NONNULL_END
