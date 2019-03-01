//
//  ZZLayoutViewController.m
//  ZZLayoutDemo
//
//  Created by Jungle on 2019/2/28.
//  Copyright (c) 2019. All rights reserved.
//

#import "ZZLayoutViewController.h"
#import <MJRefresh/MJRefresh.h>
#import <YYModel/YYModel.h>
#import "UIView+Addtion.h"
#import "ZZTableView.h"
#import "ZZUtils.h"

@interface ZZLayoutViewController ()

@property (nonatomic, strong) UIView *containerView;
@property (nonatomic, strong) UIImageView *searchView;
@property (nonatomic, strong) ZZTableView *tableView;

@end

@implementation ZZLayoutViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    if ([self respondsToSelector:@selector(setAutomaticallyAdjustsScrollViewInsets:)])
        self.automaticallyAdjustsScrollViewInsets = NO;
    
    self.title = @"首页";
    self.view.backgroundColor = [UIColor whiteColor];

    self.searchView = ({
        UIImageView *searchView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, kSearchHeight)];
        searchView.image = [UIImage imageNamed:@"search.png"];
        [self.navigationController.navigationBar addSubview:searchView];
        searchView;
    });

    self.containerView = ({
        UIView *containerView = [[UIView alloc] initWithFrame:CGRectMake(0, kNavTopHeight, SCREEN_WIDTH, self.view.height-kNavTopHeight)];
        containerView.clipsToBounds = YES;
        containerView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
        [self.view addSubview:containerView];
        containerView;
    });
    
    self.tableView = ({
        ZZTableView *tableView = [[ZZTableView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, self.view.height-kNavTopHeight)];
        tableView.backgroundColor = [UIColor lightGrayColor];
        [self.containerView addSubview:tableView];
        tableView;
    });
    
    [self.tableView loadData];
}


@end
