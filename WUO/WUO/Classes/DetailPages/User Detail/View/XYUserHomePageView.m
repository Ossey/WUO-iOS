//
//  XYUserHomePageView.m
//  WUO
//
//  Created by mofeini on 17/1/12.
//  Copyright © 2017年 com.test.demo. All rights reserved.
//

#import "XYUserHomePageView.h"
#import "XYUserInfo.h"

@implementation XYUserHomePageView {
    
    UIView *_containerView;
    
    // 名称
    /** WUOh号 */
    UILabel *_uidLabel;
    /** 昵称 */
    UILabel *_nameLabel;
    /** 性别 */
    UILabel *_genderLabel;
    /** 年龄 */
    UILabel *_ageLabel;
    /** 兴趣/职业 */
    UILabel *_jobLabel;
    /** 个性签名 */
    UILabel *_descriptionLabel;
    /** 个人标签 */
    UILabel *_labelLabel;
    
    // 内容
    /** WUOh号 */
    UILabel *_uidContentLabel;
    /** 昵称 */
    UILabel *_nameContentLabel;
    /** 性别 */
    UILabel *_genderContentLabel;
    /** 年龄 */
    UILabel *_ageContentLabel;
    /** 兴趣/职业 */
    UILabel *_jobContentLabel;
    /** 个人标签 */
    UIView *_labelContentView;
    /** 个性签名 */
    UILabel *_descriptionContentLabel;


}


- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        [self setupUI];
        self.contentView.backgroundColor = [UIColor whiteColor];
        self.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    return self;
}


#pragma mark - 属性设置

- (void)setUserInfo:(XYUserInfo *)userInfo {
    _userInfo = userInfo;
    
    _uidContentLabel.text = [NSString stringWithFormat:@"%ld", userInfo.uid];
    _nameContentLabel.text = userInfo.name;
    _genderContentLabel.text = userInfo.genderText;
    _ageContentLabel.text = [NSString stringWithFormat:@"%ld", userInfo.age];
    _jobContentLabel.text = userInfo.job;
    _descriptionContentLabel.text = userInfo.descriptionText;
}

#pragma mark - 控件初始化及界面布局

- (void)setupUI {
    [self addSubview];
    
}

- (void)addSubview {
    
    _containerView = [UIView new];
    [self.contentView addSubview:_containerView];
    _containerView.backgroundColor = kColorLightGray;
    
    _uidLabel = [XYUserHomePageViewLabel new];
    [_containerView addSubview:_uidLabel];
    _uidLabel.text = @"WUO号";
    _nameLabel = [XYUserHomePageViewLabel new];
    [_containerView addSubview:_nameLabel];
    _nameLabel.text = @"昵称";
    _genderLabel = [XYUserHomePageViewLabel new];
    [_containerView addSubview:_genderLabel];
    _genderLabel.text = @"性别";
    _ageLabel = [XYUserHomePageViewLabel new];
    [_containerView addSubview:_ageLabel];
    _ageLabel.text = @"年龄";
    _jobLabel = [XYUserHomePageViewLabel new];
    [_containerView addSubview:_jobLabel];
    _jobLabel.text = @"兴趣/职业";
    _labelLabel = [XYUserHomePageViewLabel new];
    [_containerView addSubview:_labelLabel];
    _labelLabel.text = @"个人标签";
    _descriptionLabel = [XYUserHomePageViewLabel new];
    [_containerView addSubview:_descriptionLabel];
    _descriptionLabel.text = @"个性签名";
    
    _uidContentLabel = [XYUserHomePageViewContentLabel new];
    [_containerView addSubview:_uidContentLabel];
    _nameContentLabel = [XYUserHomePageViewContentLabel new];
    [_containerView addSubview:_nameContentLabel];
    _genderContentLabel = [XYUserHomePageViewContentLabel new];
    [_containerView addSubview:_genderContentLabel];
    _ageContentLabel = [XYUserHomePageViewContentLabel new];
    [_containerView addSubview:_ageContentLabel];
    _jobContentLabel = [XYUserHomePageViewContentLabel new];
    [_containerView addSubview:_jobContentLabel];
    _labelContentView = [UIView new];
    _labelContentView.backgroundColor = [UIColor whiteColor];
    [_containerView addSubview:_labelContentView];
    _descriptionContentLabel = [XYUserHomePageViewContentLabel new];
    [_containerView addSubview:_descriptionContentLabel];
    _descriptionContentLabel.textAlignment = NSTextAlignmentLeft;
    
}

- (void)layoutSubviews {
    [super layoutSubviews];
    [self makeConstraints];
}

- (void)makeConstraints {
    
    [_containerView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.contentView).mas_offset(SIZE_GAP_MARGIN);
        make.right.top.bottom.equalTo(self.contentView);
    }];
    
    CGFloat padding = 0.5;
    CGFloat width = 100;
    
    [_uidLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(_containerView);
        make.top.equalTo(_containerView);
        make.width.equalTo(@(width));
    }];
    
    [_nameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(_containerView);
        make.top.equalTo(_uidLabel.mas_bottom).mas_offset(padding);
        make.height.equalTo(_uidLabel);
        make.width.equalTo(@(width));
    }];
    
    [_genderLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(_containerView);
        make.top.equalTo(_nameLabel.mas_bottom).mas_offset(padding);
        make.height.equalTo(_uidLabel);
        make.width.equalTo(@(width));
    }];
    
    [_ageLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(_containerView);
        make.top.equalTo(_genderLabel.mas_bottom).mas_offset(padding);
        make.height.equalTo(_uidLabel);
        make.width.equalTo(@(width));
    }];
    
    [_jobLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(_containerView);
        make.top.equalTo(_ageLabel.mas_bottom).mas_offset(padding);
        make.height.equalTo(_uidLabel);
        make.width.equalTo(@(width));
    }];
    
    [_labelLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(_containerView);
        make.top.equalTo(_jobLabel.mas_bottom).mas_offset(padding);
        make.height.equalTo(_uidLabel);
        
    }];
    
    [_labelContentView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(_containerView);
        make.top.equalTo(_labelLabel.mas_bottom);
        make.height.equalTo(_uidLabel);
    }];
    
    [_descriptionLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(_containerView);
        make.top.equalTo(_labelContentView.mas_bottom).mas_offset(padding);
        make.height.equalTo(_uidLabel);
    }];
 
    
    [_descriptionContentLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(_containerView);
        make.top.equalTo(_descriptionLabel.mas_bottom);
        make.bottom.equalTo(_containerView).mas_offset(-padding);
        make.height.equalTo(_uidLabel);
    }];
    
    
    [_uidContentLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(_containerView);
        make.top.bottom.equalTo(_uidLabel);
        make.left.equalTo(_uidLabel.mas_right);

    }];
    
    [_nameContentLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(_containerView);
        make.top.bottom.equalTo(_nameLabel);
        make.left.equalTo(_nameLabel.mas_right);

    }];
    
    [_genderContentLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(_containerView);
        make.top.bottom.equalTo(_genderLabel);
        make.left.equalTo(_genderLabel.mas_right);

    }];
    
    [_ageContentLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(_containerView);
        make.top.bottom.equalTo(_ageLabel);
        make.left.equalTo(_ageLabel.mas_right);

    }];
    
    [_jobContentLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(_containerView);
        make.top.bottom.equalTo(_jobLabel);
        make.left.equalTo(_jobLabel.mas_right);

    }];
    

}


@end


@implementation XYUserHomePageViewLabel

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.textColor = kColorLightGray;
        self.font = kFontWithSize(14);
        self.textAlignment = NSTextAlignmentLeft;
        self.backgroundColor = [UIColor whiteColor];
    }
    return self;
}

@end


@implementation XYUserHomePageViewContentLabel {
    UIEdgeInsets _insets;
}

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        
        self.textColor = kColorNameTextBlack;
        self.font = kFontWithSize(15);
        self.textAlignment = NSTextAlignmentRight;
        self.backgroundColor = [UIColor whiteColor];
        // 让文本向左偏移15的距离
        _insets = UIEdgeInsetsMake(0.0f, 0.0f, 0.0f, 15.0f);

    }
    return self;
}

- (void)drawTextInRect:(CGRect)rect {
    [super drawTextInRect:UIEdgeInsetsInsetRect(rect, _insets)];
}

//- (void)setText:(NSString *)text {
//    
//    text = [text stringByAppendingString:@"   1"];
//    [super setText:text];
//}

@end
