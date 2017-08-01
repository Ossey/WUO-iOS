//
//  WUOToolView.h
//  WUO
//
//  Created by mofeini on 17/1/4.
//  Copyright © 2017年 com.test.demo. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSInteger, WUOToolViewEventType) {
    
    WUOToolViewEventTypeShare = 0, // 分享
    WUOToolViewEventTypeComment,   // 评论
    WUOToolViewEventTypeReward,    // 奖赏
    WUOToolViewEventTypePraise     // 点赞
};

@class XYTrendItem;
@interface WUOToolView : UIView {
    
@public
    /** 分享按钮 */
    UIButton *_shareBtn;
    /** 评论按钮 */
    UIButton *_commentBtn;
    /** 奖赏按钮 */
    UIButton *_rewardBtn;
    /** 点赞按钮 */
    UIButton *_praiseBtn;
}

@property (nonatomic, copy) void (^toolViewEventBlock)(UIButton *btn, WUOToolViewEventType type);
@property (nonatomic, strong) XYTrendItem *item;
@end
