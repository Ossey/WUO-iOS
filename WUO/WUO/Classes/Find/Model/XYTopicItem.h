//
//  XYTopicItem.h
//  WUO
//
//  Created by mofeini on 17/1/9.
//  Copyright © 2017年 com.test.demo. All rights reserved.
//  find 页面 活动主题 模型

#import <Foundation/Foundation.h>
#import "XYDynamicInfo.h"

@interface XYTopicItem : NSObject
/** 活动创建时间 */
@property (nonatomic, copy) NSString *createTime;
/** 活动结束 */
@property (nonatomic, copy) NSString *introduce;
/** 活动logo图片路径，需处理：某些需要拼接为全路径 */
@property (nonatomic, copy) NSString *logo;
/** 活动标题 ,需要处理：在字符串前后加上#显示  */
@property (nonatomic, copy) NSString *title;
/** 活动ID */
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

- (instancetype)initWithDict:(NSDictionary *)dict infoItem:(XYDynamicInfo *)infoItem;
+ (instancetype)topicItemWithDict:(NSDictionary *)dict infoItem:(XYDynamicInfo *)infoItem;

@end
