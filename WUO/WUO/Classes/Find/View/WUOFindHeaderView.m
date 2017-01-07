//
//  WUOFindHeaderView.m
//  WUO
//
//  Created by mofeini on 17/1/7.
//  Copyright © 2017年 com.test.demo. All rights reserved.
//

#import "WUOFindHeaderView.h"


@interface WUOFindHeaderView ()

@property (nonatomic, strong) XYFindTopicView *headerView;
@property (nonatomic, strong) XYTrendLabelView *trendLabelView;

@end

@implementation WUOFindHeaderView

- (instancetype)initWithReuseIdentifier:(NSString *)reuseIdentifier {
    if (self = [super initWithReuseIdentifier:reuseIdentifier]) {
        
        self.headerView.hidden = NO;
        self.trendLabelView.hidden = NO;
        
    }
    
    return self;
}

- (XYFindTopicView *)headerView {
    if (_headerView == nil) {
        _headerView = [XYFindTopicView new];
        [self.contentView addSubview:_headerView];
    }
    return _headerView;
}

- (XYTrendLabelView *)trendLabelView {
    
    if (_trendLabelView == nil) {
        _trendLabelView = [[XYTrendLabelView alloc] initWithFrame:CGRectMake(0, 0, kScreenW, kTrendLabelViewHeight) delegate:self channelCates:_trendLabelList rightBtnWidth:50];
        _trendLabelView.itemNameKey = @"labelName";
        [_trendLabelView.rightButton setImage:[UIImage imageNamed:@"Find_addTagBtn"] forState:UIControlStateNormal];
        //        _trendLabelView.delegate = self;
        [_trendLabelView.rightButton sizeToFit];
        [self.contentView addSubview:_trendLabelView];
        
        [_trendLabelView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.bottom.left.right.equalTo(self.contentView);
            make.height.mas_equalTo(kTrendLabelViewHeight);
            make.top.equalTo(_headerView.mas_bottom).mas_offset(kHeaderFooterViewInsetMargin);
        }];
        
        [_headerView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.left.right.equalTo(self.contentView);
            make.height.mas_equalTo(kTopicViewHeight).priorityLow();
        }];
    }
    return _trendLabelView;
}

- (void)setTrendLabelList:(NSArray *)trendLabelList {
    _trendLabelList = [trendLabelList copy];
    _trendLabelView.channelCates = [trendLabelList copy];
}


- (void)dealloc {
    
    NSLog(@"%s", __FUNCTION__);
}

@end
