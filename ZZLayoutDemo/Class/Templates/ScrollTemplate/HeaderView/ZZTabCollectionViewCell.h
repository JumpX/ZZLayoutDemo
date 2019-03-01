//
//  ZZTabCollectionViewCell.h
//  ZZLayoutDemo
//
//  Created by Jungle on 2019/3/1.
//  Copyright (c) 2019. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ZZTabModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface ZZTabCollectionViewCell : UICollectionViewCell

- (void)bindDataWithViewModel:(ZZTabModel *)viewData;

@property (nonatomic, assign) BOOL           isSelected;

@end

NS_ASSUME_NONNULL_END
