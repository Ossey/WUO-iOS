//
//  XYTrendTableView.h
//  WUO
//
//  Created by mofeini on 17/1/6.
//  Copyright © 2017年 com.test.demo. All rights reserved.
//

#import "XYDynamicTableView.h"

@interface XYTrendTableView : XYDynamicTableView

@property (nonatomic, copy) void (^cnameBlock)(NSString *serachLabel);
- (instancetype)initWithFrame:(CGRect)frame dataType:(NSInteger)type;
@end
