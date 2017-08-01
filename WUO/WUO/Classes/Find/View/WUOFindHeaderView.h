//
//  WUOFindHeaderView.h
//  WUO
//
//  Created by mofeini on 17/1/7.
//  Copyright © 2017年 com.test.demo. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "XYFindTopicView.h"
#import "XYTrendLabelView.h"

@interface WUOFindHeaderView : UITableViewHeaderFooterView {
@private
    NSArray *_trendLabelList;
}

@property (nonatomic, strong, readonly) XYFindTopicView *topicView;
@property (nonatomic, strong, readonly) XYTrendLabelView *trendLabelView;
- (void)setTrendLabelList:(NSArray *)trendLabelList;
@end
