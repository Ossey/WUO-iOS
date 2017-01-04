//
//  XYLoginInfoItem.h
//  WUO
//
//  Created by mofeini on 17/1/2.
//  Copyright © 2017年 com.test.demo. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "XYUserInfoItem.h"


@interface XYLoginInfoItem : NSObject

@property (nonatomic, copy) NSString *basePath;
@property (nonatomic, assign) NSInteger code;        // 登录状态码  0成功 -2未登录
@property (nonatomic, copy) NSString *codeMsg;
@property (nonatomic, strong) NSDictionary *imUser;  // 即时通讯用户
@property (nonatomic, strong) XYUserInfoItem *userInfo;

- (instancetype)initWithDict:(NSDictionary *)dict;
+ (instancetype)loginInfoItemWithDict:(NSDictionary *)dict;

@end
