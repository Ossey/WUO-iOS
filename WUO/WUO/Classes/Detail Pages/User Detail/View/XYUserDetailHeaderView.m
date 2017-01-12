//
//  XYUserDetailHeaderView.m
//  WUO
//
//  Created by mofeini on 17/1/11.
//  Copyright © 2017年 com.test.demo. All rights reserved.
//

#import "XYUserDetailHeaderView.h"
#import <UIButton+WebCache.h>
#import "XYUserInfo.h"

@implementation XYUserDetailHeaderView {
    UIButton *_avaterView;
    UILabel *_nameLabel;
    UILabel *_descriptionLabel;
    UIButton *_fansBtn;
    UILabel *_fansCountLabel;
    UIButton *_followBtn;
    UILabel *_followCountLabel;
    UIButton *_investBtn;
    UILabel *_invesCountLabel;
    UIButton *_followRequestBtn;
    UIButton *_investRequestBtn;;
}

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        
        [self setup];
    }
    return self;
}


- (void)setUserInfo:(XYUserInfo *)userInfo {
    _userInfo = userInfo;
    
    [_avaterView sd_setBackgroundImageWithURL:userInfo.headFullURL forState:UIControlStateNormal placeholderImage:nil options:SDWebImageHighPriority];
    
    _nameLabel.text = userInfo.name;
    _descriptionLabel.text = userInfo.descriptionText;
    _fansCountLabel.text = [NSString stringWithFormat:@"%ld", userInfo.fansCount];
    _fansCountLabel.text = [NSString stringWithFormat:@"%ld", userInfo.fansCount];
    _followCountLabel.text = [NSString stringWithFormat:@"%ld", userInfo.followCount];
    _invesCountLabel.text = [NSString stringWithFormat:@"%ld", userInfo.gmCount];
    
    _followRequestBtn.selected = userInfo.isFollow;
}

#pragma mark - 初始化控件
- (void)setup {
    
    _avaterView = [UIButton buttonWithType:UIButtonTypeCustom];
    _avaterView.layer.cornerRadius = SIZE_USER_DETAIL_AVATER_WH * 0.5;
    _avaterView.layer.masksToBounds = YES;
    _avaterView.layer.shouldRasterize = YES;
//    _avaterView.backgroundColor = [UIColor redColor];
    [self addSubview:_avaterView];
    
    _nameLabel = [[UILabel alloc] init];
//    _nameLabel.text = @"女痞Diana";
    _nameLabel.textAlignment = NSTextAlignmentCenter;
    _nameLabel.font = kFontWithSize(SIZE_FONT_NAME);
    [self addSubview:_nameLabel];
    
    _descriptionLabel = [[UILabel alloc] init];
    _descriptionLabel.text = @"暂无个人签名";
    _descriptionLabel.font = kFontWithSize(SIZE_FONT_USER_DETAIL_DESCRIPTION);
    _descriptionLabel.textAlignment = NSTextAlignmentCenter;
    _descriptionLabel.textColor = kColorDescriptionGray;
    [self addSubview:_descriptionLabel];
    
    _fansBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [_fansBtn setTitle:@"粉丝" forState:UIControlStateNormal];
    _fansBtn.titleLabel.font = kFontWithSize(SIZE_FONT_USER_DETAIL_COUNT);
    [_fansBtn setTitleColor:kColorNameTextBlack forState:UIControlStateNormal];
    [self addSubview:_fansBtn];

    _fansCountLabel = [[UILabel alloc] init];
    _fansCountLabel.text = @"0";
    _fansCountLabel.textAlignment = NSTextAlignmentCenter;
    _fansCountLabel.font = kFontWithSize(SIZE_FONT_USER_DETAIL_COUNT);
    [self addSubview:_fansCountLabel];

    _followBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [_followBtn setTitle:@"关注" forState:UIControlStateNormal];
    _followBtn.titleLabel.font = kFontWithSize(SIZE_FONT_USER_DETAIL_COUNT);
    [_followBtn setTitleColor:kColorNameTextBlack forState:UIControlStateNormal];
    [self addSubview:_followBtn];
    
    _followCountLabel = [[UILabel alloc] init];
    _followCountLabel.text = @"0";
    _followCountLabel.textAlignment = NSTextAlignmentCenter;
    _followCountLabel.font = kFontWithSize(SIZE_FONT_USER_DETAIL_COUNT);
    [self addSubview:_followCountLabel];
   
    _investBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [_investBtn setTitle:@"投资" forState:UIControlStateNormal];
    _investBtn.titleLabel.font = kFontWithSize(SIZE_FONT_USER_DETAIL_COUNT);
    [_investBtn setTitleColor:kColorNameTextBlack forState:UIControlStateNormal];
    [self addSubview:_investBtn];
    
    _invesCountLabel = [[UILabel alloc] init];
    _invesCountLabel.text = @"0";
    _invesCountLabel.font = kFontWithSize(SIZE_FONT_USER_DETAIL_COUNT);
    _invesCountLabel.textAlignment = NSTextAlignmentCenter;
    [self addSubview:_invesCountLabel];
    
    _followRequestBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [_followRequestBtn setTitle:@"关注" forState:UIControlStateNormal];
    [_followRequestBtn setTitle:@"已关注" forState:UIControlStateSelected];
    _followRequestBtn.titleLabel.font = kFontWithSize(SIZE_FONT_NAME);
    _followRequestBtn.titleLabel.textColor = [UIColor whiteColor];
    _followRequestBtn.backgroundColor = [UIColor blackColor];
    _followRequestBtn.layer.cornerRadius = 8;
    [_followRequestBtn.layer setMasksToBounds:YES];
//    _followRequestBtn.layer.shouldRasterize = YES;
    [self addSubview:_followRequestBtn];
    
    _investRequestBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [_investRequestBtn setTitle:@"投资" forState:UIControlStateNormal];
    [_investRequestBtn setTitle:@"投资" forState:UIControlStateSelected];
    _investRequestBtn.titleLabel.font = kFontWithSize(SIZE_FONT_NAME);
    _investRequestBtn.titleLabel.textColor = [UIColor whiteColor];
    _investRequestBtn.backgroundColor = [UIColor blackColor];
    _investRequestBtn.layer.cornerRadius = 8;
    [_investRequestBtn.layer setMasksToBounds:YES];
//    _investRequestBtn.layer.shouldRasterize = YES;
    [self addSubview:_investRequestBtn];
 }

- (void)layoutSubviews {
    [super layoutSubviews];
    
    [_avaterView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self);
        make.top.equalTo(self).mas_offset(SIZE_USER_DETAIL_TOP);
        make.width.height.mas_equalTo(SIZE_USER_DETAIL_AVATER_WH);
    }];
    
    [_nameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self);
        make.top.equalTo(_avaterView.mas_bottom).mas_offset(SIZE_USER_DETAIL_PADDING);
    }];
    
    [_descriptionLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self);
        make.top.equalTo(_nameLabel.mas_bottom).mas_offset(SIZE_USER_DETAIL_PADDING);
    }];
    
    CGFloat followRequestBtnW = (kScreenW - 2 * 50) * 0.5;
    CGFloat followRequestBtnH = 30;
    [_followRequestBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.equalTo(@(followRequestBtnW));
        make.height.equalTo(@(followRequestBtnH));
        make.right.equalTo(self.mas_centerX).mas_offset(-3);
        make.bottom.equalTo(self).mas_offset(-SIZE_USER_DETAIL_PADDING);
    }];
    
    [_investRequestBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.equalTo(_followRequestBtn);
        make.height.equalTo(_followRequestBtn);
        make.left.equalTo(self.mas_centerX).mas_offset(3);
        make.bottom.equalTo(_followRequestBtn);
    }];
    
    [_followBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self);
        make.bottom.equalTo(_followRequestBtn.mas_top).mas_offset(-SIZE_USER_DETAIL_PADDING);
    }];
    [_followCountLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self);
        make.bottom.equalTo(_followBtn.mas_top).mas_offset(-2);
    }];
    
    [_investBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.mas_equalTo(self.mas_centerX).mas_offset(SIZE_USER_DETAIL_leftCentXMargin);
        make.width.top.bottom.equalTo(_followBtn);
    }];
    
    [_fansCountLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(_fansBtn);
        make.bottom.top.width.equalTo(_followCountLabel);
    }];

    [_fansBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.mas_equalTo(self.mas_centerX).mas_offset(-SIZE_USER_DETAIL_leftCentXMargin);
        make.width.top.bottom.equalTo(_followBtn);
    }];
    
    [_invesCountLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(_investBtn);
        make.bottom.top.equalTo(_fansCountLabel);
    }];
}
@end
