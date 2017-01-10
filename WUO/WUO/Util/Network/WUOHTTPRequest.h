//
//  WUOHTTPRequest.h
//  WUO
//
//  Created by mofeini on 17/1/2.
//  Copyright © 2017年 com.test.demo. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "XYNetworkRequest.h"

@class XYNetworkRequest, XYLoginInfoItem;
@interface WUOHTTPRequest : NSObject

+ (instancetype)shareInstance;

// 开启菊花
+ (void)setActivityIndicator:(BOOL)enabled;

// 登录接口
+ (void)loginWithAccount:(NSString *)account pwd:(NSString *)pwd finished:(FinishedCallBack)finishedCallBack;

/**
 * @explain 动态接口
 *
 * @param   idstamp  此字段是作为请求动态界面的数据参数的，当上拉加载更多时，将本地的idstamp作为下次上拉加载的参数，当下拉刷新时此字段为空
 * @parm    type 请求动态的类型 1是当前登录用户的动态数据  2是查找界面的动态数据
 * @parm    topicID  用于请求话题详情的
 * @parm    serachLabel 查找界面的动态数据 根据serachLabel传入的字段请求对应的数据
 */
+ (void)topicWithIdstamp:(NSString *)idstamp type:(NSInteger)type topicID:(NSInteger)topicID serachLabel:(NSString *)serachLabel finished:(FinishedCallBack)finishedCallBack;

// 获取登录用户信息模型
+ (XYLoginInfoItem *)userLoginInfoItem;

// 广告接口
+ (void)find_advertWithFinishedCallBack:(FinishedCallBack)finishedCallBack;

// 发现界面 分类标题接口 getHotTrendLabel
+ (void)find_hotTrendLabelWithFinishedCallBack:(FinishedCallBack)finishedCallBack;

// 发现界面 话题详情 接口 第一次进入话题详情界面时，请求这个数据，以后每次都请求下面的话题数据接口
+ (void)find_allTopicWithFinishedCallBack:(FinishedCallBack)finishedCallBack;

// 发现界面 -- 话题详情 接口
+ (void)find_topicDetailByID:(NSInteger)topicID finishedCallBack:(FinishedCallBack)finishedCallBack;
@end
