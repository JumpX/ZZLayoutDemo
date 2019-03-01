//
//  ZZTabCollectionViewCell.m
//  ZZLayoutDemo
//
//  Created by Jungle on 2019/3/1.
//  Copyright (c) 2019. All rights reserved.
//

#import "ZZTabCollectionViewCell.h"


@interface ZZTabCollectionViewCell ()

@property (nonatomic, strong) UILabel        *label;
@property (nonatomic, weak) ZZTabModel       *tabModel;

@end

@implementation ZZTabCollectionViewCell

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        self.label = ({
            UILabel *label = [[UILabel alloc] initWithFrame:self.bounds];
            label.textColor = [UIColor blackColor];
            label.font = [UIFont systemFontOfSize:15];
            label.textAlignment = NSTextAlignmentCenter;
            [self addSubview:label];
            label;
        });
        self.isSelected = NO;;
    }
    return self;
}

-(void)layoutSubviews
{
    [super layoutSubviews];
    self.label.frame = self.bounds;
}

- (void)bindDataWithViewModel:(ZZTabModel *)viewData
{
    self.tabModel = viewData;
    self.label.text = self.tabModel.tabName;
    if (self.isSelected) {
        self.label.textColor = [UIColor redColor];
    } else {
        self.label.textColor = [UIColor blackColor];
    }
}

- (void)setSelected:(BOOL)selected
{
    _isSelected = selected;
    if (self.isSelected) {
        self.label.textColor = [UIColor redColor];
    } else {
        self.label.textColor = [UIColor blackColor];
    }
}

@end
