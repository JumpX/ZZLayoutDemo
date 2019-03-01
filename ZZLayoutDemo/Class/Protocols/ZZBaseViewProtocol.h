//
//  ZZBaseViewProtocol.h
//  ZZLayoutDemo
//
//  Created by Jungle on 2019/3/1.
//  Copyright (c) 2019. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@class ZZBaseModel;
@protocol ZZBaseViewProtocol <NSObject>

@required
- (void)bindDataWithViewModel:(NSObject *)viewData;

@optional
- (void)viewWillDisplay;
- (void)viewDidEndDisplaying;

@end

NS_ASSUME_NONNULL_END
