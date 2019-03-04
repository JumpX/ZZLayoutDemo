//
//  ZZScrollView.m
//  ZZLayoutDemo
//
//  Created by Jungle on 2019/3/1.
//  Copyright (c) 2019. All rights reserved.
//

#import "ZZScrollView.h"
#import "ZZRecommendViewController.h"
#import "ZZOtherViewController.h"
#import "ZZSectionModel.h"
#import "ZZContainerViewController.h"

@interface ZZScrollView ()

@property (nonatomic, strong) NSArray                   *viewControllers;
@property (nonatomic, strong) ZZSectionModel            *sectionModel;
@property (nonatomic, strong) ZZContainerViewController *containerVC;

@end

@implementation ZZScrollView

- (instancetype)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame]) {
        self.backgroundColor = [UIColor whiteColor];
        self.containerVC = [ZZContainerViewController new];
        [self addSubview:self.containerVC.view];
    }
    return self;
}

- (void)bindDataWithViewModel:(ZZSectionModel *)viewData
{
    self.sectionModel = viewData;
    [self.containerVC bindDataWithViewModel:viewData];
}

@end
