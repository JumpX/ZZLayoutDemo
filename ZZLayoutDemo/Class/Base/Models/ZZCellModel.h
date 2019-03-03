//
//  ZZCellModel.h
//  ZZLayoutDemo
//
//  Created by Jungle on 2019/2/27.
//  Copyright (c) 2019. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ZZBaseModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface ZZCellModel : ZZBaseModel

@property (nonatomic, copy)   NSString  *bgColor;
@property (nonatomic, copy)   NSString  *h;
@property (nonatomic, assign) NSInteger tabIndex;

@end

NS_ASSUME_NONNULL_END
