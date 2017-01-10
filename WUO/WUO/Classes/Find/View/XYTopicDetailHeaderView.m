//
//  XYTopicDetailHeaderView.m
//  WUO
//
//  Created by mofeini on 17/1/9.
//  Copyright © 2017年 com.test.demo. All rights reserved.
//

#import "XYTopicDetailHeaderView.h"
#import "XYActivityTopicItem.h"



@implementation XYTopicDetailHeaderView {
    
    UIButton *_avatarView;
    UIImageView *_cornerView;
    UIImageView *_logoView;
    UIImageView *_postBGView;
    BOOL _isDrawing;
    NSInteger _drawColorFlag;
}

- (instancetype)initWithReuseIdentifier:(NSString *)reuseIdentifier {
    if (self = [super initWithReuseIdentifier:reuseIdentifier]) {
        
        self.clipsToBounds = YES;
        _postBGView = [[UIImageView alloc] initWithFrame:CGRectZero];
        [self.contentView insertSubview:_postBGView atIndex:0];
        
        // 头像
        _avatarView = [UIButton buttonWithType:UIButtonTypeCustom];
        _avatarView.frame = CGRectMake(SIZE_MARGIN, SIZE_MARGIN, SIZE_HEADERWH, SIZE_HEADERWH);
        _avatarView.backgroundColor = [UIColor colorWithRed:250/255.0 green:250/255.0 blue:250/255.0 alpha:1];
        _avatarView.hidden = NO;
        _avatarView.tag = NSIntegerMax;
        _avatarView.clipsToBounds = YES;
        [self.contentView addSubview:_avatarView];
        
        // 圆形图片，目的是让头像显示为圆形
        _cornerView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, SIZE_CORNERWH, SIZE_CORNERWH)];
        _cornerView.center = _avatarView.center;
        _cornerView.image = [UIImage imageNamed:@"corner_circle"];
        _cornerView.tag = NSIntegerMax;
        [self.contentView addSubview:_cornerView];
        
        // logo视图
        _logoView = [[UIImageView alloc] initWithFrame:CGRectMake(0, SIZE_MARGIN+SIZE_HEADERWH+SIZE_MARGIN, CGRectGetWidth(self.contentView.frame), SIZE_LOGOH)];
        _logoView.tag = NSIntegerMax;
        [self.contentView addSubview:_logoView];
     
       
    }
    
    return self;
}

// 绘制主要的控件
//- (void)draw {
//    if (_isDrawing) {
//        return;
//    }
//    
//    NSInteger flag = _drawColorFlag;
//    // 标记正在绘制中
//    _isDrawing = YES;
//    
//    dispatch_async(dispatch_get_global_queue(0, 0), ^{
//        
//        // cell frame
//        CGRect rect = self.viewModel.cellBounds;
//        UIGraphicsBeginImageContextWithOptions(rect.size, YES, 0);
//        CGContextRef context = UIGraphicsGetCurrentContext();
//        [[self getBackgroundColor] set];
//        CGContextFillRect(context, rect);
//
//    });
//}


@end
