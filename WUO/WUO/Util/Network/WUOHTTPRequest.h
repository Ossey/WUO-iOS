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

/**
 * @explain 登录接口
 *
 */
+ (void)loginWithAccount:(NSString *)account pwd:(NSString *)pwd finished:(FinishedCallBack)finishedCallBack;


/**
 * @explain 每次请求网络时，检测登录状态，如果发现已经在其他地方登录，当前账户就要强制退出，并提醒用户
 * @param   code 用户请求服务端，返回在response中的响应码，根据此字段确定是否登录成功，如为-2，登录失败
 */
+ (void)checkLoginStatusFromResponseCode:(NSInteger)code;

/**
 * @explain 动态接口
 *
 * @param   idstamp  此字段是作为请求动态界面的数据参数的，当上拉加载更多时，将本地的idstamp作为下次上拉加载的参数，当下拉刷新时此字段为空
 * @parm    type 请求动态的类型 1是当前登录用户的动态数据  2是查找界面的动态数据
 * @parm    topicID  用于请求话题详情的
 * @parm    serachLabel 查找界面的动态数据 根据serachLabel传入的字段请求对应的数据
 */
+ (void)topicWithIdstamp:(NSString *)idstamp type:(NSInteger)type serachLabel:(NSString *)serachLabel finished:(FinishedCallBack)finishedCallBack;

/**
 * @explain 获取登录用户信息模型
 *
 */
+ (XYLoginInfoItem *)userLoginInfoItem;

/**
 * @explain 广告接口
 *
 */
+ (void)find_advertWithFinishedCallBack:(FinishedCallBack)finishedCallBack;

/**
 * @explain 发现界面 分类标题接口 getHotTrendLabel
 *
 */
+ (void)find_hotTrendLabelWithFinishedCallBack:(FinishedCallBack)finishedCallBack;

/**
 * @explain 发现界面 话题详情 接口 第一次进入话题详情界面时，请求这个数据，以后每次都请求下面的话题数据接口
 *
 */
+ (void)find_allTopicWithFinishedCallBack:(FinishedCallBack)finishedCallBack;

/**
 * @explain 发现界面 -- 话题详情 接口
 *
 */
+ (void)find_topicDetailByID:(NSInteger)topicID finishedCallBack:(FinishedCallBack)finishedCallBack;

/**
 * @explain 发现界面 -- 话题详情topic 接口  type为1时请求最新数据，type为0时请求排行榜数据
 *
 */
+ (void)find_getTrendByTopicId:(NSInteger)topicID idstamp:(NSString *)idstamp type:(NSInteger)type finishedCallBack:(FinishedCallBack)finishedCallBack;

/**
 * @explain 用户详情页--获取用户的主页及用户信息的 每次进入页面时，只需要获取一次即可
 *
 */
+ (void)userDetail_getUserInfoWithtargetUid:(NSInteger)targetUid finishedCallBack:(FinishedCallBack)finishedCallBack;

/**
 * @explain 用户详情界面 请求用户发布的作品的
 *
 */
+ (void)userDetail_getUserTopicByUid:(NSInteger)uid idstamp:(NSString *)idstamp finishedCallBack:(FinishedCallBack)finishedCallBack;

/**
 * @explain // 用户相册
 *
 * @param   page  是指请求的页数
 */
+ (void)userDetail_getUserAlbumWithPage:(NSInteger)page targetUid:(NSInteger)targetUid finishedCallBack:(FinishedCallBack)finishedCallBack;
@end
