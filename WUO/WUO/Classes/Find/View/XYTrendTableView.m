//
//  XYTrendTableView.m
//  WUO
//
//  Created by mofeini on 17/1/6.
//  Copyright © 2017年 com.test.demo. All rights reserved.
//

#import "XYTrendTableView.h"

@interface XYTrendTableView () <XYDynamicTableViewDelegate>

@property (nonatomic, copy) NSString *cname;

@end

@implementation XYTrendTableView


- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        
        self.dynamicDelegate = self;
    }
    return self;
}

- (NSInteger)getNetworkType {
    return 2;
}


- (NSString *)getSerachLabel {
    
    __block NSString *str = @"";
    [self setCnameBlock:^(NSString *cname) {
        str = cname;
    }];

    return @"推荐";
}


#pragma mark - XYDynamicTableViewDelegate
- (void)dynamicTableViewDidEndDecelerating:(UIScrollView *)scrollView {
    
    // 发布scrollView停止减速的通知
    NSNotificationName const XYTrendTableViewDidEndDeceleratingNote = @"XYTrendTableViewDidEndDeceleratingNote";
    [[NSNotificationCenter defaultCenter] postNotificationName:XYTrendTableViewDidEndDeceleratingNote object:scrollView userInfo:nil];
}

- (void)dynamicTableViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate {

        // 发布停止拖拽scrollView的通知
    [[NSNotificationCenter defaultCenter] postNotificationName:XYTrendTableViewDidEndDraggingNote object:scrollView userInfo:@{@"isDecelerate" : @(decelerate)}];
    
}

- (void)dynamicTableViewDidScroll:(UIScrollView *)scrollView {
    
    [[NSNotificationCenter defaultCenter] postNotificationName:XYTrendTableViewDidScrollNote object:scrollView userInfo:nil];
}



@end
