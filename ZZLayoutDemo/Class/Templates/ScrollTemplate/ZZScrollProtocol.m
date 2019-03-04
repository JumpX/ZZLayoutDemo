
//
//  ZZScrollProtocol.m
//  ZZLayoutDemo
//
//  Created by Jungle on 2019/3/1.
//  Copyright (c) 2019. All rights reserved.
//

#import "ZZScrollProtocol.h"

@implementation ZZScrollProtocol

- (NSString*)subViewName
{
    return @"ZZScrollView";
}

-(NSString *)cellReuseIdentifier:(ZZSectionModel *)sectionModel indexPath:(NSIndexPath *)indexPath
{
    return [NSString stringWithFormat:@"%@%@",sectionModel.templateID, sectionModel.NoNum];
}

- (CGFloat)cellHeight:(ZZSectionModel *)sectionModel indexPath:(NSIndexPath *)indexPath
{
    return kScrollHeight;
}

- (NSUInteger)rowNumInSection:(ZZSectionModel *)sectionModel
{
    return [sectionModel.vcList count] > 0 ? 1 : 0;
}

- (ZZBaseModel*)getRowData:(ZZSectionModel *)sectionModel indexPath:(NSIndexPath *)indexPath
{
    return sectionModel;
}

@end
