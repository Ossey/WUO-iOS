//
//  XYAdvertView.h
//  WUO
//
//  Created by mofeini on 17/1/5.
//  Copyright © 2017年 com.test.demo. All rights reserved.
//

#import <UIKit/UIKit.h>

@class XYAdvertItem;
@interface XYAdvertView : UIView

/** 广告模型数组 */
@property (nonatomic, strong) NSArray *advertItems;

/**
 * @explain 点击广告的block回调
 * 回调点击广告对应的banner模型
 */
@property (nonatomic, copy) void(^advertClickBlock)(XYAdvertItem *adItem);

@end
