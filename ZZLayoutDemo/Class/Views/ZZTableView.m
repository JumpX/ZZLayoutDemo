//
//  ZZTableView.m
//  ZZLayoutDemo
//
//  Created by Jungle on 2019/2/28.
//  Copyright (c) 2019. All rights reserved.
//

#import "ZZTableView.h"
#import <MJRefresh/MJRefresh.h>
#import "ZZUtils.h"
#import "ZZTotalModel.h"
#import <YYModel/YYModel.h>
#import "ZZBaseTableViewCell.h"
#import "UIColor+ZZ.h"
#import "ZZCategoryView.h"

@interface ZZTableView () <UITableViewDataSource, UITableViewDelegate>

@property (nonatomic, strong) ZZTotalModel *totalModel;

@end

@implementation ZZTableView

- (void)loadData
{
    [self.tableView.mj_header beginRefreshing];
}

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self addSubview:self.tableView];
        self.tableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                NSString *file = [[NSBundle mainBundle] pathForResource:@"data" ofType:@"geojson"];
                NSData *data = [NSData dataWithContentsOfFile:file];
                self.totalModel = [ZZTotalModel yy_modelWithJSON:data];
                [self.tableView.mj_header endRefreshing];
                [self.tableView reloadData];
            });
        }];
    }
    return self;
}

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
    ZZSectionModel *sectionModel = self.totalModel.sectionArr[section];
    if (sectionModel.tabList.count > 0) {
        ZZCategoryView *headerView = [[ZZCategoryView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, kCategoryHeight)];
        [headerView bindDataWithViewModel:sectionModel];
        return headerView;
    }
    return nil;
}

- (UITableView *)tableView
{
    if (!_tableView) {
        _tableView = [[UITableView alloc] initWithFrame:self.bounds style:UITableViewStylePlain];
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
    }
    return _tableView;
}

@end
