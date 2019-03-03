//
//  ZZOtherViewController.m
//  ZZLayoutDemo
//
//  Created by Jungle on 2019/3/1.
//  Copyright (c) 2019. All rights reserved.
//

#import "ZZOtherViewController.h"
#import <MJRefresh/MJRefresh.h>
#import "ZZUtils.h"
#import "ZZTotalModel.h"
#import <YYModel/YYModel.h>
#import "ZZBaseTableViewCell.h"
#import "UIColor+ZZ.h"
#import "ZZRecommendCell.h"
#import "UIView+Addtion.h"

@interface ZZOtherViewController ()<UITableViewDataSource, UITableViewDelegate>

@property (nonatomic, strong) UITableView                   *tableView;
@property (nonatomic, strong) NSMutableArray <ZZCellModel*> *cellArr;
@property (nonatomic, assign) BOOL                          vcCanScroll;

@end

@implementation ZZOtherViewController

#pragma mark - Data

- (void)loadData
{
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        NSString *file = [[NSBundle mainBundle] pathForResource:@"cellsdata" ofType:@"geojson"];
        NSData *data = [NSData dataWithContentsOfFile:file];
        ZZSectionModel *sectionModel = [ZZSectionModel yy_modelWithJSON:data];
        [self.cellArr addObjectsFromArray:sectionModel.cellArr];
        [self.tableView reloadData];
//        if ([self.tableView.mj_footer isRefreshing]) {
//            [self.tableView.mj_footer endRefreshing];
//        }
    });
}

#pragma mark - Life Cycle

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor = [UIColor whiteColor];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(ZZVCCanScroll:) name:@"kZZVCCanScroll" object:nil];
    
    self.cellArr = [NSMutableArray new];
    self.tableView.mj_footer = [MJRefreshAutoFooter footerWithRefreshingBlock:^{
        [self loadData];
    }];
}

- (void)viewWillAppear:(BOOL)animated
{
    [self loadData];
}

#pragma mark - Status Change

- (void)ZZVCCanScroll:(NSNotification *)noti
{
    _vcCanScroll = [noti.object boolValue];
    if (!_vcCanScroll) {
        self.tableView.contentOffset = CGPointZero;
    }
}

#pragma mark - UITableViewDataSource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.cellArr.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 180;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *reuseID = @"ZZRecommendCell";
    ZZCellModel *cellModel = self.cellArr[indexPath.row];
    ZZRecommendCell *cell = [tableView dequeueReusableCellWithIdentifier:reuseID];
    if (!cell)
    {
        cell = [[ZZRecommendCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:reuseID];
        cell.frame = CGRectMake(0, 0, tableView.width, 180);
    }
    [cell bindDataWithViewModel:cellModel];
    return cell;
}

#pragma mark - UIScrollViewDelegate

- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    if (!self.vcCanScroll) {
        scrollView.contentOffset = CGPointZero;
    }
    if (scrollView.contentOffset.y <= 0) {
        self.vcCanScroll = NO;
        scrollView.contentOffset = CGPointZero;
        [[NSNotificationCenter defaultCenter] postNotificationName:@"kZZTableViewLeaveTop" object:nil];//到顶通知父视图改变状态
    }
    self.tableView.showsVerticalScrollIndicator = _vcCanScroll?YES:NO;
}

#pragma mark - Getter

- (UITableView *)tableView
{
    if (!_tableView) {
        _tableView = [[UITableView alloc] initWithFrame:self.view.bounds style:UITableViewStylePlain];
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
        [self.view addSubview:_tableView];
    }
    return _tableView;
}


@end
