//
//  ZZTotalModel.m
//  ZZHomePageDemo
//
//  Created by Jungle on 2019/2/27.
//  Copyright (c) 2019. All rights reserved.
//

#import "ZZTotalModel.h"

@implementation ZZTotalModel

+ (NSDictionary *)modelContainerPropertyGenericClass {
    return @{@"sectionArr" : @"ZZSectionModel"};
}

- (NSString *)cellReuseIdentifier:(ZZSectionModel *)sectionModel indexPath:(NSIndexPath *)indexPath
{
    if ([sectionModel.sectionProtocol respondsToSelector:@selector(cellReuseIdentifier:indexPath:)]) {
        return [sectionModel.sectionProtocol cellReuseIdentifier:sectionModel indexPath:indexPath];
    }
    return @"";
}

- (CGFloat)cellHeight:(ZZSectionModel *)sectionModel indexPath:(NSIndexPath *)indexPath
{
    if ([sectionModel.sectionProtocol respondsToSelector:@selector(cellHeight:indexPath:)]) {
        return [sectionModel.sectionProtocol cellHeight:sectionModel indexPath:indexPath];
    }
    return 0;
}

- (NSUInteger)rowNumInSection:(ZZSectionModel *)sectionModel
{
    if ([sectionModel.sectionProtocol respondsToSelector:@selector(rowNumInSection:)]) {
        return [sectionModel.sectionProtocol rowNumInSection:sectionModel];
    }
    return 1;
}

- (ZZBaseModel *)getRowData:(ZZSectionModel *)sectionModel indexPath:(NSIndexPath *)indexPath
{
    if ([sectionModel.sectionProtocol respondsToSelector:@selector(getRowData:indexPath:)]) {
        return [sectionModel.sectionProtocol getRowData:sectionModel indexPath:indexPath];
    }
    return sectionModel;
}

@end
