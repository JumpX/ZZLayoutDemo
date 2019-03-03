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
//@property (nonatomic, assign) NSInteger         curIndex;

@end

@implementation ZZContainerViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(titleEndIndex:) name:@"kZZTitleEndIndex" object:nil];

//    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(itemDidScroll:) name:kCellItemDidScroll object:nil];

//    self.scrollView = [[UIScrollView alloc] initWithFrame:self.view.bounds];
//    self.scrollView.backgroundColor = [UIColor redColor];
//    self.scrollView.showsVerticalScrollIndicator = NO;
//    self.scrollView.showsHorizontalScrollIndicator = NO;
//    self.scrollView.directionalLockEnabled = YES;
//    self.scrollView.pagingEnabled = YES;
//    self.scrollView.bounces = NO;
//    self.scrollView.delegate = self;
//    self.scrollView.scrollsToTop = NO;
//    self.scrollView.delaysContentTouches = NO;
//    self.scrollView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
//    [self.view addSubview:self.scrollView];
}

#pragma mark - Status Change

//- (void)itemDidScroll:(NSNotification *)noti
//{
//    [self.scrollView setContentOffset:CGPointMake(self.scrollView.width*[noti.object integerValue], 0) animated:YES];
//}

- (void)titleEndIndex:(NSNotification *)noti
{
    self.pageContentView.contentViewCurrentIndex = [noti.object integerValue];
}

#pragma mark - Bind Data

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
    
    self.pageContentView = [[BXPageContentView alloc] initWithFrame:self.view.bounds childVCs:vcArrayM parentVC:self delegate:self];
    [self.view addSubview:self.pageContentView];
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

#pragma mark - UIScrollViewDelegate

//- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView
//{
//    [[NSNotificationCenter defaultCenter] postNotificationName:@"kZZTableViewCanScroll" object:@(NO)];
//}
//
//- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView {
//    NSInteger index = scrollView.contentOffset.x / self.scrollView.width;
//    if (index != self.curIndex) {
//        self.curIndex = index;
//        [[NSNotificationCenter defaultCenter] postNotificationName:kCellHeaderDidScroll object:@(index)];
//    }
//    [[NSNotificationCenter defaultCenter] postNotificationName:@"kZZTableViewCanScroll" object:@(YES)];
//}


@end
