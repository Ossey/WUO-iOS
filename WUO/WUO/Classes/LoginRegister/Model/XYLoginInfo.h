//
//  XYLoginInfoItem.h
//  WUO
//
//  Created by mofeini on 17/1/2.
//  Copyright © 2017年 com.test.demo. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "XYUserInfo.h"

@class XYImUser;
@interface XYLoginInfoItem : NSObject

@property (nonatomic, copy) NSString *basePath;
@property (nonatomic, assign) NSInteger code;        // 登录状态码  0成功 -2未登录
@property (nonatomic, copy) NSString *codeMsg;
@property (nonatomic, strong) XYImUser *imUser;  // 即时通讯用户
@property (nonatomic, strong) XYUserInfo *userInfo;

- (instancetype)initWithDict:(NSDictionary *)dict;
+ (instancetype)loginInfoItemWithDict:(NSDictionary *)dict;

@end

// 用户的即时通讯账号：当登录成功后返回其账号密码，使用此账号密码，登录环信
@interface XYImUser : NSObject

@property (nonatomic, copy) NSString *password;
@property (nonatomic, copy) NSString *username;

- (instancetype)initWithDict:(NSDictionary *)dict;

@end
