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

+ (instancetype)userInfoWithDict:(NSDictionary *)dict;
@end
