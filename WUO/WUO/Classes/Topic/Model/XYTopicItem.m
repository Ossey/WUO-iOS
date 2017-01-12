//
//  XYTopicItem.m
//  WUO
//
//  Created by mofeini on 17/1/3.
//  Copyright © 2017年 com.test.demo. All rights reserved.
//

#import "XYTopicItem.h"
#import "XYHTTPResponseInfo.h"

@implementation XYTopicItem

- (instancetype)initWithDict:(NSDictionary *)dict info:(XYHTTPResponseInfo *)info {
    if (self = [super init]) {

        [self setValuesForKeysWithDictionary:dict];
        self.info = info;
        if (dict[@"imgList"]) {
            NSMutableArray *temArrM = [NSMutableArray arrayWithCapacity:1];
            for (id obj in dict[@"imgList"]) {
                if ([obj isKindOfClass:[NSDictionary class]]) {
                    XYDynamicImgItem *imgItm = [XYDynamicImgItem dynamicImgItemWithDict:obj];
                    imgItm.info = info;
                    [temArrM addObject:imgItm];
                }
            }
            self.imgList = [temArrM mutableCopy];
        }
    }
    
    return self;
}

+ (instancetype)topicItemWithDict:(NSDictionary *)dict info:(XYHTTPResponseInfo *)info {
    
    return [[self alloc] initWithDict:dict info:info];
}

- (void)setValue:(id)value forUndefinedKey:(NSString *)key {}

- (NSURL *)headerImageURL {
    NSString *fullPath = nil;
    if ([self.head containsString:@"http://"]) {
        fullPath = self.head;
    } else {
        fullPath = [self.info.basePath stringByAppendingString:self.head];
    }
    return [NSURL URLWithString:fullPath];
}

- (NSArray<NSString *> *)imageUrls {
    
    NSMutableArray<NSString *> *tempArrM = [NSMutableArray arrayWithCapacity:1];
    for (XYDynamicImgItem *imgItem in self.imgList) {
        [tempArrM addObject:imgItem.imgFullURL.absoluteString];
    }
    return [tempArrM mutableCopy];
}

- (NSURL *)videoFullURL {
    if (self.videoUrl.length) {
        /// 将网址进行 UTF8 转码，避免有些汉字会变乱码
        NSString *urlStr = [self.videoUrl stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
        return [NSURL URLWithString:[self.info.basePath stringByAppendingString:urlStr]];
    }
    return nil;
}

- (NSURL *)videoImgFullURL {
    if (self.videoImg.length) {
        /// 将网址进行 UTF8 转码，避免有些汉字会变乱码
        NSString *urlStr = [self.videoImg stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
        return [NSURL URLWithString:[self.info.basePath stringByAppendingString:urlStr]];
    }
    return nil;
}

@end

@implementation XYDynamicImgItem

- (instancetype)initWithDict:(NSDictionary *)dict {
    if (self = [super init]) {
        [self setValuesForKeysWithDictionary:dict];
    }
    return self;
}
+ (instancetype)dynamicImgItemWithDict:(NSDictionary *)dict {
    
    return [[self alloc] initWithDict:dict];
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
