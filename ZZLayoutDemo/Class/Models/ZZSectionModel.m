//
//  ZZSectionModel.m
//  ZZHomePageDemo
//
//  Created by Jungle on 2019/2/27.
//  Copyright (c) 2019. All rights reserved.
//

#import "ZZSectionModel.h"

@implementation ZZSectionModel

+ (NSDictionary *)modelContainerPropertyGenericClass {
    return @{@"cellArr" : @"ZZCellModel",
             @"tabList" : @"ZZTabModel",
             @"vcList" : @"ZZVCModel"
             };
}

- (BOOL)modelCustomTransformFromDictionary:(NSDictionary *)dic
{
    [self bindSectionProtocol];
    return YES;
}

- (void)bindSectionProtocol
{
    if (self.templateID)
    {
        NSDictionary* dict  = ZZCellClassDict();
        if(dict[self.templateID])
        {
            Class sectionProtocolClass = NSClassFromString(dict[self.templateID]);
            if (sectionProtocolClass)
            {
                NSObject *sectionProtocol = [sectionProtocolClass new];
                if ([sectionProtocol conformsToProtocol:@protocol(ZZSectionProtocol)]) {
                    self.sectionProtocol = (NSObject<ZZSectionProtocol>*)sectionProtocol;
                }
            }
        }
    }
}

@end
