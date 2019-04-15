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
#import "BXPageContentView.h"

@interface ZZContainerViewController ()<BXPageContentViewDelegate>

@property (nonatomic, strong) BXPageContentView *pageContentView;
@property (nonatomic, strong) NSArray           *viewControllers;
@property (nonatomic, strong) ZZSectionModel    *sectionModel;

@end

@implementation ZZContainerViewController

- (void)dealloc
{
    NSLog(@"PageContainer --dealloc");
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(titleEndIndex:) name:@"kZZTitleEndIndex" object:nil];
}

#pragma mark - Status Change

- (void)titleEndIndex:(NSNotification *)noti
{
    self.pageContentView.contentViewCurrentIndex = [noti.object integerValue];
}

#pragma mark - Bind Data

- (void)bindDataWithViewModel:(ZZSectionModel *)viewData
{
    // 数据一致，不刷新
    if ([self.sectionModel isEqualToSectionModel:viewData]) {
        return;
    }
    
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
    [self.pageContentView setChildVCs:vcArrayM parentVC:self delegate:self];
}

#pragma mark BXSegmentTitleViewDelegate
- (void)BXContenViewDidEndDecelerating:(BXPageContentView *)contentView startIndex:(NSInteger)startIndex endIndex:(NSInteger)endIndex
{
    [[NSNotificationCenter defaultCenter] postNotificationName:@"kZZTableViewCanScroll" object:@(YES)];
    [[NSNotificationCenter defaultCenter] postNotificationName:@"kZZScrollEndIndex" object:@(endIndex)];
}

- (void)BXContentViewDidScroll:(BXPageContentView *)contentView startIndex:(NSInteger)startIndex endIndex:(NSInteger)endIndex progress:(CGFloat)progress
{
    [[NSNotificationCenter defaultCenter] postNotificationName:@"kZZTableViewCanScroll" object:@(NO)];
}

- (BXPageContentView *)pageContentView
{
    if (!_pageContentView) {
        _pageContentView = [[BXPageContentView alloc] initWithFrame:self.view.bounds];
        [self.view addSubview:_pageContentView];
    }
    return _pageContentView;
}

@end
