//
//  XYUserDetailTableView.m
//  WUO
//
//  Created by mofeini on 17/1/12.
//  Copyright © 2017年 com.test.demo. All rights reserved.
//

#import "XYUserDetailTableView.h"
#import "XYUserDetailHeaderView.h"

@implementation XYUserDetailTableView {
    XYUserDetailHeaderView *_headerView;
}

- (instancetype)initWithFrame:(CGRect)frame style:(UITableViewStyle)style {
    if (self = [super initWithFrame:frame style:style]) {
        
        _headerView = [XYUserDetailHeaderView new];
        _headerView.xy_height = SIZE_USER_DETAIL_HEADERVIEW_H;
        self.tableHeaderView = _headerView;
    }
    return self;
}

@end
