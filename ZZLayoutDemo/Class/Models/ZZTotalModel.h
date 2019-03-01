//
//  ZZTotalModel.h
//  ZZHomePageDemo
//
//  Created by Jungle on 2019/2/27.
//  Copyright (c) 2019. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ZZSectionModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface ZZTotalModel : ZZBaseModel

@property (nonatomic, copy) NSString *bgColor;
@property (nonatomic, strong) NSArray <ZZSectionModel *>*sectionArr;

- (NSUInteger)rowNumInSection:(ZZSectionModel *)sectionModel;
- (CGFloat)cellHeight:(ZZSectionModel *)sectionModel indexPath:(NSIndexPath *)indexPath;
- (NSString *)cellReuseIdentifier:(ZZSectionModel *)sectionModel indexPath:(NSIndexPath *)indexPath;
- (ZZBaseModel *)getRowData:(ZZSectionModel *)sectionModel indexPath:(NSIndexPath *)indexPath;

@end

NS_ASSUME_NONNULL_END
