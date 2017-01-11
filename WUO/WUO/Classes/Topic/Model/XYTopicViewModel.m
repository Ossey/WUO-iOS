//
//  XYTopicViewModel.m
//  WUO
//
//  Created by mofeini on 17/1/3.
//  Copyright © 2017年 com.test.demo. All rights reserved.
//

#import "XYTopicViewModel.h"

@implementation XYTopicViewModel

- (instancetype)initWithItem:(XYTopicItem *)item info:(XYTopicInfo *)info {
    if (self = [super init]) {
        self.item = item;
        self.info = info;
    }
    
    return self;
}

+ (instancetype)topicViewModelWithTopic:(XYTopicItem *)item info:(XYTopicInfo *)info {
    
    return [[self alloc] initWithItem:item info:info];
}


- (NSURL *)headerImageURL {
    NSString *fullPath = nil;
    if ([self.item.head containsString:@"http://"]) {
        fullPath = self.item.head;
    } else {
        fullPath = [self.info.basePath stringByAppendingString:self.item.head];
    }
    return [NSURL URLWithString:fullPath];
}

- (CGRect)cellBounds {
    
    return CGRectMake(0, 0, kScreenW, self.cellHeight);
}

- (CGFloat)cellHeight {
    
    if (_cellHeight != 0) {
        // 当已计算好时，就不再计算
        return _cellHeight;
    }
    
    CGFloat x = SIZE_GAP_MARGIN;
    CGFloat y = SIZE_GAP_TOP;
    
    // 排名
    if (self.item.ranking.length) {
        CGFloat rankingHeight = 30;
        CGFloat rankingWidth = 80;
        // 有排名
        self.rankingFrame = CGRectMake(-18, y, rankingWidth, rankingHeight);
        y += rankingHeight + SIZE_GAP_TOP;
    } else {
        y = SIZE_GAP_TOP;
        self.rankingFrame = CGRectZero;
    }
    
    // 头部
    CGFloat headerHeight = SIZE_HEADERWH;
    
    self.headerFrame = CGRectMake(x, y, headerHeight, headerHeight);
    
    y += headerHeight + SIZE_GAP_SMALL;
    x += SIZE_HEADERWH + SIZE_GAP_PADDING;
    
    // 昵称
    CGSize nameSize = [self.item.name boundingRectWithSize:CGSizeMake(CGFLOAT_MAX, CGFLOAT_MAX) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName: kFontWithSize(SIZE_FONT_NAME)} context:nil].size;
    self.nameLabelFrame = CGRectMake(x, self.headerFrame.origin.y, nameSize.width, nameSize.height);
    CGRectMake(x, SIZE_GAP_MARGIN, 0, 0);
    
    // job
    CGSize jobSize = [self.item.job boundingRectWithSize:CGSizeMake(CGFLOAT_MAX, CGFLOAT_MAX) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName: kFontWithSize(SIZE_FONT_SUBTITLE)} context:nil].size;
    self.jobLabelFrame = CGRectMake(x, CGRectGetMaxY(self.nameLabelFrame) + SIZE_GAP_SMALL, jobSize.width, jobSize.height);
    
    // 图片
    if (self.item.imgCount == 0) {
        self.picCollectionViewFrame = CGRectZero;
        y += 0;
    } else {
        CGSize picSize = [self caculatePicViewSize:self.item.imgCount];
        self.picCollectionViewFrame = CGRectMake(x, y, picSize.width, picSize.height);
        y += picSize.height + SIZE_PIC_BOTTOM;

    }
    
    // 视频图片
    CGFloat videoImgH = 0.0;
    if (self.item.videoImg.length == 0) {
        // 注意：有视频时，就没有图片，反之亦然
        videoImgH = 0.0;
        self.videoImgViewFrame = CGRectZero;
        y += 0;
    } else {
        videoImgH = 160.0;
        self.videoImgViewFrame = CGRectMake(x, y, self.contentWidth, videoImgH);
        y += videoImgH + SIZE_PIC_BOTTOM;
    }
    
    
    // 标题
    CGSize titleSize = CGSizeZero;
    if (self.item.title.length == 0) {
        self.title_labelFrame = CGRectZero;
        y += titleSize.height;
    } else {
        titleSize = [self.item.title boundingRectWithSize:CGSizeMake(self.contentWidth, MAXFLOAT) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName : kFontWithSize(SIZE_FONT_TITLE)} context:nil].size;
        self.title_labelFrame = CGRectMake(x, y, titleSize.width, titleSize.height);
        y += titleSize.height + SIZE_GAP_PADDING;
    }
    
   
    // 内容
    CGSize contentSize = CGSizeZero;
    if (self.item.content.length == 0) {
        self.contentLableFrame = CGRectZero;
        y += contentSize.height;
    } else {
        contentSize = [self.item.content boundingRectWithSize:CGSizeMake(self.contentWidth, MAXFLOAT) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName : kFontWithSize(SIZE_FONT_CONTENT)} context:nil].size;
        self.contentLableFrame = CGRectMake(x, y, contentSize.width, contentSize.height);
        y += contentSize.height + SIZE_PIC_BOTTOM;
    }
    
    // 浏览人数
    CGFloat readCountW = 80;
    CGFloat readCountH = 10;
    CGFloat readCountX = self.contentWidth - SIZE_GAP_MARGIN - 0;
    self.readCountBtnFrame = CGRectMake(readCountX, y, readCountW, readCountH);
    y += readCountH + SIZE_PIC_BOTTOM;
    
    // 工具条
    self.toolViewFrame = CGRectMake(x, y, self.contentWidth, SIZE_TOOLVIEWH);
    y += SIZE_TOOLVIEWH + SIZE_SEPARATORH;
    
    return y;
}



// 计算collectionView的尺寸
- (CGSize)caculatePicViewSize:(NSInteger)count {
    
    
    if (count == 0) {
        return CGSizeZero;
    }

    if (count == 1) {
        
        return CGSizeMake(self.picItemWH, self.picItemWH);
    }
    
    // 其他
    // 计算行数
    NSInteger rows = (count - 1) / 3 + 1;
    
    if (count == 4) {
        return CGSizeMake(self.picItemWH * 2 + SIZE_PICMARGIN, self.picItemWH * 2 + SIZE_PICMARGIN);
    }
    
    
    CGFloat picViewW = self.contentWidth;
    CGFloat picViewH = rows * self.picItemWH + (rows - 1) * SIZE_PICMARGIN;
    
    
    return CGSizeMake(picViewW, picViewH);
}

- (CGFloat)contentWidth {
    
    return kScreenW - SIZE_GAP_MARGIN * 2 - SIZE_HEADERWH - SIZE_GAP_PADDING;
}

- (CGFloat)picItemWH {
    
    if (self.item.imgCount == 0) {
        return 0;
    } else if (self.item.imgCount == 1) {
        return 150;
    }
    
    return (self.contentWidth - 2 * SIZE_PICMARGIN) / 3;
}



@end
