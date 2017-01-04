//
//  XYLoginInfoItem.m
//  WUO
//
//  Created by mofeini on 17/1/2.
//  Copyright © 2017年 com.test.demo. All rights reserved.
//

#import "XYLoginInfoItem.h"


@implementation XYLoginInfoItem

- (instancetype)initWithDict:(NSDictionary *)dict {
    
    if (self = [super init]) {
        
        [self setValuesForKeysWithDictionary:dict];

        if ([dict[@"code"] integerValue] == 0) {
            
            self.userInfo = [XYUserInfoItem userInfoItemWithDict:dict[@"userInfo"]];
        }
    }
    return self;
}
+ (instancetype)loginInfoItemWithDict:(NSDictionary *)dict {
    
    return [[self alloc] initWithDict:dict];
}

- (void)setValue:(id)value forUndefinedKey:(NSString *)key {}

@end
