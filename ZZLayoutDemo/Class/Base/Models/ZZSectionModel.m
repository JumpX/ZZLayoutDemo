//
//  ZZSectionModel.m
//  ZZLayoutDemo
//
//  Created by Jungle on 2019/2/27.
//  Copyright (c) 2019. All rights reserved.
//

#import "ZZSectionModel.h"

@implementation ZZSectionModel

+ (NSDictionary *)modelContainerPropertyGenericClass {
    return @{@"cellList" : @"ZZCellModel",
             @"tabList" : @"ZZTabModel",
             @"vcList" : @"ZZVCModel"
             };
}

- (BOOL)modelCustomTransformFromDictionary:(NSDictionary *)dic
{
    [self bindSectionProtocol];
    return YES;
}

- (void)bindSectionProtocol
{
    if (self.templateID)
    {
        NSDictionary* dict  = ZZCellClassDict();
        if(dict[self.templateID])
        {
            Class sectionProtocolClass = NSClassFromString(dict[self.templateID]);
            if (sectionProtocolClass)
            {
                NSObject *sectionProtocol = [sectionProtocolClass new];
                if ([sectionProtocol conformsToProtocol:@protocol(ZZSectionProtocol)]) {
                    self.sectionProtocol = (NSObject<ZZSectionProtocol>*)sectionProtocol;
                }
            }
        }
    }
}

- (BOOL)isEqualToSectionModel:(ZZSectionModel *)sectionModel
{
    if (!self || !sectionModel) {
        return NO;
    }
    if ([self.templateID isEqualToString:sectionModel.templateID] &&
        [self isEqualToTabList:sectionModel.tabList] &&
        [self isEqualToVCList:sectionModel.vcList] &&
        [self isEqualToCellList:sectionModel.cellList]) {
        return YES;
    } else {
        return NO;
    }
}

- (BOOL)isEqualToTabList:(NSArray<ZZTabModel *>*)tabList
{
    __block BOOL isEqual = YES;
    if (self.tabList.count != tabList.count) {
        isEqual = NO;
    } else {
        [self.tabList enumerateObjectsUsingBlock:^(ZZTabModel * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            ZZTabModel *tabModel = [self array:tabList index:idx];
            if (![obj.tabWidth isEqualToString:tabModel.tabWidth] ||
                ![obj.tabName isEqualToString:tabModel.tabName] ||
                ![obj.tabIndex isEqualToString:tabModel.tabIndex]) {
                isEqual = NO;
                *stop = YES;
            }
        }];
    }
    return isEqual;
}

- (BOOL)isEqualToVCList:(NSArray<ZZVCModel *>*)vcList
{
    __block BOOL isEqual = YES;
    if (self.vcList.count != vcList.count) {
        isEqual = NO;
    } else {
        [self.vcList enumerateObjectsUsingBlock:^(ZZVCModel * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            ZZVCModel *vcModel = [self array:vcList index:idx];
            if (![obj.tabWidth isEqualToString:vcModel.tabWidth] ||
                ![obj.tabName isEqualToString:vcModel.tabName] ||
                ![obj.tabIndex isEqualToString:vcModel.tabIndex]) {
                isEqual = NO;
                *stop = YES;
            }
        }];
    }
    return isEqual;
}

- (BOOL)isEqualToCellList:(NSArray<ZZCellModel *>*)cellList
{
    __block BOOL isEqual = YES;
    if (self.cellList.count != cellList.count) {
        isEqual = NO;
    } else {
        [self.cellList enumerateObjectsUsingBlock:^(ZZCellModel * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            ZZCellModel *cellModel = [self array:cellList index:idx];
            if (![obj.bgColor isEqualToString:cellModel.bgColor] ||
                ![obj.h isEqualToString:cellModel.h]) {
                isEqual = NO;
                *stop = YES;
            }
        }];
    }
    return isEqual;
}

- (id)array:(NSArray *)array index:(NSUInteger)index
{
    if (array && index >= 0 && array.count > index) {
        return array[index];
    } else {
        return nil;
    }
}

@end
