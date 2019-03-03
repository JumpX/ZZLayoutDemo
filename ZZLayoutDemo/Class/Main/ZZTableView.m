//
//  ZZTableView.m
//  ZZLayoutDemo
//
//  Created by Jungle on 2019/2/28.
//  Copyright (c) 2019. All rights reserved.
//

#import "ZZTableView.h"

@implementation ZZTableView

- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldRecognizeSimultaneouslyWithGestureRecognizer:(nonnull UIGestureRecognizer *)otherGestureRecognizer
{
    return YES;
}

@end
