//
//  ZZSectionProtocol.h
//  ZZLayoutDemo
//
//  Created by Jungle on 2019/3/1.
//  Copyright (c) 2019. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import "ZZUtils.h"

@class ZZSectionModel;
@class ZZBaseModel;
NS_ASSUME_NONNULL_BEGIN

static NSDictionary *ZZCellClassDict()
{
    return @{
             kZZCellReuseIDCollection   :@"ZZCollectionProtocol",
             kZZCellReuseIDAd           :@"ZZAdProtocol",
             kZZCellReuseIDCategory     :@"ZZCategoryProtocol",
             kZZCellReuseIDScroll       :@"ZZScrollProtocol",
             };
}

@protocol ZZSectionProtocol <NSObject>

@optional

- (NSString *)subViewName;
- (NSString *)cellReuseIdentifier:(ZZSectionModel *)sectionModel indexPath:(NSIndexPath *)indexPath;
- (CGFloat)cellHeight:(ZZSectionModel *)sectionModel indexPath:(NSIndexPath *)indexPath;
- (NSUInteger)rowNumInSection:(ZZSectionModel *)sectionModel;
- (ZZBaseModel *)getRowData:(ZZSectionModel *)sectionModel indexPath:(NSIndexPath *)indexPath;

@end

NS_ASSUME_NONNULL_END
