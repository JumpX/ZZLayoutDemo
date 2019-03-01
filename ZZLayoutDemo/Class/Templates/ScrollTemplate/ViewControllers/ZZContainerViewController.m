//
//  ZZContainerViewController.m
//  ZZLayoutDemo
//
//  Created by Jungle on 2019/3/1.
//  Copyright (c) 2019. All rights reserved.
//

#import "ZZContainerViewController.h"
#import "ZZRecommendViewController.h"
#import "ZZOtherViewController.h"
#import "ZZSectionModel.h"
#import "UIView+Addtion.h"
#import "ZZUtils.h"

@interface ZZContainerViewController ()<UIScrollViewDelegate>

@property (nonatomic, strong) NSArray *viewControllers;
@property (nonatomic, strong) ZZSectionModel *sectionModel;
@property (nonatomic, assign) NSInteger curIndex;

@end

@implementation ZZContainerViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.scrollView = [[UIScrollView alloc] initWithFrame:self.view.bounds];
    self.scrollView.backgroundColor = [UIColor redColor];
    self.scrollView.showsVerticalScrollIndicator = NO;
    self.scrollView.showsHorizontalScrollIndicator = NO;
    self.scrollView.directionalLockEnabled = YES;
    self.scrollView.pagingEnabled = YES;
    self.scrollView.bounces = NO;
    self.scrollView.delegate = self;
    self.scrollView.scrollsToTop = NO;
    self.scrollView.delaysContentTouches = NO;
    self.scrollView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
    [self.view addSubview:self.scrollView];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(itemDidScroll:) name:kCellItemDidScroll object:nil];
}

- (void)itemDidScroll:(NSNotification *)noti
{
    [self.scrollView setContentOffset:CGPointMake(self.scrollView.width*[noti.object integerValue], 0) animated:YES];
}

- (void)bindDataWithViewModel:(ZZSectionModel *)viewData
{
    self.sectionModel = viewData;
    NSMutableArray <UIViewController *>*vcArrayM = [NSMutableArray new];
    if (self.sectionModel.vcList.count > 1) {
        [self.sectionModel.vcList enumerateObjectsUsingBlock:^(ZZVCModel * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            if (idx == 1) {
                ZZRecommendViewController *vc = [ZZRecommendViewController new];
                [vcArrayM addObject:vc];
            } else {
                ZZOtherViewController *vc = [ZZOtherViewController new];
                [vcArrayM addObject:vc];
            }
        }];
    }
    
    self.viewControllers = vcArrayM;
    
    self.scrollView.contentSize = CGSizeMake(self.view.width * self.sectionModel.vcList.count, self.view.height);
    [self.viewControllers enumerateObjectsUsingBlock:^(UIViewController *viewController, NSUInteger idx, BOOL *stop) {
        viewController.view.frame = CGRectMake(self.view.width * idx, 0, self.view.width, self.view.height);
        [viewController willMoveToParentViewController:self];
        [self addChildViewController:viewController];
        [self.scrollView addSubview:viewController.view];
        [viewController didMoveToParentViewController:self];
    }];
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView {
    NSInteger index = scrollView.contentOffset.x / self.scrollView.width;
    if (index != self.curIndex) {
        self.curIndex = index;
        [[NSNotificationCenter defaultCenter] postNotificationName:kCellHeaderDidScroll object:@(index)];
    }
}


@end
