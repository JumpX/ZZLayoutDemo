//
//  ZZRecommendCell.m
//  ZZLayoutDemo
//
//  Created by Jungle on 2019/3/1.
//  Copyright (c) 2019. All rights reserved.
//

#import "ZZRecommendCell.h"

@interface ZZRecommendCell ()

@property (nonatomic, strong) UIImageView *displayView;

@end

@implementation ZZRecommendCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        [self addSubview:self.displayView];
    }
    return self;
}

- (void)bindDataWithViewModel:(NSObject *)viewData
{
    self.displayView.frame = self.bounds;
    self.displayView.image = [UIImage imageNamed:@"scroll.png"];
}

- (UIImageView *)displayView
{
    if (!_displayView) {
        _displayView = [[UIImageView alloc] initWithFrame:self.bounds];
    }
    return _displayView;
}

@end
