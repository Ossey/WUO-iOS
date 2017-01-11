//
//  XYTopicViewCell.h
//  WUO
//
//  Created by mofeini on 17/1/2.
//  Copyright © 2017年 com.test.demo. All rights reserved.
//

#import <UIKit/UIKit.h>

@class XYTopicViewModel;


@interface XYTopicViewCell : UITableViewCell

@property (nonatomic, strong) XYTopicViewModel *viewModel;

- (void)clear;
- (void)releaseMemory;
- (void)draw;


@end
