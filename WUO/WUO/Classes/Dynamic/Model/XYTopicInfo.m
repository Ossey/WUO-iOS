//
//  XYTopicInfo.m
//  WUO
//
//  Created by mofeini on 17/1/3.
//  Copyright © 2017年 com.test.demo. All rights reserved.
//

#import "XYTopicInfo.h"

@implementation XYTopicInfo


- (instancetype)initWithDict:(NSDictionary *)dict {

    if (self = [super init]) {
      
        self.basePath = dict[@"basePath"];
        self.code = [dict[@"code"] integerValue];
        self.codeMsg = dict[@"codeMsg"];
        self.idstamp = [dict[@"idstamp"] integerValue];
        
    }
    
    return self;
}
+ (instancetype)topicInfoWithDict:(NSDictionary *)dict {
    
    return [[self alloc] initWithDict:dict];
}


- (void)setValue:(id)value forUndefinedKey:(NSString *)key {}
@end
