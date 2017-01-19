//
//  XYUserImgItem.h
//  WUO
//
//  Created by mofeini on 17/1/12.
//  Copyright © 2017年 com.test.demo. All rights reserved.
//

#import <Foundation/Foundation.h>

@class XYHTTPResponseInfo;
@interface XYUserImgItem : NSObject

@property (nonatomic, copy) NSString *imgUrl;

// 扩展属性
@property (nonatomic, strong)XYHTTPResponseInfo *info;
@property (nonatomic, strong) NSURL *imgFullURL;
@property (nonatomic, assign) CGSize imgSize;            // 图片的原始尺寸

- (instancetype)initWithDict:(NSDictionary *)dict responseInfo:(XYHTTPResponseInfo *)info;
+ (instancetype)imgItemWithDict:(NSDictionary *)dict responseInfo:(XYHTTPResponseInfo *)info;

@end
