//
//  XYTopicItem.h
//  WUO
//
//  Created by mofeini on 17/1/9.
//  Copyright © 2017年 com.test.demo. All rights reserved.
//  find 页面 活动话题 模型

#import <Foundation/Foundation.h>
#import "XYDynamicInfo.h"



@interface XYActivityTopicItem : NSObject
/** 活动创建时间 */
@property (nonatomic, copy) NSString *createTime;
/** 活动结束 */
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
@property (nonatomic, strong) XYDynamicInfo *infoItem;

/************ 扩展属性 *************/
/** 用于处理上面的logo属性 */
@property (nonatomic, strong) NSURL *logoFullURL;
/** 用于处理上面的title属性 */
@property (nonatomic, copy) NSString *Title;

/** 活动详情界面，头部的视图bounds */
@property (nonatomic, assign) CGRect topicDetailHeaderBounds;
/** 活动详情界面，头部视图的高度 */
@property (nonatomic, assign) CGFloat topicDetailHeaderHeight;
/** 活动详情界面，头部视图中 头像的frame */
@property (nonatomic, assign) CGRect topicDetailAvatarFrame;
/** 活动详情界面，头部视图中 昵称的frame */
@property (nonatomic, assign) CGRect topicDetailNameFrame;
/** 活动详情界面，头部视图中 发布时间的frame */
@property (nonatomic, assign) CGRect topicDetailTimeFrame;
/** 活动详情界面，头部视图中 参加人数的frame */
@property (nonatomic, assign) CGRect topicDetailJoinCountFrame;
/** 活动详情界面，头部视图中 Logo的frame */
@property (nonatomic, assign) CGRect topicDetailLogoFrame;
/** 活动详情界面，头部视图中 标题的frame */
@property (nonatomic, assign) CGRect topicDetailTitleFrame;
/** 活动详情界面，头部视图中 内容文字的frame */
@property (nonatomic, assign) CGRect topicDetailContentFrame;
/** 活动详情界面，头部视图中 参加话题的frame */
@property (nonatomic, assign) CGRect topicDetailJoinTopicFrame;



- (instancetype)initWithDict:(NSDictionary *)dict infoItem:(XYDynamicInfo *)infoItem;
+ (instancetype)activityTopicItemWithDict:(NSDictionary *)dict infoItem:(XYDynamicInfo *)infoItem;

@end
