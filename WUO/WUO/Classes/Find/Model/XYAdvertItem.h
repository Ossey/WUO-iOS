//
//  XYAdvertItem.h
//  WUO
//
//  Created by mofeini on 17/1/5.
//  Copyright © 2017年 com.test.demo. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface XYAdvertItem : NSObject

@property (nonatomic, assign) NSInteger createTime;
@property (nonatomic, assign) id ID;            // 原字段id
@property (nonatomic, assign) BOOL isShow;
@property (nonatomic, copy) NSString *imgs;     
@property (nonatomic, copy) NSString *content;
@property (nonatomic, copy) NSString *linkUrl;   // 点击广告图片跳转的路径
@property (nonatomic, copy) NSString *msgKey;
@property (nonatomic, copy) NSString *msgValue;
@property (nonatomic, copy) NSString *title;
@property (nonatomic, copy) NSString *type;
@property (nonatomic, copy) NSString *updateTime;

- (instancetype)initWithDict:(NSDictionary *)dict;
+ (instancetype)advertItemWithDict:(NSDictionary *)dict;

@end
