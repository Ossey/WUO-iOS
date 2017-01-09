//
//  XYFindTopicView.h
//  WUO
//
//  Created by mofeini on 17/1/5.
//  Copyright © 2017年 com.test.demo. All rights reserved.
//

#import <UIKit/UIKit.h>

@class XYActivityTopicItem;
@interface XYFindTopicView : UIView

/** 活动主题模型数据源数组 */
@property (nonatomic, strong) NSArray<XYActivityTopicItem *> *topicItemList;

@end

@interface XYFindTopicViewCell : UICollectionViewCell

/** 活动主题模型 */
@property (nonatomic, strong) XYActivityTopicItem *topicItem;

@end
