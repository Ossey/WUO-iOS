//
//  XYTrendTableView.m
//  WUO
//
//  Created by mofeini on 17/1/6.
//  Copyright © 2017年 com.test.demo. All rights reserved.
//

#import "XYTrendTableView.h"

@interface XYTrendTableView () <XYDynamicTableViewDelegate>


@end

@implementation XYTrendTableView


- (instancetype)initWithFrame:(CGRect)frame dataType:(NSInteger)type
{
    self = [super initWithFrame:frame style:UITableViewStyleGrouped];
    if (self) {
        self.dataType = type;
        self.dynamicDelegate = self;
        
        __weak typeof(self) weak_self = self;
        self.cnameBlock = ^(NSString *cname) {
            weak_self.serachLabel = cname;
        };
        
    }
    return self;
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
