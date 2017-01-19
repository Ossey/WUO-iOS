//
//  XYTrendItem.h
//  WUO
//
//  Created by mofeini on 17/1/3.
//  Copyright © 2017年 com.test.demo. All rights reserved.
//  用户的每一条 趋势 模型

#import <Foundation/Foundation.h>
#import "XYUserImgItem.h"

@class XYHTTPResponseInfo;
@interface XYTrendItem : NSObject

/** 文本内容 */
@property (nonatomic, copy) NSString *content;
/** 标题 */
@property (nonatomic, copy) NSString *title;
/** 创建日期 */
@property (nonatomic, copy) NSString *createTime;
@property (nonatomic, copy) NSString *head;
@property (nonatomic, copy) NSString *headImg;
/** 发布的图片数量 */
@property (nonatomic, assign) NSInteger imgCount;
/** 发布的图片数组 */
@property (nonatomic, strong) NSArray *imgList;
/** 是否被当前登录的用户投资 */
@property (nonatomic, assign) NSInteger isInvest;
/** 是否被当前登录用户赞 */
@property (nonatomic, assign) BOOL isPraise;
/** 兴趣/职业 */
@property (nonatomic, copy) NSString *job;
/** 用户位置 */
@property (nonatomic, copy) NSString *location;
/** 用户昵称 */
@property (nonatomic, copy) NSString *name;
/** 点赞数量 */
@property (nonatomic, assign) NSInteger praiseCount;
@property (nonatomic, copy) NSString *radioContent;
@property (nonatomic, assign) NSInteger radioTime;
/** 评论次数 */
@property (nonatomic, assign) NSInteger commentCount;
/** 阅读的数量 */
@property (nonatomic, assign) NSInteger readCount;
/** 赏的数量 */
@property (nonatomic, assign) NSInteger rewardCount;
/** 分享的数量 */
@property (nonatomic, assign) NSInteger shareCount;
@property (nonatomic, assign) NSInteger tid;
/** 话题ID */
@property (nonatomic, assign) NSInteger topicId;
/** 话题名称 */
@property (nonatomic, copy) NSString *topicName;
@property (nonatomic, assign) NSInteger type;
@property (nonatomic, assign) NSInteger uid;
@property (nonatomic, copy) NSString *videoImg;
@property (nonatomic, copy) NSString *videoUrl;

@property (nonatomic, assign) BOOL isCollect;
@property (nonatomic, assign) BOOL isFollow;
@property (nonatomic, assign) BOOL isOpenActivity;
@property (nonatomic, assign) BOOL isRecommend;
@property (nonatomic, assign) CGFloat lat;
@property (nonatomic, assign) CGFloat lot;
/** 报道数量 */
@property (nonatomic, assign) NSInteger reportCount;
@property (nonatomic, assign) CGFloat rewardGoldCoin;
@property (nonatomic, assign) CGFloat rewardMoney;
@property (nonatomic, assign) NSInteger state;
@property (nonatomic, copy) NSString *url;


// 扩展属性
@property (nonatomic, strong) NSURL *headerImageURL;
@property (nonatomic, strong)XYHTTPResponseInfo *info;
@property (nonatomic, strong) NSArray<NSString *> *imageUrls;
/** 用户发布动态的视频url，当有视频时没有图片，反之亦然 */
@property (nonatomic, strong) NSURL *videoFullURL;
/** 视频的封面图片 */
@property (nonatomic, strong) NSURL *videoImgFullURL;
/** 排名，此属性是为话题详情页榜单数据扩展的属性，前10个模型时，cell左上角显示 NO.1样式，其他不显示 */
@property (nonatomic, copy) NSString *ranking;

- (instancetype)initWithDict:(NSDictionary *)dict info:(XYHTTPResponseInfo *)info;
+ (instancetype)trendItemWithDict:(NSDictionary *)dict info:(XYHTTPResponseInfo *)info;

@end

@interface XYTrendImgItem : XYUserImgItem

@property (nonatomic, copy) NSString *createTime;
@property (nonatomic, assign) NSInteger tid;
@property (nonatomic, assign) NSInteger tiid;
@property (nonatomic, assign) NSInteger uid;


@end
