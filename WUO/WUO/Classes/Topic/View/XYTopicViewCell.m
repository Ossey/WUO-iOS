//
//  XYTopicViewCell.m
//  WUO
//
//  Created by mofeini on 17/1/2.
//  Copyright © 2017年 com.test.demo. All rights reserved.
//

#import "XYTopicViewCell.h"
#import <UIButton+WebCache.h>
#import "XYTopicViewModel.h"
#import "UIImage+XYExtension.h"
#import "XYPictureCollectionView.h"
#import "WUOLabel.h"
#import "NSString+WUO.h"
#import "WUOToolView.h"
#import "XYVideoImgView.h"
@class XYPictureCollectionViewLayout;
@interface XYTopicViewCell () {
    // 是否正在绘制中
    BOOL _isDrawing;
    // 标记绘制颜色
    NSInteger _drawColorFlag;
}

@property (strong, nonatomic)  UIImageView *postBGView;
@property (strong, nonatomic)  UIButton *investBtn;
@property (strong, nonatomic)  UIButton *avatarView;
@property (strong, nonatomic)  WUOLabel *title_label;
@property (strong, nonatomic)  WUOLabel *contentLabel;
@property (strong, nonatomic)  UIButton *readCountBtn;
@property (strong, nonatomic)  UILabel *jobLabel;
@property (strong, nonatomic)  XYPictureCollectionView *pictureCollectionView;
@property (strong, nonatomic)  WUOToolView *toolView;
@property (strong, nonatomic)  UIImageView *cornerImageView;
@property (strong, nonatomic)  XYVideoImgView *videoImgView;
@property (strong, nonatomic)  UILabel *rankingLabel;
@end

@implementation XYTopicViewCell

#pragma mark - 初始化方法
- (instancetype)initWithCoder:(NSCoder *)coder
{
    self = [super initWithCoder:coder];
    if (self) {
        //不透明，提升渲染性能
        self.contentView.opaque = YES;
        
        [self setup];
    }
    return self;
}

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        
        [self setup];
    }
    
    return self;
}

#pragma mark - 初始化控件

- (void)setup {
    
    self.clipsToBounds = YES;
    self.postBGView = [[UIImageView alloc] initWithFrame:CGRectZero];
    [self.contentView insertSubview:self.postBGView atIndex:0];
    
    // 头像
    self.avatarView = [UIButton buttonWithType:UIButtonTypeCustom];
    self.avatarView.backgroundColor = kColorGlobalCell;
    self.avatarView.hidden = NO;
    self.avatarView.tag = NSIntegerMax;
    self.avatarView.clipsToBounds = YES;
    [self.contentView addSubview:self.avatarView];
    [self.avatarView addTarget:self action:@selector(avatarViewClick) forControlEvents:UIControlEventTouchUpInside];
    
    // 镂空的圆形图片盖在头像上面，目的是让头像显示为圆形
    self.cornerImageView = [[UIImageView alloc] init];
    self.cornerImageView.center = self.avatarView.center;
    self.cornerImageView.image = [UIImage imageNamed:@"corner_circle"];
    self.cornerImageView.tag = NSIntegerMax;
    [self.contentView addSubview:self.cornerImageView];
    self.cornerImageView.userInteractionEnabled = YES;
    [self.cornerImageView addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(avatarViewClick)]];
    
    // 榜单
    self.rankingLabel = [UILabel new];
    [self.contentView addSubview:self.rankingLabel];
    self.rankingLabel.layer.cornerRadius = 16;
    [self.rankingLabel.layer setMasksToBounds:YES];
    self.rankingLabel.backgroundColor = kColorGlobalGreen;
    [self.rankingLabel setTextColor:[UIColor whiteColor]];
    [self.rankingLabel setTextAlignment:NSTextAlignmentCenter];
    // iOS中不支持中文字体倾斜，只有设置倾斜角度
    // 设置反射。倾斜15度
    CGAffineTransform matrix =  CGAffineTransformMake(1, 0, tanf(15 * (CGFloat)M_PI / 180), 1, 0, 0);
    // 取得系统字符并设置反射
    UIFontDescriptor *desc = [UIFontDescriptor fontDescriptorWithName:[UIFont systemFontOfSize:16 weight:1].fontName matrix:matrix];
    // 获取字体
    UIFont *font = [UIFont fontWithDescriptor:desc size:16];
    self.rankingLabel.font = font;
    
    // 投资按钮
    self.investBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [self.investBtn setTitle:@"投资" forState:UIControlStateNormal];
    [self.investBtn setBackgroundColor:[UIColor blackColor]];
    [self.investBtn.titleLabel setFont:kFontWithSize(13)];
    [self.contentView addSubview:self.investBtn];
    self.investBtn.layer.cornerRadius = 5;
    [self.investBtn.layer setMasksToBounds:YES];
    
    [self creatLabel];
    
    // 图片
    self.pictureCollectionView = [[XYPictureCollectionView alloc] initWithFrame:CGRectZero collectionViewLayout:[XYPictureCollectionViewLayout new]];
    self.pictureCollectionView.tag = NSIntegerMax;
    self.pictureCollectionView.hidden = YES;
    self.pictureCollectionView.backgroundColor = kColorGlobalCell;
    [self.contentView addSubview:self.pictureCollectionView];
    
    // 视频图片展示
    self.videoImgView = [[XYVideoImgView alloc] init];
    self.videoImgView.hidden = YES;
    self.videoImgView.tag = NSIntegerMax;
    self.imageView.contentMode = UIViewContentModeScaleAspectFill;
    self.videoImgView.backgroundColor = kColorLightGray;
    [self.contentView addSubview:self.videoImgView];
    
    // 底部工具条
    self.toolView = [[WUOToolView alloc] initWithFrame:self.viewModel.toolViewFrame];
    [self.contentView addSubview:_toolView];
    
    self.selectionStyle = UITableViewCellSelectionStyleNone;
}


- (void)creatLabel {
    
    if (self.title_label) {
        [self.title_label removeFromSuperview];
        self.title_label = nil;
    }
    
    /// 由于标题或正文中有时可能会有连接，需要点击事件，所以不去绘制
    // 标题
    self.title_label = [[WUOLabel alloc] initWithFrame:self.viewModel.title_labelFrame];
    self.title_label.textColor = kColorTitleText;
    self.title_label.text = @"标题";
    self.title_label.font = kFontWithSize(SIZE_FONT_TITLE);
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

- (void)layoutSubviews {
    [super layoutSubviews];
    
    self.avatarView.frame = self.viewModel.headerFrame;
    self.cornerImageView.frame = CGRectMake(0, 0, CGRectGetWidth(self.viewModel.headerFrame)+5, CGRectGetHeight(self.viewModel.headerFrame)+5);
    self.cornerImageView.center = self.avatarView.center;
    
    self.investBtn.xy_height = 26;
    self.investBtn.xy_width = 50;
    self.investBtn.xy_y = self.avatarView.xy_y;
    self.investBtn.xy_x = kScreenW - 50 - 15;
    
    self.readCountBtn.frame = self.viewModel.readCountBtnFrame;
    
    self.toolView.frame = self.viewModel.toolViewFrame;
    
    self.rankingLabel.frame = self.viewModel.rankingFrame;
}

#pragma mark - Events
- (void)avatarViewClick {
    
    if (self.delegate && [self.delegate respondsToSelector:@selector(topicViewCellDidSelectAvatarView: item:)]) {
        
        [self.delegate topicViewCellDidSelectAvatarView:self item:self.viewModel.item];
    }
}


#pragma mark - 绘制cell及主要控件

- (void)draw {
    
    if (_isDrawing) {
        return;
    }
    
    NSInteger flag = _drawColorFlag;
    _isDrawing = YES;
    dispatch_async(dispatch_get_global_queue(0, 0), ^{
        // 开启和cell大小相同的图形上下文
        // 当不透明度设置为YES时，底部会有1的黑色线条，如果需要线条设置为YES即可
        CGRect rect = self.viewModel.cellBounds;
        UIGraphicsBeginImageContextWithOptions(rect.size, YES, 0);
        CGContextRef context = UIGraphicsGetCurrentContext();
        [kColorGlobalCell set];
        CGContextFillRect(context, rect);
        
        // name
        [self.viewModel.item.name drawInContext:context withPosition:self.viewModel.nameLabelFrame.origin andFont:kFontWithSize(SIZE_FONT_NAME)
                                   andTextColor:kColorNameText
                                      andHeight:self.viewModel.nameLabelFrame.size.height];
        
        // job
        [self.viewModel.item.job drawInContext:context withPosition:self.viewModel.jobLabelFrame.origin andFont:kFontWithSize(SIZE_FONT_SUBTITLE) andTextColor:kColorJobText andHeight:self.viewModel.jobLabelFrame.size.height andWidth:self.viewModel.jobLabelFrame.size.width];
        
        
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
    
    // 当cell绘制完成后 再设置label
    [self drawText];
}

//将文本内容绘制到图片上
- (void)drawText {
    if (self.title_label==nil||self.contentLabel==nil) {
        [self creatLabel];
    }
    self.title_label.frame = self.viewModel.title_labelFrame;
    self.title_label.text = self.viewModel.item.title;
    if (self.viewModel.item.content.length) {
        self.contentLabel.frame = self.viewModel.contentLableFrame;
        self.contentLabel.text = self.viewModel.item.content;
        self.contentLabel.hidden = NO;
    }
}



- (void)clear {
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


#pragma mark - set \ get
- (void)setViewModel:(XYTopicViewModel *)viewModel {
    
    _viewModel = viewModel;
    
    XYTopicItem *item = viewModel.item;
    self.pictureCollectionView.dynamicItem = item;
    self.pictureCollectionView.hidden = item.imgCount == 0;
    
    [self.avatarView setBackgroundImage:nil forState:UIControlStateNormal];
    [self.avatarView sd_setBackgroundImageWithURL:item.headerImageURL forState:UIControlStateNormal placeholderImage:[UIImage imageNamed:@"mine_HeadImage"] options:SDWebImageLowPriority];
    
    self.videoImgView.viewModel = viewModel;
    
    self.jobLabel.text = item.job;
    
    
    self.jobLabel.hidden = !item.job.length;
    self.title_label.hidden = !item.title.length || item.title == nil || [item.title isEqualToString:@""];
    self.contentLabel.hidden = !item.content.length || item.content == nil || [item.title isEqualToString:@""];
    
    
    [self.readCountBtn setTitle:[NSString stringWithFormat:@"%ld人预览", item.readCount] forState:UIControlStateNormal];
    
    [self.toolView->_shareBtn setTitle:[NSString stringWithFormat:@"%ld", item.shareCount] forState:UIControlStateNormal];
    [self.toolView->_commentBtn setTitle:[NSString stringWithFormat:@"%ld", item.commentCount] forState:UIControlStateNormal];
    [self.toolView->_rewardBtn setTitle:[NSString stringWithFormat:@"%ld", item.rewardCount] forState:UIControlStateNormal];
    [self.toolView->_praiseBtn setTitle:[NSString stringWithFormat:@"%ld", item.praiseCount] forState:UIControlStateNormal];
    
    CGSize picViewSize = [self caculatePicViewSize:item.imgList.count];
    self.pictureCollectionView.frame = CGRectMake(viewModel.picCollectionViewFrame.origin.x, viewModel.picCollectionViewFrame.origin.y, picViewSize.width, picViewSize.height);
    
    [self.rankingLabel setText:viewModel.item.ranking];
    
    
    // 根据模型数据，显示点赞状态
    self.toolView->_praiseBtn.selected = viewModel.item.isPraise;
    
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

- (void)dealloc {
    NSLog(@"%s", __func__);
}


@end
