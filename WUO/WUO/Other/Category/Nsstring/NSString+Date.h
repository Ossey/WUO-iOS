//
//  NSString+Date.h
//  WUO
//
//  Created by mofeini on 17/1/10.
//  Copyright © 2017年 com.test.demo. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSString (Date)

/**
 * @explain 用当前时间与传入的时间比较
 *
 * @param   str  需要与当前时间比较的时间字符串
 * @return  刚刚、多少分钟前、多少小时前、多少天前、多少月前、多少年前
 */
+ (NSString *)compareCurrentTime:(NSString *)str;

@end
