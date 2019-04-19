//
//  ZZDisplayView.m
//  ZZLayoutDemo
//
//  Created by Jungle on 2019/3/3.
//  Copyright (c) 2019. All rights reserved.
//

#import "ZZDisplayView.h"
#import <MJRefresh/MJRefresh.h>
#import "ZZUtils.h"
#import "ZZTotalModel.h"
#import <YYModel/YYModel.h>
#import "ZZBaseTableViewCell.h"
#import "UIColor+ZZ.h"
#import "ZZTableView.h"
#import <ZZTabViewBar/ZZTabViewBar.h>
#import <ZZTabViewBar/ZZTabMutiPage.h>
#import "ZZRecommendViewController.h"
#import "ZZOtherViewController.h"

@interface ZZDisplayView () <UITableViewDataSource, UITableViewDelegate, ZZTabViewBarDelegate, ZZTabMutiPageDelegate, ZZTabMutiPageDataSource>

@property (nonatomic, strong) ZZTabViewBar  *tabViewBar;
@property (nonatomic, copy)   NSArray       *titleList;
@property (nonatomic, copy)   NSArray       *vcList;
@property (nonatomic, strong) ZZTabMutiPage *mutiPage;
@property (nonatomic, strong) ZZTableView   *tableView;
@property (nonatomic, strong) ZZTotalModel  *totalModel;
@property (nonatomic, assign) BOOL          canScroll;
@property (nonatomic, assign) BOOL          cellCanScroll;

@end

@implementation ZZDisplayView

- (void)dealloc
{
    NSLog(@"ZZDisplayView dealloc");
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

#pragma mark - Data

- (void)localData
{
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        NSString *file = [[NSBundle mainBundle] pathForResource:@"data" ofType:@"geojson"];
        NSData *data = [NSData dataWithContentsOfFile:file];
        self.totalModel = [ZZTotalModel yy_modelWithJSON:data];
        [self.tableView reloadData];
        if ([self.tableView.mj_header isRefreshing]) {
            [self.tableView.mj_header endRefreshing];
        }
    });
}

- (void)loadData
{
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        NSString *file = [[NSBundle mainBundle] pathForResource:@"newdata" ofType:@"geojson"];
        NSData *data = [NSData dataWithContentsOfFile:file];
        self.totalModel = [ZZTotalModel yy_modelWithJSON:data];
        [self.tableView reloadData];
        if ([self.tableView.mj_header isRefreshing]) {
            [self.tableView.mj_header endRefreshing];
        }
    });
}

#pragma mark - Life Cycle

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.canScroll = YES;
        self.titleList = [NSArray array];
        self.vcList = [NSArray array];
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(changeScrollStatus) name:@"kZZTableViewLeaveTop" object:nil];
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(tableViewCanScroll:) name:@"kZZTableViewCanScroll" object:nil];
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(scrollEndIndex:) name:@"kZZScrollEndIndex" object:nil];
        @weakify(self)
        self.tableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
            @strongify(self)
            [self loadData];
        }];
        [self localData];
//        [self.tableView.mj_header beginRefreshing];
    }
    return self;
}

#pragma mark - Status Change

- (void)scrollEndIndex:(NSNotification *)noti
{
    [self.tabViewBar tabViewBarScrollToIndex:[noti.object integerValue]];
}

- (void)tableViewCanScroll:(NSNotification *)noti
{
    self.tableView.scrollEnabled = [noti.object boolValue];
}

- (void)changeScrollStatus//改变主视图的状态
{
    self.canScroll = YES;
    self.cellCanScroll = NO;
}

- (void)setCellCanScroll:(BOOL)cellCanScroll
{
    _cellCanScroll = cellCanScroll;
    [[NSNotificationCenter defaultCenter] postNotificationName:@"kZZVCCanScroll" object:@(cellCanScroll)];
}

#pragma mark - UITableViewDataSource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return self.totalModel.sectionArr.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    ZZSectionModel *sectionModel = self.totalModel.sectionArr[section];
    return [self.totalModel rowNumInSection:sectionModel];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    ZZSectionModel *sectionModel = self.totalModel.sectionArr[indexPath.section];
    CGFloat cellHeight = [self.totalModel cellHeight:sectionModel indexPath:indexPath];
    return  cellHeight;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    ZZSectionModel *sectionModel = self.totalModel.sectionArr[indexPath.section];
    NSString *cellReuseID = [self.totalModel cellReuseIdentifier:sectionModel indexPath:indexPath];
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellReuseID];
    CGFloat height = [self.totalModel cellHeight:sectionModel indexPath:indexPath];
    if ([sectionModel.templateID isEqualToString:kZZCellReuseIDScroll]) {
        if (!cell) {
            cell = [[ZZBaseTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellReuseID];
            self.mutiPage.frame = CGRectMake(0, 0, CGRectGetWidth(self.frame), height);
            [cell.contentView addSubview:self.mutiPage];
        }
        if (self.vcList.count > 0) {
            return cell;
        } else {
            NSMutableArray <UIViewController *>*vcArrayM = [NSMutableArray new];
            if (sectionModel.vcList.count > 1) {
                [sectionModel.vcList enumerateObjectsUsingBlock:^(ZZVCModel * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
                    if (idx == 1) {
                        ZZRecommendViewController *vc = [ZZRecommendViewController new];
                        [vcArrayM addObject:vc];
                    } else {
                        ZZOtherViewController *vc = [ZZOtherViewController new];
                        [vcArrayM addObject:vc];
                    }
                }];
            }
            self.vcList = [vcArrayM copy];
            return cell;
        }
    } else {
        if (!cell)
        {
            cell = [[ZZBaseTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault
                                              reuseIdentifier:cellReuseID
                                                   cellHeight:height
                                                 sectionModel:sectionModel];
            cell.contentView.backgroundColor = [UIColor colorWithHex:self.totalModel.bgColor];
        }
        return cell;
    }
}

- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath
{
    ZZSectionModel *sectionModel = self.totalModel.sectionArr[indexPath.section];
    ZZBaseTableViewCell *baseCell = (ZZBaseTableViewCell*)cell;
    ZZBaseModel* rowData = [self.totalModel getRowData:sectionModel indexPath:indexPath];
    [baseCell bindDataWithViewModel:rowData];
    [baseCell cellWillDisplay];
}

- (void)tableView:(UITableView *)tableView didEndDisplayingCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath
{
    ZZBaseTableViewCell *baseCell = (ZZBaseTableViewCell*)cell;
    [baseCell cellEndDisplaying];
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    ZZSectionModel *sectionModel = self.totalModel.sectionArr[section];
    if (sectionModel.tabList.count > 0) {
        return kCategoryHeight;
    }
    return 0;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    if (self.titleList.count > 0) {
        return self.tabViewBar;
    } else {
        ZZSectionModel *sectionModel = self.totalModel.sectionArr[section];
        if (sectionModel.tabList.count > 0) {
            NSMutableArray *titles = [NSMutableArray new];
            [sectionModel.tabList enumerateObjectsUsingBlock:^(ZZTabModel * _Nonnull model, NSUInteger idx, BOOL * _Nonnull stop) {
                [titles addObject:model.tabName];
            }];
            self.titleList = [titles copy];
            [self.tabViewBar reloadTabViewBar];
            [self.tabViewBar tabViewBarScrollToIndex:0];
            [self.mutiPage reloadMutiPage];
            self.mutiPage.currentIndex = sectionModel.tabIndex;
        }
        return self.tabViewBar;
    }
}

- (NSInteger)numberOfItemsInTabViewBar:(ZZTabViewBar *)tabViewBar {
    return self.titleList.count;
}

- (NSString *)tabViewBar:(ZZTabViewBar *)tabViewBar titleForItemAtIndex:(NSInteger)index {
    return self.titleList[index];
}

- (void)tabViewBar:(ZZTabViewBar *)tabViewBar didSelectItemAtIndex:(NSInteger)index {
    self.mutiPage.currentIndex = index;
}

- (UIViewController *)parentVCForMutiPage:(ZZTabMutiPage *)mutiPage {
    return self.parentVC;
}

- (NSInteger)numberOfChildVCsInMutiPage:(ZZTabMutiPage *)mutiPage {
    return self.vcList.count;
}

- (UIViewController *)mutiPage:(ZZTabMutiPage *)mutiPage childVCAtIndex:(NSInteger)index {
    return self.vcList[index];
}

- (void)mutiPageWillBeginDragging:(ZZTabMutiPage *)mutiPage {

}

- (void)mutiPageDidScroll:(ZZTabMutiPage *)mutiPage startIndex:(NSInteger)startIndex endIndex:(NSInteger)endIndex progress:(CGFloat)progress {
    [self.tabViewBar tabViewBarScrollFromStartIndex:startIndex endIndex:endIndex progress:progress];
}

- (void)mutiPageDidEndDecelerating:(ZZTabMutiPage *)mutiPage {

}

- (void)mutiPage:(ZZTabMutiPage *)mutiPage selectedItemAtIndex:(NSInteger)index {
    ZZSectionModel *sectionModel = self.totalModel.sectionArr.lastObject;
    sectionModel.tabIndex = index;
    [self.tabViewBar tabViewBarScrollToIndex:index];
}

#pragma mark - UIScrollViewDelegate

- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    if (!self.totalModel) return;
    
    CGFloat bottom = [self.tableView rectForSection:self.totalModel.sectionArr.count-1].origin.y;
    if (scrollView.contentOffset.y >= bottom) {
        scrollView.contentOffset = CGPointMake(0, bottom);
        if (self.canScroll) {
            self.canScroll = NO;
            self.cellCanScroll = YES;
        }
    } else {
        if (!self.canScroll) {
            scrollView.contentOffset = CGPointMake(0, bottom);
        }
    }
}

#pragma mark - Getter

- (ZZTableView *)tableView
{
    if (!_tableView) {
        _tableView = [[ZZTableView alloc] initWithFrame:self.bounds style:UITableViewStylePlain];
        if (@available(iOS 11.0, *)){
            _tableView.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
        }
        _tableView.delegate = (id<UITableViewDelegate>)self;
        _tableView.dataSource = (id<UITableViewDataSource>)self;
        _tableView.showsVerticalScrollIndicator = NO;
        _tableView.showsHorizontalScrollIndicator = NO;
        _tableView.backgroundColor = [UIColor clearColor];
        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        _tableView.alwaysBounceVertical = YES;
        [self addSubview:_tableView];
    }
    return _tableView;
}

- (ZZTabViewBar *)tabViewBar {
    if (!_tabViewBar) {
        _tabViewBar = [[ZZTabViewBar alloc] initWithFrame:CGRectMake(0, 0, CGRectGetWidth(self.frame), 50)];
        _tabViewBar.backgroundColor = [UIColor whiteColor];
        _tabViewBar.normalFont = [UIFont systemFontOfSize:15.0f weight:UIFontWeightMedium];
        _tabViewBar.selectedFont = [UIFont systemFontOfSize:18.0f weight:UIFontWeightMedium];
        _tabViewBar.normalColor = [UIColor colorWithHex:@"#9B9B9B"];
        _tabViewBar.selectedColor = [UIColor colorWithHex:@"#111111"];
        _tabViewBar.redPointType = ZZTabViewBarRedPointTypeSolid;
        _tabViewBar.indicatorType = ZZTabViewBarIndicatorTypeImage;
        _tabViewBar.indicatorToBottomInterval = 12.5;
        _tabViewBar.titleToBottomInterval = 12.5;
        _tabViewBar.itemSpace = 15.0;
        _tabViewBar.delegate = self;
    }
    return _tabViewBar;
}

- (ZZTabMutiPage *)mutiPage {
    if (!_mutiPage) {
        _mutiPage = [ZZTabMutiPage new];
        _mutiPage.didAppearPercent = 0.01;
        _mutiPage.dataSource = self;
        _mutiPage.delegate = self;
    }
    return _mutiPage;
}

@end
