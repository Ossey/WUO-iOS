//
//  XYActivityTopicItem.m
//  WUO
//
//  Created by mofeini on 17/1/9.
//  Copyright © 2017年 com.test.demo. All rights reserved.
//

#import "XYActivityTopicItem.h"
#import "NSString+Date.h"


@implementation XYActivityTopicItem

- (instancetype)initWithDict:(NSDictionary *)dict info:(XYHTTPResponseInfo *)info {
    if (self = [super init]) {
        [self setValuesForKeysWithDictionary:dict];
        self.info = info;
        _trendList = [NSMutableArray array];
        if (dict[@"trendList"] && [dict[@"trendList"] isKindOfClass:[NSArray class]]) {
            // 里面都是帖子
            for (id obj in dict[@"trendList"]) {
                if ([obj isKindOfClass:[NSDictionary class]]) {
                    XYTrendItem *item = [XYTrendItem trendItemWithDict:obj info:info];
                    XYTrendViewModel *viewModel = [XYTrendViewModel trendViewModelWithTrend:item info:info];
                    [_trendList addObject:viewModel];
                }
            }
        }
        
    }
    return self;
}

+ (instancetype)activitytrendItemWithDict:(NSDictionary *)dict info:(XYHTTPResponseInfo *)info {
    
    return [[self alloc] initWithDict:dict info:info];
}

- (void)setValue:(id)value forUndefinedKey:(NSString *)key {}

//- (NSMutableArray<XYTrendViewModel *> *)trendList {
//    if (_trendList == nil) {
//        _trendList = [NSMutableArray array];
//    }
//    return _trendList;
//}

- (NSURL *)logoFullURL {
    
    NSString *logoFullStr;
    if (self.logo.length) {
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
    return nil;
}

- (NSString *)Title {
    
    return [NSString stringWithFormat:@"#%@#", self.title];
}

- (NSString *)statTimeFormat {

    return [NSString compareCurrentTime:self.createTime];
}

- (NSString *)joinCounStr {
    
    return [NSString stringWithFormat:@"%ld人参加", self.joinCount];
}


- (CGFloat)topicDetailHeaderHeight {
    
    if (_topicDetailHeaderHeight != 0) {
        // 当已计算好时，就不再计算
        return _topicDetailHeaderHeight;
    }
    
    CGFloat x = SIZE_MARGIN;
    CGFloat y = SIZE_MARGIN;
    
    // 头像
    self.topicDetailAvatarFrame = CGRectMake(x, y, kSIZE_HEADERWH, kSIZE_HEADERWH);
    
    {
        // 昵称
        CGSize nameSize = [self.name boundingRectWithSize:CGSizeMake(MAXFLOAT, MAXFLOAT) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName: kFontWithSize(kSIZE_FONT_NAME)} context:nil].size;
        self.topicDetailNameFrame = CGRectMake(SIZE_MARGIN+kSIZE_HEADERWH+SIZE_MARGIN, kSIZE_GAP_TOP, nameSize.width, nameSize.height);
        // 发布时间
        CGSize startTimeName = [self.statTimeFormat boundingRectWithSize:CGSizeMake(MAXFLOAT, MAXFLOAT) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName: kFontWithSize(kSIZE_FONT_SUBTITLE)} context:nil].size;
        self.topicDetailStartTimeFrame = CGRectMake(self.topicDetailNameFrame.origin.x, CGRectGetMaxY(self.topicDetailNameFrame) + kSIZE_GAP_SMALL, startTimeName.width, startTimeName.height);
        
        // 加入人数
        CGSize joinCounStrSize = [self.joinCounStr boundingRectWithSize:CGSizeMake(MAXFLOAT, MAXFLOAT) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName: kFontWithSize(kSIZE_FONT_JOINCOUNT)} context:nil].size;
        CGFloat joinCounStrX = kScreenW - kSIZE_GAP_SMALL*2 - joinCounStrSize.width - SIZE_MARGIN;
        CGFloat joinCounStrY = (kSIZE_HEADERWH - joinCounStrSize.height) * 0.5 + kSIZE_GAP_MARGIN;
        self.topicDetailJoinCountFrame = CGRectMake(joinCounStrX, joinCounStrY, joinCounStrSize.width, joinCounStrSize.height);
    }
    
    y += kSIZE_HEADERWH + SIZE_MARGIN;
    // logo
    CGFloat logoW = 0.0;
    CGFloat logoH = 0.0;
    if (self.logo.length) {
        logoW = kScreenW;
        logoH = SIZE_LOGOH;
    } else {
        logoW = 0;
        logoH = 0;
    }
    self.topicDetailLogoFrame = CGRectMake(0, y, logoW, logoH);
    
    // title
    y += logoH + SIZE_MARGIN;
    
    CGSize titleStrSize = [self.Title boundingRectWithSize:CGSizeMake(MAXFLOAT, MAXFLOAT) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName: kFontWithSize(kSIZE_FONT_TITLE)} context:nil].size;
    // 居中显示
    CGFloat titleStrX = (kScreenW - titleStrSize.width) * 0.5;
    self.topicDetailTitleFrame = CGRectMake(titleStrX, y, titleStrSize.width, titleStrSize.height);
    
    // 正文
    if (self.introduce.length) {
        y += titleStrSize.height + kSIZE_GAP_MARGIN;
        CGSize introduceSize = [self.introduce boundingRectWithSize:CGSizeMake(kScreenW-2*SIZE_MARGIN, MAXFLOAT) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName: kFontWithSize(kSIZE_FONT_CONTENT)} context:nil].size;
        //        CGSize introduceSize = [self.introduce sizeWithFont:kFontWithSize(kSIZE_FONT_CONTENT) constrainedToSize:CGSizeMake((kScreenW-2*x), MAXFLOAT) lineBreakMode:NSLineBreakByWordWrapping];
        self.topicDetailIntroduceFrame = CGRectMake(x, y, introduceSize.width, introduceSize.height);
    } else {
        self.topicDetailIntroduceFrame = CGRectZero;
    }
    
    // 参加话题
    y += self.topicDetailIntroduceFrame.size.height + 30;
    CGFloat joinTopicW = 80;
    CGFloat joinTopicH = 35;
    CGFloat joinTopicX = kScreenW - joinTopicW - kSIZE_GAP_MARGIN;
    self.topicDetailJoinTopicFrame = CGRectMake(joinTopicX, y, joinTopicW, joinTopicH);
    
    // 距离底部的距离
    y += joinTopicH + 20;
    
    return y;
}

- (NSURL *)headImgFullURL {
    NSString *fullPath = nil;
    if (self.head.length) {
        if ([self.head containsString:@"http://"]) {
            fullPath = self.head;
        } else {
            fullPath = [self.info.basePath stringByAppendingString:self.head];
        }
        return [NSURL URLWithString:fullPath];
    }
    return nil;
}

- (CGRect)topicDetailHeaderBounds {
    
    return CGRectMake(0, 0, kScreenW, self.topicDetailHeaderHeight);
}

//- (void)setTrendList:(NSMutableArray<XYTrendViewModel *> *)trendList {
//    _trendList = trendList;
//    
//    // 发布数据改变的通知，外界更新数据
//    [[NSNotificationCenter defaultCenter] postNotificationName:XYTrendListChangeNote object:trendList];
//}

@end
