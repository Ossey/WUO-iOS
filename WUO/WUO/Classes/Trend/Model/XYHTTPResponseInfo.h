//
//  XYHTTPResponseInfo.h
//  WUO
//
//  Created by mofeini on 17/1/3.
//  Copyright © 2017年 com.test.demo. All rights reserved.
//  所有请求服务器时，返回的info信息模型

#import <Foundation/Foundation.h>

@interface XYHTTPResponseInfo : NSObject

@property (nonatomic, copy) NSString *basePath;
@property (nonatomic, assign) NSInteger code;
@property (nonatomic, copy) NSString *codeMsg;
/** 此字段是作为请求动态界面的数据参数的，当上拉加载更多时，将本地的idstamp作为下次上拉加载的参数，当下拉刷新时此字段为空 */
@property (nonatomic, assign) NSInteger idstamp;


+ (instancetype)responseInfoWithDict:(NSDictionary *)dict;

@end
