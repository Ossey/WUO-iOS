//
//  XYUserInfo.h
//  WUO
//
//  Created by mofeini on 17/1/12.
//  Copyright © 2017年 com.test.demo. All rights reserved.
//  用户详情页的用户模型

#import <Foundation/Foundation.h>
#import "XYHTTPResponseInfo.h"

@class XYHTTPResponseInfo;
@interface XYUserInfo : NSObject

@property (nonatomic, copy) NSString *bgImg;
@property (nonatomic, assign) NSInteger freeGMNum;
@property (nonatomic, assign) NSInteger honorCount;
@property (nonatomic, copy) NSString *phoneNumber;
@property (nonatomic, copy) NSString *school;
@property (nonatomic, copy) NSString *token;

@property (nonatomic, strong) XYHTTPResponseInfo *responseInfo;
/** 用户头像，需拼接路径 */
@property (nonatomic, copy) NSString *head;
@property (nonatomic, assign) NSInteger age;
@property (nonatomic, assign) NSInteger appraiseCount;
@property (nonatomic, copy) NSString *birthday;
@property (nonatomic, assign) CGFloat cash;
@property (nonatomic, assign) NSInteger commentCount;
@property (nonatomic, assign) NSInteger constellation;
@property (nonatomic, copy) NSString *Description;  // 原字段description
@property (nonatomic, assign) CGFloat earningsCash;
@property (nonatomic, assign) CGFloat earningsGoldCoin;
@property (nonatomic, copy) NSString *email;
@property (nonatomic, assign) NSInteger fansCount;
/** 粉丝数量 */
@property (nonatomic, assign) NSInteger followCount;
@property (nonatomic, assign) NSInteger gender;
/** 投资数量 */
@property (nonatomic, assign) NSInteger gmCount;
@property (nonatomic, assign) CGFloat goldCoin;
/** 是否是黑名单 */
@property (nonatomic, assign) BOOL isBlacklist;
/** 查看的用户是不是登录用户的粉丝 */
@property (nonatomic, assign) BOOL isFans;
/** 是否是当前登录用户的关注者 */
@property (nonatomic, assign) BOOL isFlower;
/** 当前登录的用户是否关注查看的用户 */
@property (nonatomic, assign) BOOL isFollow;
/** 当前登录的用户是否投资查看的用户 */
@property (nonatomic, assign) BOOL isInvest;
@property (nonatomic, copy) NSString *job;
@property (nonatomic, copy) NSString *location;
@property (nonatomic, copy) NSString *name;
/** 分享数量 */
@property (nonatomic, assign) NSInteger shareCount;
@property (nonatomic, assign) NSInteger uid;
@property (nonatomic, strong) NSArray *userLabelList;


/// 扩展数
@property (nonatomic, strong) NSURL *headFullURL;
/** 对Description进行处理，当Description为空时，显示暂无个性签名 */
@property (nonatomic, copy) NSString *descriptionText;

+ (instancetype)userInfoWithDict:(NSDictionary *)dict responseInfo:(XYHTTPResponseInfo*)info;
- (instancetype)initWithDict:(NSDictionary *)dict responseInfo:(XYHTTPResponseInfo*)info;
@end

@interface XYUserLabelItem : NSObject

@property (nonatomic, copy) NSString *label;
@property (nonatomic, assign) NSInteger uid;
@property (nonatomic, assign) NSInteger ulid;

+ (instancetype)userLabelItemWithDict:(NSDictionary *)dict;
- (instancetype)initWithDict:(NSDictionary *)dict;
@end
