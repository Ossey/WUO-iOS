//
//  XYLoginInfo.m
//  WUO
//
//  Created by mofeini on 17/1/2.
//  Copyright © 2017年 com.test.demo. All rights reserved.
//

#import "XYLoginInfo.h"


@implementation XYLoginInfo

- (instancetype)initWithDict:(NSDictionary *)dict {
    
    if (self = [super init]) {
        
        [self setValuesForKeysWithDictionary:dict];
        if (dict[@"imUser"] && [dict[@"imUser"] isKindOfClass:[NSDictionary class]]) {
            self.imUser = [[XYImUser alloc] initWithDict:dict[@"imUser"]];
        }
        if ([dict[@"code"] integerValue] == 0) {
            
            self.userInfo = [XYUserInfo userInfoWithDict:dict[@"userInfo"] responseInfo:nil];
        }
    }
    return self;
}
+ (instancetype)loginInfoItemWithDict:(NSDictionary *)dict {
    
    return [[self alloc] initWithDict:dict];
}

- (void)setValue:(id)value forUndefinedKey:(NSString *)key {}

@end

@implementation XYImUser

- (instancetype)initWithDict:(NSDictionary *)dict {
    if (self = [super init]) {
        [self setValuesForKeysWithDictionary:dict];
    }
    return self;
}


@end
