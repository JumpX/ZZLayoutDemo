//
//  ZZTableView.h
//  ZZLayoutDemo
//
//  Created by Jungle on 2019/2/28.
//  Copyright (c) 2019. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface ZZTableView : UIView

@property (nonatomic, strong) UITableView *tableView;

- (void)loadData;

@end

NS_ASSUME_NONNULL_END
