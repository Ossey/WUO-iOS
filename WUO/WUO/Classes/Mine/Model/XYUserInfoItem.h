//
//  XYUserInfoItem.h
//  WUO
//
//  Created by mofeini on 17/1/2.
//  Copyright © 2017年 com.test.demo. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface XYUserInfoItem : NSObject

@property (nonatomic, assign) NSInteger age;
@property (nonatomic, copy) NSString *bgImg;
@property (nonatomic, copy) NSString *birthday;
@property (nonatomic, assign) NSInteger cash;
@property (nonatomic, assign) NSInteger constellation;
@property (nonatomic, copy) NSString *Description; // 原字段 description
@property (nonatomic, copy) NSString *email;
@property (nonatomic, strong) NSDictionary *extra;
@property (nonatomic, assign) NSInteger fansCount;
@property (nonatomic, assign) NSInteger followCount;
@property (nonatomic, assign) NSInteger freeGMNum;
@property (nonatomic, assign) NSInteger gender;
@property (nonatomic, assign) NSInteger gmCount;
@property (nonatomic, assign) NSInteger goldCoin;
@property (nonatomic, copy) NSString *head;        // 用户头像，需拼接路径
@property (nonatomic, assign) NSInteger honorCount;
@property (nonatomic, copy) NSString *job;
@property (nonatomic, copy) NSString *location;
@property (nonatomic, assign) NSInteger loginNum;  // 登录次数
@property (nonatomic, copy) NSString *name;
@property (nonatomic, copy) NSString *phoneNumber;
@property (nonatomic, copy) NSString *school;
@property (nonatomic, copy) NSString *token;
@property (nonatomic, assign) NSInteger uid;

- (instancetype)initWithDict:(NSDictionary *)dict;
+ (instancetype)userInfoItemWithDict:(NSDictionary *)dict;

@end
