//
//  ZZAdProtocol.m
//  ZZLayoutDemo
//
//  Created by Jungle on 2019/3/1.
//  Copyright (c) 2019. All rights reserved.
//

#import "ZZAdProtocol.h"

@implementation ZZAdProtocol

- (NSString*)subViewName
{
    return @"ZZAdView";
}

-(NSString *)cellReuseIdentifier:(ZZSectionModel *)sectionModel indexPath:(NSIndexPath *)indexPath
{
    return [NSString stringWithFormat:@"%@%@",sectionModel.templateID, sectionModel.NoNum];
}

- (CGFloat)cellHeight:(ZZSectionModel *)sectionModel indexPath:(NSIndexPath *)indexPath
{
    return kAdHeight;
}

- (NSUInteger)rowNumInSection:(ZZSectionModel *)sectionModel
{
    return [sectionModel.cellArr count];
}

- (ZZBaseModel*)getRowData:(ZZSectionModel *)sectionModel indexPath:(NSIndexPath *)indexPath
{
    ZZCellModel *cellModel = sectionModel.cellArr[indexPath.row];
    return cellModel;
}

@end
