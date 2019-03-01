//
//  ZZCollectionView.m
//  ZZLayoutDemo
//
//  Created by Jungle on 2019/3/1.
//  Copyright (c) 2019. All rights reserved.
//

#import "ZZCollectionView.h"
#import "ZZCellModel.h"

@interface ZZCollectionView ()

@property (nonatomic, strong) UIImageView *imageView;

@end

@implementation ZZCollectionView

- (instancetype)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame]) {
        [self addSubview:self.imageView];
    }
    return self;
}

- (void)bindDataWithViewModel:(ZZCellModel *)viewData
{
    if ([viewData.h isEqualToString:@"1"]) {
        self.imageView.image = [UIImage imageNamed:@"collection1.png"];
    } else {
        self.imageView.image = [UIImage imageNamed:@"collection2.png"];
    }
}

- (UIImageView *)imageView
{
    if (!_imageView) {
        _imageView = [[UIImageView alloc] initWithFrame:self.bounds];
    }
    return _imageView;
}

@end
