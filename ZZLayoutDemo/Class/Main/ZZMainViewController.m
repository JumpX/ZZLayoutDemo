//
//  ZZMainViewController.m
//  ZZLayoutDemo
//
//  Created by Jungle on 2019/2/28.
//  Copyright (c) 2019. All rights reserved.
//

#import "ZZMainViewController.h"
#import "ZZLayoutViewController.h"
#import <ZZArtboardButton/ZZArtboardButton.h>
#import <ZZAdd/UIColor+ZZAdd.h>

@interface ZZMainViewController ()

@end

@implementation ZZMainViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.title = @"布局Demo";
    
    ZZArtboardButton *btn = [ZZArtboardButton buttonWithType:UIButtonTypeCustom];
    btn.frame = CGRectMake(100, 400, 200, 100);
    [btn setType:ZZArtboardTypeCustom textColor:[UIColor whiteColor] font:[UIFont systemFontOfSize:20 weight:UIFontWeightMedium] text:@"进入首页"];
    [btn setBackgroundImageWithColors:@[[UIColor blueColor],[UIColor randomColor],[UIColor redColor]] forState:UIControlStateNormal directionType:ZZArtboardDirectionTypeLeftTopToRightBottom];
    [btn addTarget:self action:@selector(jumpHomePage) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:btn];
}

- (void)jumpHomePage
{
    ZZLayoutViewController *homepageVC = [ZZLayoutViewController new];
    [self.navigationController pushViewController:homepageVC animated:YES];
}

@end
