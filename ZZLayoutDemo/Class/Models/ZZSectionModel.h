//
//  ZZSectionModel.h
//  ZZHomePageDemo
//
//  Created by Jungle on 2019/2/27.
//  Copyright (c) 2019. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ZZCellModel.h"
#import "ZZBaseModel.h"
#import "ZZSectionProtocol.h"
#import "ZZTabModel.h"
#import "ZZVCModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface ZZSectionModel : ZZBaseModel

@property (nonatomic, copy) NSString *templateID;
@property (nonatomic, copy) NSString *NoNum;
@property (nonatomic, strong) NSArray <ZZTabModel *>*tabList;
@property (nonatomic, strong) NSArray <ZZVCModel *>*vcList;
@property (nonatomic, strong) NSArray <ZZCellModel *>*cellArr;

@property (nonatomic, assign) NSInteger tabIndex;
@property (nonatomic, strong) NSObject<ZZSectionProtocol>*sectionProtocol;

@end

NS_ASSUME_NONNULL_END
