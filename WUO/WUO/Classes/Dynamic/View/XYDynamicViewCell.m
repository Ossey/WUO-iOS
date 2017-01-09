//
//  XYDynamicViewCell.m
//  WUO
//
//  Created by mofeini on 17/1/2.
//  Copyright © 2017年 com.test.demo. All rights reserved.
//

#import "XYDynamicViewCell.h"
#import <UIButton+WebCache.h>
//#import <UIImageView+WebCache.h>
#import "XYDynamicViewModel.h"
#import "UIImage+XYExtension.h"
#import "XYPictureCollectionView.h"
#import "WUOLabel.h"
#import "NSString+WUO.h"
#import "WUOToolView.h"
#import "XYVideoImgView.h"
@class XYPictureCollectionViewLayout;
@interface XYDynamicViewCell () {
    // 是否正在绘制中
    BOOL _isDrawing;
    // 标记绘制颜色
    NSInteger _drawColorFlag;
//    CGRect _readFrame;
//    CGRect _shareCountRect;
//    CGRect _commentCountRect;
//    CGRect _rewardCountRect;
//    CGRect _praiseCountRect;
}

@property (strong, nonatomic)  UIImageView *postBGView;
@property (strong, nonatomic)  UIButton *investBtn;
@property (strong, nonatomic)  UIButton *headerView;
//@property (strong, nonatomic)  UILabel *nameLabel;
@property (strong, nonatomic)  WUOLabel *title_label;
@property (strong, nonatomic)  WUOLabel *contentLabel;
@property (strong, nonatomic)  UIButton *readCountBtn;
@property (strong, nonatomic)  UILabel *jobLabel;
@property (strong, nonatomic)  XYPictureCollectionView *pictureCollectionView;
@property (strong, nonatomic)  WUOToolView *toolView;
@property (strong, nonatomic)  UIImageView *cornerImageView;
@property (strong, nonatomic)  XYVideoImgView *videoImgView;

@end

@implementation XYDynamicViewCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        
        [self setup];
    }
    
    return self;
}

- (void)setup {
    
    self.clipsToBounds = YES;
    self.postBGView = [[UIImageView alloc] initWithFrame:CGRectZero];
    [self.contentView insertSubview:self.postBGView atIndex:0];
    
    // 头像
    self.headerView = [UIButton buttonWithType:UIButtonTypeCustom];
    self.headerView.frame = CGRectMake(SIZE_GAP_MARGIN, SIZE_GAP_TOP, SIZE_HEADERWH, SIZE_HEADERWH);
    self.headerView.backgroundColor = [UIColor colorWithRed:250/255.0 green:250/255.0 blue:250/255.0 alpha:1];
    self.headerView.hidden = NO;
    self.headerView.tag = NSIntegerMax;
    self.headerView.clipsToBounds = YES;
    [self.contentView addSubview:self.headerView];
    
    // 圆形图片，目的是让头像显示为圆形
    self.cornerImageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, SIZE_HEADERWH+5, SIZE_HEADERWH+5)];
    self.cornerImageView.center = self.headerView.center;
    self.cornerImageView.image = [UIImage imageNamed:@"corner_circle"];
    self.cornerImageView.tag = NSIntegerMax;
    [self.contentView addSubview:self.cornerImageView];
    
    // 投资按钮
    self.investBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    self.investBtn.xy_height = 26;
    self.investBtn.xy_width = 50;
    self.investBtn.xy_y = self.headerView.xy_y;
    self.investBtn.xy_x = kScreenW - 50 - 15;
    [self.investBtn setTitle:@"投资" forState:UIControlStateNormal];
    [self.investBtn setBackgroundColor:[UIColor blackColor]];
    [self.investBtn.titleLabel setFont:kFontWithSize(13)];
    [self.contentView addSubview:self.investBtn];
    self.investBtn.layer.cornerRadius = 5;
    [self.investBtn.layer setMasksToBounds:YES];
    
    [self addLabel];
    
    // 图片
    self.pictureCollectionView = [[XYPictureCollectionView alloc] initWithFrame:CGRectZero collectionViewLayout:[XYPictureCollectionViewLayout new]];
    self.pictureCollectionView.tag = NSIntegerMax;
    self.pictureCollectionView.hidden = YES;
    self.pictureCollectionView.backgroundColor = [self getBackgroundColor];
    [self.contentView addSubview:self.pictureCollectionView];
    
    // 视频图片展示
    self.videoImgView = [[XYVideoImgView alloc] init];
    self.videoImgView.hidden = YES;
    self.videoImgView.tag = NSIntegerMax;
    self.imageView.contentMode = UIViewContentModeScaleAspectFill;
    self.videoImgView.backgroundColor = [self getBackgroundColor];
    [self.contentView addSubview:self.videoImgView];
    
    // 阅读数量
//    self.readCountBtn = [UIButton buttonWithType:UIButtonTypeCustom];
//    [self.readCountBtn setTitleColor:kColorCountText forState:UIControlStateNormal];
//    [self.readCountBtn setImage:[UIImage imageNamed:@"Home_trendsReadCount"] forState:UIControlStateNormal];
//    [self.readCountBtn setTitle:@"0人预览" forState:UIControlStateNormal];
//    [self.readCountBtn.titleLabel setFont:kFontWithSize(8)];
//    [self.contentView addSubview:self.readCountBtn];
    
    // 底部工具条
    self.toolView = [[WUOToolView alloc] initWithFrame:self.viewModel.toolViewFrame];
    [self.contentView addSubview:_toolView];
    
    self.selectionStyle = UITableViewCellSelectionStyleNone;
}


- (void)setViewModel:(XYDynamicViewModel *)viewModel {
    
    _viewModel = viewModel;
    
    XYDynamicItem *item = viewModel.item;
    self.pictureCollectionView.dynamicItem = item;
    self.pictureCollectionView.hidden = item.imgCount == 0;
    
    [self.headerView setBackgroundImage:nil forState:UIControlStateNormal];
    [self.headerView sd_setBackgroundImageWithURL:item.headerImageURL forState:UIControlStateNormal placeholderImage:[UIImage imageNamed:@"mine_HeadImage"] options:SDWebImageLowPriority];
    
    self.videoImgView.viewModel = viewModel;
    
    self.jobLabel.text = item.job;
//    self.nameLabel.text = item.name;

    self.jobLabel.hidden = !item.job.length;
    self.title_label.hidden = !item.title.length || item.title == nil || [item.title isEqualToString:@""];
    self.contentLabel.hidden = !item.content.length || item.content == nil || [item.title isEqualToString:@""];
    
    self.readCountBtn.frame = viewModel.readCountBtnFrame;
    [self.readCountBtn setTitle:[NSString stringWithFormat:@"%ld人预览", item.readCount] forState:UIControlStateNormal];
    
    [self.toolView->_shareBtn setTitle:[NSString stringWithFormat:@"%ld", item.shareCount] forState:UIControlStateNormal];
    [self.toolView->_commentBtn setTitle:[NSString stringWithFormat:@"%ld", item.commentCount] forState:UIControlStateNormal];
    [self.toolView->_rewardBtn setTitle:[NSString stringWithFormat:@"%ld", item.rewardCount] forState:UIControlStateNormal];
    [self.toolView->_praiseBtn setTitle:[NSString stringWithFormat:@"%ld", item.praiseCount] forState:UIControlStateNormal];
    
    
    self.toolView.frame = viewModel.toolViewFrame;
    
    
    CGSize picViewSize = [self caculatePicViewSize:item.imgList.count];
    self.pictureCollectionView.frame = CGRectMake(viewModel.picCollectionViewFrame.origin.x, viewModel.picCollectionViewFrame.origin.y, picViewSize.width, picViewSize.height);
    
}



- (void)addLabel {
    
    if (self.title_label) {
        [self.title_label removeFromSuperview];
        self.title_label = nil;
    }
    
    /// 由于标题或正文中有时可能会有连接，需要点击事件，所以不去绘制
    // 标题
    self.title_label = [[WUOLabel alloc] initWithFrame:self.viewModel.title_labelFrame];
    self.title_label.textColor = kColorTitleText;
    self.title_label.text = @"标题";
    
    self.contentLabel.font = kFontWithSize(SIZE_FONT_TITLE);
    [self.contentView addSubview:self.title_label];
    
    if (self.contentLabel) {
        [self.contentLabel removeFromSuperview];
        self.contentLabel = nil;
    }
    // 正文
    self.contentLabel = [[WUOLabel alloc] initWithFrame:self.viewModel.title_labelFrame];
    self.contentLabel.text = @"内容";
    self.contentLabel.font = kFontWithSize(SIZE_FONT_CONTENT);
    self.contentLabel.textColor = kColorContentText;
    [self.contentView addSubview:self.contentLabel];
}


- (instancetype)initWithCoder:(NSCoder *)coder
{
    self = [super initWithCoder:coder];
    if (self) {
        //不透明，提升渲染性能
        self.contentView.opaque = YES;
    }
    return self;
}

- (void)draw {
    
    if (_isDrawing) {
        return;
    }
    
    NSInteger flag = _drawColorFlag;
    _isDrawing = YES;
    dispatch_async(dispatch_get_global_queue(0, 0), ^{
        // cell frame
        CGRect rect = self.viewModel.cellBounds;
        UIGraphicsBeginImageContextWithOptions(rect.size, YES, 0);
        CGContextRef context = UIGraphicsGetCurrentContext();
        [[self getBackgroundColor] set];
        CGContextFillRect(context, rect);
        
        // name
        float leftX = SIZE_GAP_MARGIN+SIZE_HEADERWH+SIZE_GAP_PADDING;
        float x = leftX;
        float y = (SIZE_HEADERWH-(SIZE_FONT_NAME+SIZE_FONT_SUBTITLE+6))/2-2+SIZE_GAP_TOP+SIZE_GAP_SMALL-5;
        [self.viewModel.item.name drawInContext:context withPosition:CGPointMake(x, y) andFont:kFontWithSize(SIZE_FONT_NAME)
                                   andTextColor:[UIColor colorWithRed:106/255.0 green:140/255.0 blue:181/255.0 alpha:1]
                                      andHeight:rect.size.height];
        y += SIZE_FONT_NAME+5;
        
        // job
        float fromX = leftX;
        float size = kScreenW-leftX;
        [self.viewModel.item.job drawInContext:context withPosition:CGPointMake(fromX, y) andFont:kFontWithSize(SIZE_FONT_SUBTITLE) andTextColor:kColorJobText andHeight:rect.size.height andWidth:size];
        
    
        
        
//        // 播放按钮，当有视频时才需要绘制, 这样产生的问题: 绘制的图片被videoImgView遮住了
//        if (self.videoImgView.hidden == NO) {
//            CGSize size = CGSizeMake(40, 40);
//            CGPoint point = CGPointMake((CGRectGetWidth(self.viewModel.videoImgViewFrame) - size.width) * 0.5, (CGRectGetHeight(self.viewModel.videoImgViewFrame) - size.height) * 0.5);
//            
//            [[UIImage imageNamed:@"dynamic_listPlayerVideo"] drawInRect:CGRectMake(point.x, point.y, size.width, size.height) blendMode:kCGBlendModeNormal alpha:1.0];
//        }
        
        // read
        float readCounX = kScreenW - self.investBtn.frame.size.width - SIZE_GAP_MARGIN - SIZE_GAP_MARGIN;
        
        NSString *readCountStr = [NSString stringWithFormat:@"%ld人预览", self.viewModel.item.readCount];
        CGSize readCounSize = [readCountStr sizeWithConstrainedToSize:CGSizeMake(CGFLOAT_MAX, CGFLOAT_MAX) fromFont:kFontWithSize(8) lineSpace:5];
        
        readCounX += readCounSize.width;
        [readCountStr drawInContext:context withPosition:CGPointMake(readCounX, self.viewModel.readCountBtnFrame.origin.y)
                            andFont:kFontWithSize(8)
                       andTextColor:kColorReadCountText
                          andHeight:rect.size.height];
 
        CGFloat readCountViewW = 16;
        [[UIImage imageNamed:@"Home_trendsReadCount"] drawInRect:CGRectMake(readCounX - readCountViewW, 1.5 + self.viewModel.readCountBtnFrame.origin.y, readCountViewW, readCounSize.height) blendMode:kCGBlendModeNormal alpha:1.0];
        
        UIImage *temp = UIGraphicsGetImageFromCurrentImageContext();
        UIGraphicsEndImageContext();
        dispatch_async(dispatch_get_main_queue(), ^{
            if (flag==_drawColorFlag) {
                self.postBGView.frame = rect;
                self.postBGView.image = nil;
                self.postBGView.image = temp;
            }
        });
    });
    
    [self drawText];
}

//将文本内容绘制到图片上
- (void)drawText{
    if (self.title_label==nil||self.contentLabel==nil) {
        [self addLabel];
    }
    self.title_label.frame = self.viewModel.title_labelFrame;
    self.title_label.text = self.viewModel.item.title;
    if (self.viewModel.item.content.length) {
        self.contentLabel.frame = self.viewModel.contentLableFrame;
        self.contentLabel.text = self.viewModel.item.content;
        self.contentLabel.hidden = NO;
    }
}

- (void)clear{
    if (!_isDrawing) {
        return;
    }
    self.postBGView.frame = CGRectZero;
    self.postBGView.image = nil;
    [self.title_label clear];
    if (!self.contentLabel.hidden) {
        self.contentLabel.hidden = YES;
        [self.contentLabel clear];
    }

    _drawColorFlag = arc4random();
    _isDrawing = NO;
}

- (void)releaseMemory {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    [self clear];
    [super removeFromSuperview];
}



- (void)setFrame:(CGRect)frame {
    
    frame.size.height -= SIZE_SEPARATORH;
    [super setFrame:frame];
}



// 计算collectionView的尺寸
- (CGSize)caculatePicViewSize:(NSInteger)count {
    
    CGFloat itemWH = 0.0;
    CGFloat itemMargin = 5;
    
    if (count == 0) {
        return CGSizeZero;
    }
    
    UICollectionViewFlowLayout *layout = (UICollectionViewFlowLayout *)self.pictureCollectionView.collectionViewLayout;
    
    
    if (count == 1) {
        itemWH = 150;
        layout.itemSize = CGSizeMake(itemWH, itemWH);
        return CGSizeMake(itemWH, itemWH);
    }
    
    // 其他
    // 计算行数
    NSInteger rows = (count - 1) / 3 + 1;

    CGFloat contentWidth = SIZE_CONTENT_W;
    
    itemWH = (contentWidth - 2 * itemMargin) / 3;
    
    if (count == 4) {
        layout.itemSize = CGSizeMake(itemWH, itemWH);
        return CGSizeMake(itemWH * 2 + itemMargin, itemWH * 2 + itemMargin);
    }

    layout.itemSize = CGSizeMake(itemWH, itemWH);
    
    CGFloat picViewW = contentWidth;
    CGFloat picViewH = rows * itemWH + (rows - 1) * itemMargin;
    
    
    return CGSizeMake(picViewW, picViewH);
}



- (UIColor *)getBackgroundColor {
    
    return [UIColor colorWithRed:250/255.0 green:250/255.0 blue:250/255.0 alpha:1];
}

@end
