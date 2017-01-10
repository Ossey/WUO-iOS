//
//  NSString+Date.m
//  WUO
//
//  Created by mofeini on 17/1/10.
//  Copyright © 2017年 com.test.demo. All rights reserved.
//

#import "NSString+Date.h"

@implementation NSString (Date)

+ (NSString *)compareCurrentTime:(NSString *)str {
    // 将时间字符串转换为NSDate
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"yyy-MM-dd HH:mm:ss"];
    NSDate *timeDate = [dateFormatter dateFromString:str];
    
    // 时区
    NSTimeZone *zone = [NSTimeZone timeZoneWithName:@"Asia/Shanghai"];
    [dateFormatter setTimeZone:zone];
    
    // 获取当前时间
    NSDate *currentDate = [NSDate date];
    // 获取当前时间距离timeStr的时间差
    NSTimeInterval timeInterVal = [currentDate timeIntervalSinceDate:timeDate];
    
    long temp = 0;
    NSString *resultStr;
    
    if (timeInterVal / 60 < 1) {
        resultStr = @"刚刚";
    } else if ((temp = timeInterVal / 60) < 60) {
        resultStr = [NSString stringWithFormat:@"%ld分钟前", temp];
    } else if ((temp = temp / 60) < 24) {
        resultStr = [NSString stringWithFormat:@"%ld小时前", temp];
    } else if ((temp = temp / 24) < 30) {
        resultStr = [NSString stringWithFormat:@"%ld天前", temp];
    } else if ((temp = temp / 30) < 12) {
        resultStr = [NSString stringWithFormat:@"%ld月前", temp];
    } else {
        temp = temp / 12;
        resultStr = [NSString stringWithFormat:@"%ld年前", temp];
    }
    
    return resultStr;
}


@end
