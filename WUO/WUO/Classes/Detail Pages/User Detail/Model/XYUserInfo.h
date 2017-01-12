//
//  XYUserInfo.h
//  WUO
//
//  Created by mofeini on 17/1/12.
//  Copyright © 2017年 com.test.demo. All rights reserved.
//

#import <Foundation/Foundation.h>

@class XYHTTPResponseInfo;
@interface XYUserInfo : NSObject

@property (nonatomic, strong) XYHTTPResponseInfo *responseInfo;
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
@property (nonatomic, assign) NSInteger followCount;
@property (nonatomic, assign) NSInteger gender;
@property (nonatomic, assign) NSInteger gmCount;
@property (nonatomic, assign) CGFloat goldCoin;
@property (nonatomic, assign) BOOL isBlacklist;
@property (nonatomic, assign) BOOL isFans;
@property (nonatomic, assign) BOOL isFlower;
@property (nonatomic, assign) BOOL isFollow;
@property (nonatomic, assign) BOOL isInvest;
@property (nonatomic, copy) NSString *job;
@property (nonatomic, copy) NSString *location;
@property (nonatomic, copy) NSString *name;
@property (nonatomic, assign) NSInteger shareCount;
@property (nonatomic, assign) NSInteger uid;
@property (nonatomic, strong) NSArray *userLabelList;

+ (instancetype)userInfoWithDict:(NSDictionary *)dict;
- (instancetype)initWithDict:(NSDictionary *)dict;
@end

@interface XYUserLabelItem : NSObject

@property (nonatomic, copy) NSString *label;
@property (nonatomic, assign) NSInteger uid;
@property (nonatomic, assign) NSInteger ulid;

+ (instancetype)userLabelItemWithDict:(NSDictionary *)dict;
- (instancetype)initWithDict:(NSDictionary *)dict;
@end
