//
//  XYTrendLabelItem.m
//  WUO
//
//  Created by mofeini on 17/1/6.
//  Copyright © 2017年 com.test.demo. All rights reserved.
//

#import "XYTrendLabelItem.h"

@implementation XYTrendLabelItem

- (instancetype)initWithDict:(NSDictionary *)dict {
    if (self = [super init]) {
        [self setValuesForKeysWithDictionary:dict];
    }
    return self;
}
+ (instancetype)trendLabelItemWithDict:(NSDictionary *)dict {
    return [[self alloc] initWithDict:dict];
}

@end
