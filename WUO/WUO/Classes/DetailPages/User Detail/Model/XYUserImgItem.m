//
//  XYUserImgItem.m
//  WUO
//
//  Created by mofeini on 17/1/12.
//  Copyright © 2017年 com.test.demo. All rights reserved.
//

#import "XYUserImgItem.h"
#import "XYHTTPResponseInfo.h"

@implementation XYUserImgItem

- (instancetype)initWithDict:(NSDictionary *)dict responseInfo:(XYHTTPResponseInfo *)info {
    if (self = [super init]) {
        [self setValuesForKeysWithDictionary:dict];
        self.info = info;
    }
    return self;
}
+ (instancetype)imgItemWithDict:(NSDictionary *)dict responseInfo:(XYHTTPResponseInfo *)info {
    
    return [[self alloc] initWithDict:dict responseInfo:info];
}

- (void)setValue:(id)value forUndefinedKey:(NSString *)key {}


// 处理数据
- (NSURL *)imgFullURL {
    
    if (self.imgUrl.length) {
        /// 将网址进行 UTF8 转码，避免有些汉字会变乱码
        NSString *urlStr = [self.imgUrl stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
        return [NSURL URLWithString:[self.info.basePath stringByAppendingString:urlStr]];
    }
    
    return nil;
}

- (CGSize)imgSize {
    
    NSString *subStr = [self.imgUrl componentsSeparatedByString:@"jpg?"].lastObject;
    NSArray *sizeStrs = [subStr componentsSeparatedByString:@"&"];
    CGFloat width = [[sizeStrs[0] substringFromIndex:2] doubleValue];
    CGFloat height = [[sizeStrs[1] substringFromIndex:2] doubleValue];
    
    return CGSizeMake(width, height);
}

@end
