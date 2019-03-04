//
//  ZZCollectionProtocol.m
//  ZZLayoutDemo
//
//  Created by Jungle on 2019/3/1.
//  Copyright (c) 2019. All rights reserved.
//

#import "ZZCollectionProtocol.h"

@implementation ZZCollectionProtocol

- (NSString*)subViewName
{
    return @"ZZCollectionView";
}

- (NSString *)cellReuseIdentifier:(ZZSectionModel *)sectionModel indexPath:(NSIndexPath *)indexPath
{
    return [NSString stringWithFormat:@"%@%@",sectionModel.templateID, sectionModel.NoNum];
}

- (CGFloat)cellHeight:(ZZSectionModel *)sectionModel indexPath:(NSIndexPath *)indexPath
{
    return kCollectionHeight;
}

- (NSUInteger)rowNumInSection:(ZZSectionModel *)sectionModel
{
    return [sectionModel.cellList count];
}

- (ZZBaseModel*)getRowData:(ZZSectionModel *)sectionModel indexPath:(NSIndexPath *)indexPath
{
    ZZCellModel *cellModel = sectionModel.cellList[indexPath.row];
    return cellModel;
}

@end
