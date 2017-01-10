//
//  XYActivityTopicItem.m
//  WUO
//
//  Created by mofeini on 17/1/9.
//  Copyright © 2017年 com.test.demo. All rights reserved.
//

#import "XYActivityTopicItem.h"


@implementation XYActivityTopicItem

- (instancetype)initWithDict:(NSDictionary *)dict info:(XYTopicInfo *)info {
    if (self = [super init]) {
        [self setValuesForKeysWithDictionary:dict];
        self.info = info;
        // 当dict[@"datas"]字段为数组类型时，说明datas字段是帖子，如果是字典类型时，datas字段为帖子详情，对应内部的trendList才为帖子数组
        if (dict[@"datas"] && [dict[@"datas"] count]) {
            
            if ([dict[@"datas"] isKindOfClass:[NSArray class]]) {
                for (id obj in dict[@"datas"]) {
                    if ([obj isKindOfClass:[NSDictionary class]]) {
                        
                        [self.trendList addObject:[XYTopicItem topicItemWithDict:obj info:info]];
                    }
                }
            } else if (dict[@"datas"][@"trendList"] && [dict[@"datas"][@"trendList"] isKindOfClass:[NSArray class]]) {
                for (id obj in dict[@"datas"][@"trendList"]) {
                    if ([obj isKindOfClass:[NSDictionary class]]) {
                        [self.trendList addObject:[XYTopicItem topicItemWithDict:dict info:info]];
                    }
                }
            }
            
        }
    }
    return self;
}

+ (instancetype)activityTopicItemWithDict:(NSDictionary *)dict info:(XYTopicInfo *)info {
    
    return [[self alloc] initWithDict:dict info:info];
}

- (void)setValue:(id)value forUndefinedKey:(NSString *)key {}

- (NSMutableArray<XYTopicItem *> *)trendList {
    if (_trendList == nil) {
        _trendList = [NSMutableArray array];
    }
    return _trendList;
}

- (NSURL *)logoFullURL {
    
    NSString *logoFullStr;
    
    /**
     注意：服务端返回logo路径，有些是完整的路径，有些需要拼接，这里做出来
     */
    
    /// 将url进行 UTF8转码 避免服务端返回的有汉字 引发乱码
    NSString *logoStr = [self.logo stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    if ([logoStr containsString:@"http:"]) {
        logoFullStr = logoStr;
    } else {
        logoFullStr = [self.info.basePath stringByAppendingString:logoStr];
    }
    
    return [NSURL URLWithString:logoFullStr];
}

- (NSString *)Title {
    
    return [NSString stringWithFormat:@"#%@#", self.title];
}

//- (CGFloat)topicDetailHeaderHeight {
//    
//    if (_topicDetailHeaderHeight != 0) {
//        // 当已计算好时，就不再计算
//        return _topicDetailHeaderHeight;
//    }
//    
//    CGFloat x = SIZE_MARGIN;
//    CGFloat y = SIZE_MARGIN;
//    
//    
//    // 头像
//    self.topicDetailAvatarFrame = CGRectMake(x, y, SIZE_HEADERWH, SIZE_HEADERWH);
//    
//    // 昵称
//    self.topicDetailNameFrame = CGRectMake(SIZE_MARGIN+SIZE_HEADERWH+SIZE_MARGIN, y, <#CGFloat width#>, <#CGFloat height#>)
//    
//   
//}
@end
