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
#import "ZZDisplayView.h"
#import "ZZUtils.h"

@interface ZZLayoutViewController ()

@property (nonatomic, strong) UIView        *containerView;
@property (nonatomic, strong) UIImageView   *searchView;
@property (nonatomic, strong) ZZDisplayView *displayView;

@end

@implementation ZZLayoutViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = @"首页";
    self.view.backgroundColor = [UIColor whiteColor];
    self.automaticallyAdjustsScrollViewInsets = NO;
        
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
    
    self.displayView = ({
        ZZDisplayView *displayView = [[ZZDisplayView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, self.view.height-kNavTopHeight)];
        displayView.backgroundColor = [UIColor lightGrayColor];
        [self.containerView addSubview:displayView];
        displayView;
    });
}

@end
