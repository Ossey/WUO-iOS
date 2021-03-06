//
//  XYActivityTopicItem.h
//  WUO
//
//  Created by mofeini on 17/1/9.
//  Copyright © 2017年 com.test.demo. All rights reserved.
//  find 页面 活动话题 模型

#import <Foundation/Foundation.h>
#import "XYTrendViewModel.h"

#define SIZE_MARGIN 10
#define SIZE_CORNERWH kSIZE_HEADERWH+5
#define SIZE_LOGOH 200

@interface XYActivityTopicItem : NSObject
/** 活动创建时间 需要进行处理，当距离今日小于20时，显示比如【20天前】，1年内显示比如【11月30日】，跨年显示【2016年1月2日】 */
@property (nonatomic, copy) NSString *createTime;
/** 活动介绍，用于展示 活动详情页头部的内容文本 */
@property (nonatomic, copy) NSString *introduce;
/** 活动logo图片路径，需处理：某些需要拼接为全路径 */
@property (nonatomic, copy) NSString *logo;
/** 活动标题 ,需要处理：在字符串前后加上#显示  */
@property (nonatomic, copy) NSString *title;
/** 活动的ID，当要访问活动话题时，需要传入对应的活动话题ID */
@property (nonatomic, assign) NSInteger topicId;
/** 参与活动的人数 */
@property (nonatomic, assign) NSInteger joinCount;
@property (nonatomic, assign) NSInteger type;
@property (nonatomic, strong) XYHTTPResponseInfo *info;

/** 分配状态 */
@property (nonatomic, assign) NSInteger distributionState;
@property (nonatomic, copy) NSString *endTime;
/** 头像地址，需处理 */
@property (nonatomic, copy) NSString *head;
/** 是否推荐 */
@property (nonatomic, assign) BOOL isRecommend;
@property (nonatomic, assign) BOOL isTop;
@property (nonatomic, copy) NSString *job;
@property (nonatomic, copy) NSString *name;
/** 活动开始的时间 */
@property (nonatomic, copy) NSString *startTime;
/** 话题数组 */
@property (nonatomic, assign) NSInteger totalAmount;
@property (nonatomic, assign) NSInteger uid;
@property (nonatomic, copy) NSString *videoImg;
@property (nonatomic, strong) NSMutableArray<XYTrendViewModel *> *trendList;

/************ 扩展属性 *************/
/** 用于处理上面的logo属性 */
@property (nonatomic, strong) NSURL *logoFullURL;
/** 用于处理上面的title属性 */
@property (nonatomic, copy) NSString *Title;
/** 处理开始活动时间 */
@property (nonatomic, copy) NSString *statTimeFormat;
/** 对加入人数的处理 */
@property (nonatomic, copy) NSString *joinCounStr;
/** 对头像的URL的处理 */
@property (nonatomic, strong) NSURL *headImgFullURL;

/** 活动详情界面，头部的视图bounds */
@property (nonatomic, assign) CGRect topicDetailHeaderBounds;
/** 活动详情界面，头部视图的高度 */
@property (nonatomic, assign) CGFloat topicDetailHeaderHeight;
/** 活动详情界面，头部视图中 头像的frame */
@property (nonatomic, assign) CGRect topicDetailAvatarFrame;
/** 活动详情界面，头部视图中 昵称的frame */
@property (nonatomic, assign) CGRect topicDetailNameFrame;
/** 活动详情界面，头部视图中 发布时间的frame */
@property (nonatomic, assign) CGRect topicDetailStartTimeFrame;
/** 活动详情界面，头部视图中 结束时间的frame */
@property (nonatomic, assign) CGRect topicDetailEndTimeFrame;
/** 活动详情界面，头部视图中 参加人数的frame */
@property (nonatomic, assign) CGRect topicDetailJoinCountFrame;
/** 活动详情界面，头部视图中 Logo的frame */
@property (nonatomic, assign) CGRect topicDetailLogoFrame;
/** 活动详情界面，头部视图中 标题的frame */
@property (nonatomic, assign) CGRect topicDetailTitleFrame;
/** 活动详情界面，头部视图中 内容文字的frame */
@property (nonatomic, assign) CGRect topicDetailIntroduceFrame;
/** 活动详情界面，头部视图中 参加话题的frame */
@property (nonatomic, assign) CGRect topicDetailJoinTopicFrame;



- (instancetype)initWithDict:(NSDictionary *)dict info:(XYHTTPResponseInfo *)info;
+ (instancetype)activitytrendItemWithDict:(NSDictionary *)dict info:(XYHTTPResponseInfo *)info;

@end
