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
@property (nonatomic, strong) NSMutableArray <ZZCellModel*> *cellList;
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
        [self.cellList addObjectsFromArray:sectionModel.cellList];
        [self.tableView reloadData];
    });
}

#pragma mark - Life Cycle

- (void)dealloc
{
    NSLog(@"Other --dealloc");
}

- (void)viewDidLoad {
    [super viewDidLoad];
    NSLog(@"viewDidLoad");

    self.view.backgroundColor = [UIColor whiteColor];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(ZZVCCanScroll:) name:@"kZZVCCanScroll" object:nil];
    
    self.cellList = [NSMutableArray new];
    @weakify(self);
    self.tableView.mj_footer = [MJRefreshAutoFooter footerWithRefreshingBlock:^{
        @strongify(self);
        [self loadData];
    }];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    NSLog(@"viewWillAppear");
    [self loadData];
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    NSLog(@"viewDidAppear");
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    NSLog(@"viewWillDisappear");
}

- (void)viewDidDisappear:(BOOL)animated
{
    [super viewDidDisappear:animated];
    NSLog(@"viewDidDisappear");
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
    return self.cellList.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 180;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *reuseID = @"ZZRecommendCell";
    ZZCellModel *cellModel = self.cellList[indexPath.row];
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
