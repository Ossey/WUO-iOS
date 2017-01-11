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

@interface WUOToolView : UIView {
    
@public
    UIButton *_shareBtn;
    UIButton *_commentBtn;
    UIButton *_rewardBtn;
    UIButton *_praiseBtn;
}

@property (nonatomic, copy) void (^toolViewEventBlock)(UIButton *btn, WUOToolViewEventType type);

@end
