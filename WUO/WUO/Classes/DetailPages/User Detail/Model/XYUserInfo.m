//
//  XYUserInfo.m
//  WUO
//
//  Created by mofeini on 17/1/12.
//  Copyright © 2017年 com.test.demo. All rights reserved.
//

#import "XYUserInfo.h"

@implementation XYUserInfo

+ (instancetype)userInfoWithDict:(NSDictionary *)dict responseInfo:(XYHTTPResponseInfo*)info {
    return [[self alloc] initWithDict:dict responseInfo:info];
}
- (instancetype)initWithDict:(NSDictionary *)dict responseInfo:(XYHTTPResponseInfo*)info {
    if (self = [super init]) {
        [self setValuesForKeysWithDictionary:dict];
        self.responseInfo = info;
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

- (NSString *)headFullPath {
    
    if (self.head.length) {
        if (![self.head containsString:@"http://"]) {
            return [self.responseInfo.basePath stringByAppendingString:self.head];
        }
    }
    
    return nil;
}

- (NSURL *)headFullURL {
    NSURL *url = nil;
    if (self.head.length) {
        NSString *urlStr = [self.head stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
        if (![urlStr containsString:@"http://"]) {
            url = [NSURL URLWithString:[self.responseInfo.basePath stringByAppendingString:urlStr]];
            NSLog(@"%@", url);
        } else {
            url = [NSURL URLWithString:urlStr];
        }
    }
    return url;
}

- (NSString *)descriptionText {
    if (self.Description == nil || [self.Description isEqualToString:@""]) {
        return @"暂无个性签名";
    }
    return self.Description;
}

- (NSString *)genderText {
    NSString *genderText;
    switch (self.gender) {
        case 0:
            genderText = @"女";
            break;
        case 1:
            genderText = @"男";
            break;
        case 2:
            genderText = @"保密";
            break;
        default:
            break;
    }
    return genderText;
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
