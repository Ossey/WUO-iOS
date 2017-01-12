//
//  XYUserInfo.m
//  WUO
//
//  Created by mofeini on 17/1/12.
//  Copyright © 2017年 com.test.demo. All rights reserved.
//

#import "XYUserInfo.h"

@implementation XYUserInfo

+ (instancetype)userInfoWithDict:(NSDictionary *)dict {
    return [[self alloc] initWithDict:dict];
}
- (instancetype)initWithDict:(NSDictionary *)dict {
    if (self = [super init]) {
        [self setValuesForKeysWithDictionary:dict];
        
        if (dict[@"userLabelList"] && [dict[@"userLabelList"] isKindOfClass:[NSArray class]]) {
            NSMutableArray *tempList = [NSMutableArray arrayWithCapacity:0];
            for (id obj in dict[@"userLabelList"]) {
                if ([obj isKindOfClass:[NSDictionary class]]) {
                    [tempList addObject:[XYUserLabelItem userLabelItemWithDict:obj]];
                }
            }
            self.userLabelList = [tempList mutableCopy];
            tempList = nil;
        }
    }
    return self;
}

- (void)setValue:(id)value forUndefinedKey:(NSString *)key {
    if ([key isEqualToString:@"description"]) {
        self.Description = value;
    }
}

@end

@implementation XYUserLabelItem

+ (instancetype)userLabelItemWithDict:(NSDictionary *)dict {
    return [[self alloc] initWithDict:dict];
}
- (instancetype)initWithDict:(NSDictionary *)dict {
    if (self = [super init]) {
        [self setValuesForKeysWithDictionary:dict];
    }
    return self;
}

@end
