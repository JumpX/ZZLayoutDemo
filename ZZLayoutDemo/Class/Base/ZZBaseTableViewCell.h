//
//  ZZBaseTableViewCell.h
//  ZZLayoutDemo
//
//  Created by Jungle on 2019/3/1.
//  Copyright (c) 2019. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ZZSectionModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface ZZBaseTableViewCell : UITableViewCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style
              reuseIdentifier:(NSString *)reuseIdentifier
                   cellHeight:(float)height
                 sectionModel:(ZZSectionModel *)sectionModel;

- (void)bindDataWithViewModel:(NSObject*)viewData;

- (void)cellWillDisplay;

- (void)cellEndDisplaying;

@end

NS_ASSUME_NONNULL_END
