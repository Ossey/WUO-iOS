//
//  XYActiveTopicDetailSelectView.m
//  WUO
//
//  Created by mofeini on 17/1/10.
//  Copyright © 2017年 com.test.demo. All rights reserved.
//

#import "XYActiveTopicDetailSelectView.h"



@interface XYActiveTopicDetailSelectView ()

@end

@implementation XYActiveTopicDetailSelectView

- (instancetype)initWithReuseIdentifier:(NSString *)reuseIdentifier {
    if (self = [super initWithReuseIdentifier:reuseIdentifier]) {
        self.trendLabelView.hidden = NO;
//        [_trendLabelView setItemWidth:50];
//        [_trendLabelView setUnderLineWidth:20];
        // 默认选中的是1
        
    }
    return self;
}

- (XYActiveTopicDetailLabelView *)trendLabelView {
    
    if (_trendLabelView == nil) {
        
        _trendLabelView = [[XYActiveTopicDetailLabelView alloc] initWithFrame:CGRectMake(0, 0, kScreenW, kTrendLabelViewHeight) delegate:self channelCates:nil rightBtnWidth:0];
        _trendLabelView.itemNameKey = @"labelName";
        [self.contentView addSubview:_trendLabelView];
        [_trendLabelView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.edges.equalTo(self.contentView);
        }];
        
    }
    return _trendLabelView;
}



@end
