//
//  XYTopicDetailHeaderView.m
//  WUO
//
//  Created by mofeini on 17/1/9.
//  Copyright © 2017年 com.test.demo. All rights reserved.
//

#import "XYTopicDetailHeaderView.h"
#import "XYActivityTopicItem.h"
#import "NSString+WUO.h"
#import <UIImageView+WebCache.h>
#import <UIButton+WebCache.h>
#import "WUOLabel.h"

@implementation XYTopicDetailHeaderView {
    
    UIButton *_avatarView;
    UIImageView *_cornerView;
    UIImageView *_logoView;
    /** 背景视图 */
    UIImageView *_postBGView;
    /** 正在绘制中 */
    BOOL _isDrawing;
    NSInteger _drawColorFlag;
    /** 活动结束label */
    WUOLabel *_introduceLabel;
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
        
        // 目的是让头像显示为圆形
        _cornerView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, SIZE_CORNERWH, SIZE_CORNERWH)];
        _cornerView.center = _avatarView.center;
        _cornerView.image = [UIImage imageNamed:@"corner_circle"];
        _cornerView.tag = NSIntegerMax;
        [self.contentView addSubview:_cornerView];
        
        // logo视图
        _logoView = [[UIImageView alloc] initWithFrame:CGRectMake(0, SIZE_MARGIN+SIZE_HEADERWH+SIZE_MARGIN, kScreenW, SIZE_LOGOH)];
        _logoView.tag = NSIntegerMax;
        [self.contentView addSubview:_logoView];
     
//        [self addIntroduceLabel];
    }
    
    return self;
}

// 绘制主要的控件
- (void)draw {
    if (_isDrawing) {
        return;
    }
    
    NSInteger flag = _drawColorFlag;
    // 标记正在绘制中
    _isDrawing = YES;
    
    dispatch_async(dispatch_get_global_queue(0, 0), ^{
        
        // 开启 一个 跟cell bounds 相同的 图形上下文
        CGRect rect = self.item.topicDetailHeaderBounds;
        UIGraphicsBeginImageContextWithOptions(rect.size, YES, 0);
        CGContextRef context = UIGraphicsGetCurrentContext();
        [[self getBackgroundColor] set];
        CGContextFillRect(context, rect);

        // name
        [self.item.name drawInContext:context withPosition:self.item.topicDetailNameFrame.origin andFont:kFontWithSize(SIZE_FONT_NAME)
                                   andTextColor:kColorNameText
                                      andHeight:self.item.topicDetailNameFrame.size.height];
        
        // 创建时间
        [self.item.statTimeFormat drawInContext:context withPosition:self.item.topicDetailStartTimeFrame.origin andFont:kFontWithSize(SIZE_FONT_NAME) andTextColor:kColorNameText andHeight:self.item.topicDetailNameFrame.size.height];
        
        // 参加人数 背景
        // 参加人数
        [self.item.joinCounStr drawInContext:context withPosition:self.item.topicDetailJoinCountFrame.origin andFont:kFontWithSize(SIZE_FONT_JOINCOUNT) andTextColor:kColorCountText andHeight:self.item.topicDetailJoinCountFrame.size.height];
         
        // 标题
        [self.item.Title drawInContext:context withPosition:self.item.topicDetailTitleFrame.origin andFont:kFontWithSize(SIZE_FONT_TITLE) andTextColor:kColorTitleText andHeight:self.item.topicDetailTitleFrame.size.height];
        
        // 正文
        [self.item.introduce drawInContext:context withPosition:self.item.topicDetailIntroduceFrame.origin andFont:kFontWithSize(SIZE_FONT_CONTENT) andTextColor:kColorContentText andHeight:self.item.topicDetailIntroduceFrame.size.height andWidth:self.item.topicDetailIntroduceFrame.size.width];
        
        
        // 参加话题
        [@"参加话题" drawInContext:context withPosition:self.item.topicDetailJoinTopicFrame.origin andFont:kFontWithSize(SIZE_FONT_TITLE) andTextColor:kColorTitleText andHeight:self.item.topicDetailJoinTopicFrame.size.height];
        
        // 获取当前图形上下文
        UIImage *temImage = UIGraphicsGetImageFromCurrentImageContext();
        // 结束上下文
        UIGraphicsEndImageContext();
        // 回到主线程, 设置上下文中的图片
        dispatch_async(dispatch_get_main_queue(), ^{
            if (flag == _drawColorFlag) {
                _postBGView.frame = rect;
                _postBGView.image = nil;
                _postBGView.image = temImage;
            }
        });

    });
    
//    [self drawText];
    
}

- (void)clear {
    if (!_isDrawing) {
        return;
    }
    
    _postBGView.frame = CGRectZero;
    _postBGView.image = nil;
    
    _drawColorFlag = arc4random();
    _isDrawing = NO;
}

- (void)releaseMemory {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    [self clear];
    [super removeFromSuperview];
}

//- (void)addIntroduceLabel {
//    
//    if (_introduceLabel) {
//        [_introduceLabel removeFromSuperview];
//        _introduceLabel = nil;
//    }
//    
//    // 活动介绍
//    _introduceLabel = [[WUOLabel alloc] initWithFrame:self.item.topicDetailIntroduceFrame];
//    _introduceLabel.textColor = kColorContentText;
//    _introduceLabel.text = self.item.introduce;
//    [self.contentView addSubview:_introduceLabel];
//    
//}

//将文本内容绘制到图片上
//- (void)drawText {
////    if (_introduceLabel == nil) {
////        [self addIntroduceLabel];
////    }
//
//    
//}

- (void)setItem:(XYActivityTopicItem *)item {
    
    _item = item;
    
    [_avatarView sd_setBackgroundImageWithURL:item.headImgFullURL forState:UIControlStateNormal placeholderImage:nil options:SDWebImageLowPriority];

    [_logoView sd_setImageWithURL:item.logoFullURL];
    
    [self draw];
    
//    if (item.introduce.length) {
//        _introduceLabel = [[WUOLabel alloc] init];
//        _introduceLabel.frame = item.topicDetailIntroduceFrame;
//        _introduceLabel.text = item.introduce;
//        _introduceLabel.hidden = NO;
//        [self.contentView addSubview:_introduceLabel];
//    }
}

- (UIColor *)getBackgroundColor {
    
    return [UIColor colorWithRed:250/255.0 green:250/255.0 blue:250/255.0 alpha:1];
}



@end
