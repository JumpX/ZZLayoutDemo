//
//  ZZMainViewController.m
//  ZZLayoutDemo
//
//  Created by Jungle on 2019/2/28.
//  Copyright (c) 2019. All rights reserved.
//

#import "ZZMainViewController.h"
#import "ZZLayoutViewController.h"

@interface ZZMainViewController ()

@end

@implementation ZZMainViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.title = @"布局Demo";
    
    UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
    btn.frame = CGRectMake(100, 400, 200, 100);
    btn.backgroundColor = [UIColor blueColor];
    [btn setTitle:@"进入首页" forState:UIControlStateNormal];
    [btn addTarget:self action:@selector(jumpHomePage) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:btn];
}

- (void)jumpHomePage
{
    ZZLayoutViewController *homepageVC = [ZZLayoutViewController new];
    [self.navigationController pushViewController:homepageVC animated:YES];
}

@end
