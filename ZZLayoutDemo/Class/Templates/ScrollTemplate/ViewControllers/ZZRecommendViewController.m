//
//  ZZRecommendViewController.m
//  ZZLayoutDemo
//
//  Created by Jungle on 2019/3/1.
//  Copyright (c) 2019. All rights reserved.
//

#import "ZZRecommendViewController.h"
#import <MJRefresh/MJRefresh.h>
#import "ZZUtils.h"
#import "ZZTotalModel.h"
#import <YYModel/YYModel.h>
#import "ZZBaseTableViewCell.h"
#import "UIColor+ZZ.h"
#import "ZZRecommendCell.h"
#import "UIView+Addtion.h"

@interface ZZRecommendViewController ()<UITableViewDataSource, UITableViewDelegate>

@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) NSMutableArray <ZZCellModel*> *cellArr;

@end

@implementation ZZRecommendViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self.view addSubview:self.tableView];
    self.cellArr = [NSMutableArray new];

    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        NSString *file = [[NSBundle mainBundle] pathForResource:@"cellsdata" ofType:@"geojson"];
        NSData *data = [NSData dataWithContentsOfFile:file];
        ZZSectionModel *sectionModel = [ZZSectionModel yy_modelWithJSON:data];
        [self.cellArr addObjectsFromArray:sectionModel.cellArr];
        [self.tableView reloadData];
    });
}

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

- (UITableView *)tableView
{
    if (!_tableView) {
        _tableView = [[UITableView alloc] initWithFrame:self.view.bounds style:UITableViewStylePlain];
        _tableView.scrollEnabled = NO;
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

