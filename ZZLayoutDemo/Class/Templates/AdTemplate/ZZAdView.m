//
//  ZZAdView.m
//  ZZLayoutDemo
//
//  Created by Jungle on 2019/3/1.
//  Copyright (c) 2019. All rights reserved.
//

#import "ZZAdView.h"

@interface ZZAdView ()

@property (nonatomic, strong) UIImageView *imageView;

@end

@implementation ZZAdView

- (instancetype)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame]) {
        [self addSubview:self.imageView];
    }
    return self;
}

- (void)bindDataWithViewModel:(NSObject *)viewData
{
    self.imageView.image = [UIImage imageNamed:@"ad.png"];
}

- (UIImageView *)imageView
{
    if (!_imageView) {
        _imageView = [[UIImageView alloc] initWithFrame:self.bounds];
    }
    return _imageView;
}

@end
