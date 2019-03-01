//
//  ZZBaseTableViewCell.m
//  ZZLayoutDemo
//
//  Created by Jungle on 2019/3/1.
//  Copyright (c) 2019. All rights reserved.
//

#import "ZZBaseTableViewCell.h"
#import "ZZBaseView.h"
#import "ZZUtils.h"
#import "ZZBaseViewProtocol.h"
#import "UIView+Addtion.h"

@interface ZZBaseTableViewCell ()

@property(nonatomic, strong) ZZBaseView *displayView;

@end

@implementation ZZBaseTableViewCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style
              reuseIdentifier:(NSString *)reuseIdentifier
                   cellHeight:(float)height
                 sectionModel:(ZZSectionModel *)sectionModel
{
    if(self = [super initWithStyle:style reuseIdentifier:reuseIdentifier])
    {
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        [self layoutViews:reuseIdentifier cellHeight:height sectionModel:sectionModel];
    }
    return self;
}

- (void)layoutViews:(NSString *)reuseIdentifier cellHeight:(float)height sectionModel:(ZZSectionModel *)sectionModel
{
    CGRect frame = CGRectMake(0, 0, SCREEN_WIDTH, height);
    if ([sectionModel.sectionProtocol respondsToSelector:@selector(subViewName)])
    {
        NSString *viewName = [sectionModel.sectionProtocol performSelector:@selector(subViewName)];
        if (viewName) {
            Class viewClass = NSClassFromString(viewName);
            if (viewClass && class_getInstanceMethod(viewClass,@selector(initWithFrame:)))
            {
                self.displayView =  [[viewClass alloc] initWithFrame:frame];
            }
        }
    }
    if (self.displayView)
    {
        [self.contentView addSubview:self.displayView];
    }
}

-(void)bindDataWithViewModel:(NSObject*)viewData
{
    if ([self.displayView conformsToProtocol:@protocol(ZZBaseViewProtocol)])
    {
        self.displayView.height = CGRectGetHeight(self.frame);
        [(NSObject<ZZBaseViewProtocol>*)self.displayView bindDataWithViewModel:viewData];
    }
}

-(void)cellWillDisplay
{
    if ([self.displayView conformsToProtocol:@protocol(ZZBaseViewProtocol)])
    {
        if ([self.displayView respondsToSelector:@selector(viewWillDisplay)]) {
            [(id<ZZBaseViewProtocol>)self.displayView viewWillDisplay];
        }
    }
}

-(void)cellEndDisplaying
{
    if ([self.displayView conformsToProtocol:@protocol(ZZBaseViewProtocol)])
    {
        if ([self.displayView respondsToSelector:@selector(viewDidEndDisplaying)]) {
            [(id<ZZBaseViewProtocol>)self.displayView viewDidEndDisplaying];
        }
    }
}

@end
