//
//  XYTopicDetailSelectView.m
//  WUO
//
//  Created by mofeini on 17/1/10.
//  Copyright © 2017年 com.test.demo. All rights reserved.
//

#import "XYTopicDetailSelectView.h"



@interface XYTopicDetailSelectView ()

@end

@implementation XYTopicDetailSelectView

- (instancetype)initWithReuseIdentifier:(NSString *)reuseIdentifier {
    if (self = [super initWithReuseIdentifier:reuseIdentifier]) {
        self.trendLabelView.hidden = NO;
//        [_trendLabelView setItemWidth:50];
//        [_trendLabelView setUnderLineWidth:20];
    }
    return self;
}

- (XYTopicDetailLabelView *)trendLabelView {
    
    if (_trendLabelView == nil) {
        
        _trendLabelView = [[XYTopicDetailLabelView alloc] initWithFrame:CGRectMake(0, 0, kScreenW, kTrendLabelViewHeight) delegate:self channelCates:nil rightBtnWidth:0];
        _trendLabelView.itemNameKey = @"labelName";
        [self.contentView addSubview:_trendLabelView];
        
        [_trendLabelView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.edges.equalTo(self.contentView);
        }];
        
    }
    return _trendLabelView;
}



@end
