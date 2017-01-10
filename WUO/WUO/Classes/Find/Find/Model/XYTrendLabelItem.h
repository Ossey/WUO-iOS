//
//  XYTrendLabelItem.h
//  WUO
//
//  Created by mofeini on 17/1/6.
//  Copyright © 2017年 com.test.demo. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface XYTrendLabelItem : NSObject

@property (nonatomic, copy) NSString *labelName;
@property (nonatomic, assign) NSInteger lid;
@property (nonatomic, assign) NSInteger uid;

- (instancetype)initWithDict:(NSDictionary *)dict;
+ (instancetype)trendLabelItemWithDict:(NSDictionary *)dict;

@end
