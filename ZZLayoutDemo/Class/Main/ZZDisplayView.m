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
#import "BXSegmentTitleView.h"

@interface ZZDisplayView () <UITableViewDataSource, UITableViewDelegate, BXSegmentTitleViewDelegate>

@property (nonatomic, strong) BXSegmentTitleView *titleView;
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
    self.titleView.selectIndex = [noti.object integerValue];
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
    if (!cell)
    {
        CGFloat height = [self.totalModel cellHeight:sectionModel indexPath:indexPath];
        cell = [[ZZBaseTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault
                                          reuseIdentifier:cellReuseID
                                               cellHeight:height
                                             sectionModel:sectionModel];
        cell.contentView.backgroundColor = [UIColor colorWithHex:self.totalModel.bgColor];
    }
    return cell;
    
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
//    tableView insertSections:<#(nonnull NSIndexSet *)#> withRowAnimation:<#(UITableViewRowAnimation)#>
//    tableView reloadSections:<#(nonnull NSIndexSet *)#> withRowAnimation:<#(UITableViewRowAnimation)#>
    ZZSectionModel *sectionModel = self.totalModel.sectionArr[section];
    if (sectionModel.tabList.count > 0) {
        NSMutableArray *titles = [NSMutableArray new];
        CGFloat width = sectionModel.tabList.firstObject.tabWidth.floatValue;
        [sectionModel.tabList enumerateObjectsUsingBlock:^(ZZTabModel * _Nonnull model, NSUInteger idx, BOOL * _Nonnull stop) {
            [titles addObject:model.tabName];
        }];
        self.titleView = [[BXSegmentTitleView alloc]initWithFrame:CGRectMake(0, 0, width, 50) titles:titles delegate:self indicatorType:BXIndicatorTypeEqualTitle];
        return self.titleView;
    }
    return nil;
}

- (void)BXSegmentTitleView:(BXSegmentTitleView *)titleView startIndex:(NSInteger)startIndex endIndex:(NSInteger)endIndex
{
    [[NSNotificationCenter defaultCenter] postNotificationName:@"kZZTitleEndIndex" object:@(endIndex)];
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

@end
