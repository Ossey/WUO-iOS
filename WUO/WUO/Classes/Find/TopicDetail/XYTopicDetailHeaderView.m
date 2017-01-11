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
    /** 标题 */
//    WUOLabel *_titleLabel;
}

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.clipsToBounds = YES;
        _postBGView = [[UIImageView alloc] initWithFrame:CGRectZero];
        [self insertSubview:_postBGView atIndex:0];
        
        // 头像
        _avatarView = [UIButton buttonWithType:UIButtonTypeCustom];
        _avatarView.frame = CGRectMake(SIZE_MARGIN, SIZE_MARGIN, SIZE_HEADERWH, SIZE_HEADERWH);
        _avatarView.backgroundColor = kColorGlobalCell;
        _avatarView.hidden = NO;
        _avatarView.tag = NSIntegerMax;
        _avatarView.clipsToBounds = YES;
        [self addSubview:_avatarView];
        
        // 目的是让头像显示为圆形
        _cornerView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, SIZE_CORNERWH, SIZE_CORNERWH)];
        _cornerView.center = _avatarView.center;
        _cornerView.image = [UIImage imageNamed:@"corner_circle"];
        _cornerView.tag = NSIntegerMax;
        [self addSubview:_cornerView];
        
        // logo视图
        _logoView = [[UIImageView alloc] init];
        _logoView.tag = NSIntegerMax;
        [self addSubview:_logoView];
        
        // 标题
        //        _titleLabel = [[WUOLabel alloc] init];
        //        _titleLabel.textColor = kColorTitleText;
        //        _titleLabel.font = kFontWithSize(SIZE_FONT_TITLE);
        //        _titleLabel.lineSpace = 0;
        //        [self addSubview:_titleLabel];
        //
        // 活动介绍
        _introduceLabel = [[WUOLabel alloc] init];
        _introduceLabel.textColor = kColorContentText;
        _introduceLabel.font = kFontWithSize(SIZE_FONT_CONTENT);
        _introduceLabel.lineSpace = 0;
        [self addSubview:_introduceLabel];
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
        [kColorGlobalCell set];
        CGContextFillRect(context, rect);

        // name
        [self.item.name drawInContext:context withPosition:self.item.topicDetailNameFrame.origin andFont:kFontWithSize(SIZE_FONT_NAME)
                                   andTextColor:kColorNameText
                                      andHeight:self.item.topicDetailNameFrame.size.height];
        
        // 创建时间
        [self.item.statTimeFormat drawInContext:context withPosition:self.item.topicDetailStartTimeFrame.origin andFont:kFontWithSize(SIZE_FONT_SUBTITLE) andTextColor:kColorContentText andHeight:self.item.topicDetailNameFrame.size.height];
        
        // 参加人数 背景
        [[UIImage imageNamed:@"mine_payButtonIcon"] drawInRect:CGRectMake(self.item.topicDetailJoinCountFrame.origin.x-5, self.item.topicDetailJoinCountFrame.origin.y-3, self.item.topicDetailJoinCountFrame.size.width+10,  self.item.topicDetailJoinCountFrame.size.height+6+3) blendMode:kCGBlendModeNormal alpha:0.8];
        
        // 参加人数
        [self.item.joinCounStr drawInContext:context withPosition:self.item.topicDetailJoinCountFrame.origin andFont:kFontWithSize(SIZE_FONT_JOINCOUNT) andTextColor:kColorContentText andHeight:self.item.topicDetailJoinCountFrame.size.height];
         
        // 标题
        [self.item.Title drawInContext:context withPosition:self.item.topicDetailTitleFrame.origin andFont:kFontWithSize(SIZE_FONT_TITLE) andTextColor:kColorTitleText andHeight:self.item.topicDetailTitleFrame.size.height];
        
//        // 正文
//        [self.item.introduce drawInContext:context withPosition:self.item.topicDetailIntroduceFrame.origin andFont:kFontWithSize(SIZE_FONT_CONTENT) andTextColor:kColorContentText andHeight:self.item.topicDetailIntroduceFrame.size.height andWidth:kScreenW];
        
        // 参加话题背景
        [[UIImage imageNamed:@"mine_payButtonIcon"] drawInRect:self.item.topicDetailJoinTopicFrame blendMode:kCGBlendModeNormal alpha:1.0];
        // 参加话题
//        CGSize joinCounStrSize = [@"参加话题" sizeWithConstrainedToSize:CGSizeMake(MAXFLOAT, MAXFLOAT) fromFont:kFontWithSize(SIZE_FONT_TITLE) lineSpace:1];
       CGSize joinCounStrSize = [@"参加话题" boundingRectWithSize:CGSizeMake(MAXFLOAT, MAXFLOAT) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName: kFontWithSize(SIZE_FONT_TITLE)} context:nil].size;
        CGFloat joinCounStrX = (self.item.topicDetailJoinTopicFrame.size.width - joinCounStrSize.width) * 0.5 + self.item.topicDetailJoinTopicFrame.origin.x;
        CGFloat joinCountStrY = (self.item.topicDetailJoinTopicFrame.size.height - joinCounStrSize.height) * 0.5 + self.item.topicDetailJoinTopicFrame.origin.y - 2;
        [@"参加话题" drawInContext:context withPosition:CGPointMake(joinCounStrX, joinCountStrY) andFont:kFontWithSize(SIZE_FONT_TITLE) andTextColor:kColorTitleText andHeight:self.item.topicDetailJoinTopicFrame.size.height];
        
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
    
//    NSLog(@"%@--%@", _introduceLabel, NSStringFromCGRect(self.item.topicDetailIntroduceFrame));
    
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




- (void)setItem:(XYActivityTopicItem *)item {
    
    _item = item;
    
    [_avatarView sd_setBackgroundImageWithURL:item.headImgFullURL forState:UIControlStateNormal placeholderImage:nil options:SDWebImageLowPriority];

    [_logoView sd_setImageWithURL:item.logoFullURL];
    
    [self draw];

    _logoView.frame = _item.topicDetailLogoFrame;

    _introduceLabel.text = _item.introduce;
    _introduceLabel.frame = _item.topicDetailIntroduceFrame;

}



@end
