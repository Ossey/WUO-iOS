//
//  XYCateTitleView.m
//  PandaTVHomeDemo
//
//  Created by mofeini on 16/12/8.
//  Copyright © 2016年 com.test.demo. All rights reserved.
//  分类标题内容视图

#import "XYCateTitleView.h"
#import <objc/runtime.h>

//NSString *const cname = @"cname";
//NSString *const ename = @"ename";


@interface XYCateTitleView () <UIScrollViewDelegate>

/** 右侧按钮 */
@property (nonatomic, weak) UIButton *rightButton;
/** 分类标题内容视图 */
@property (nonatomic, weak) UIScrollView *cateTitleView;
/** 底部分割线 */
@property (nonatomic, weak) UIImageView *separatorView;
/** 存放标题按钮的数组 */
@property (nonatomic, strong) NSMutableArray<UIButton *> *items;
/** 记录上次选中的按钮 */
@property (nonatomic, strong) UIButton *previousSelectedBtn;
/** 记录当前选中的按钮 */
@property (nonatomic, strong) UIButton *currentSelectBtn;
/** 下划线 */
@property (nonatomic, weak) UIImageView *underLine;
/** 根据按钮中label的文字计算按钮中label的宽度 */
@property (nonatomic, assign) CGFloat btnContentWidth;
/** 按钮中label的宽度的计算属性 */
@property (nonatomic, assign) CGFloat btnContentMargin;
/** 当有新的频道分类数组时，将之前的保存在这个数组中 */
@property (nonatomic, strong) NSMutableArray<NSDictionary *> *previousChannelCates;
/** 上次选中按钮的索引，为了让频道选择界面返回时，还默认选中上次的索引 */
@property (nonatomic, assign) NSInteger previousSelectItemIndex;
@property (nonatomic, assign) NSInteger currentSelectItemIndex;
@property (nonatomic, assign) CGFloat rightBtnWidth;

@end

@implementation XYCateTitleView {
    bool _isFirst; // 根据此属性，让第一次点击按钮时没有动画产生
}

@synthesize titleItemFont = _titleItemFont;
@synthesize itemScale = _itemScale;
@synthesize currentItemBackgroundColor = _currentItemBackgroundColor;
@synthesize otherItemBackgroundColor = _otherItemBackgroundColor;
@synthesize underLineBackgroundColor = _underLineBackgroundColor;
@synthesize underLineImage = _underLineImage;
@synthesize separatorBackgroundColor = _separatorBackgroundColor;
@synthesize separatorImage = _separatorImage;
@synthesize channelCates = _channelCates;
@synthesize selectedIndex = _selectedIndex;
@synthesize itemWidth = _itemWidth;


#pragma mark - 指定的构造函数
- (instancetype)initWithFrame:(CGRect)frame delegate:(id)delegate
                 channelCates:(NSArray<NSDictionary *> *)channelCates
                rightBtnWidth:(CGFloat)rightBtnWidth {
    
    if (self = [super initWithFrame:frame]) {
        self.delegate = delegate;
        self.rightBtnWidth = rightBtnWidth;
        self.channelCates = [channelCates mutableCopy];
        self.separatorView.hidden = NO;
    }
    
    return self;
}


#pragma mark - 设置所有的子标题
- (void)reloadSubviews {
    
    self.cateTitleView.hidden = NO;
    self.rightButton.hidden = NO;
    _isFirst = true;
    
    /// 判断上一次的频道分类数组内容与当前数组是否发生改变
#warning TODO 未实现
//    [self checkIsChangeInArrayCallBack:^(BOOL isChange, NSArray *changeAarr) {
//        NSLog(@"%d--%@", isChange, changeAarr);
//    }];
    
    for (NSInteger i = 0; i < self.items.count; ++i) {
        UIButton *btn = self.items[i];
        [btn removeFromSuperview];
    }
    
    [self.underLine removeFromSuperview];
    [self.items removeAllObjects];
    
    NSInteger count = self.channelCates.count;
    CGFloat x = 0;
    
    for (NSInteger i = 0; i < count; i++) {
        
        UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
        x = i * self.itemWidth;
        button.frame = CGRectMake(x, 0, self.itemWidth, CGRectGetHeight(self.cateTitleView.frame));
        button.titleEdgeInsets = self.titleEdgeInsets;
        button.imageEdgeInsets = self.imageEdgeInsets;
        NSDictionary *dict = self.channelCates[i];
        button.ename = dict[self.itemImageNameKey];
        button.cname = dict[self.itemNameKey];
        [button setTitle:dict[self.itemNameKey] forState:UIControlStateNormal];
        [button setImage:dict[self.itemImageNameKey] forState:UIControlStateNormal];
        if ((!button.ename || !button.ename.length) && (!button.cname || !button.cname.length)) {
            button.userInteractionEnabled = NO;
        }
//        UIImage *image = [UIImage imageNamed:imageName];
//        if (!image) {
//            image = [UIImage imageNamed:@"boardgames"];
//        }
//        UIImage *image_h = [UIImage imageNamed:[imageName stringByAppendingString:@"_h"]];
//        if (!image_h) {
//            image_h = [UIImage imageNamed:@"boardgames_h"];
//        }
        
//        [button setImage:image forState:UIControlStateNormal];
//        [button setImage:image_h forState:UIControlStateSelected];
        button.titleLabel.font = self.titleItemFont;
        [button setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        button.tag = i;
        [button addTarget:self action:@selector(titleButtonClick:) forControlEvents:UIControlEventTouchUpInside];
        
        [self.items addObject:button];
        [self.cateTitleView addSubview:button];
    }
    
    self.cateTitleView.contentSize = CGSizeMake(count * self.itemWidth, 0);
    
    if (self.delegate && [self.delegate respondsToSelector:@selector(cateTitleView:cateTitleItemDidCreated:)]) {
        [self.delegate cateTitleView:self cateTitleItemDidCreated:count];
    }
    
    // 让默认选择的按钮
    [self selecteTitleItemWithIndex:self.selectedIndex];
    [self creatUnderLine];
    
    
}

#pragma mark - set \ get
//- (void)setItemWidth:(CGFloat)itemWidth {
//    _itemWidth = itemWidth;
//    for (UIButton *btn in self.items) {
//        CGRect frame = btn.frame;
//        frame.size.width = _itemWidth;
//        btn.frame = frame;
//    }
//    
//    [self updateUnderLineFrameFromBtn:self.previousSelectedBtn];
//}

- (CGFloat)itemWidth {
    
    return _itemWidth ?: self.channelCates.count < 5 ? CGRectGetWidth(self.cateTitleView.frame) / self.channelCates.count : 110;
}


- (void)setRightItemTitle:(NSString *)title image:(UIImage *)image forState:(UIControlState)state {
    
    [self.rightButton setTitle:title forState:state];
    [self.rightButton setImage:image forState:state];
}

- (void)setRightBtnWidth:(CGFloat)rightBtnWidth {
    _rightBtnWidth = rightBtnWidth;
    
    CGRect frame = self.rightButton.frame;
    frame.size.width = rightBtnWidth;
    self.rightButton.frame = frame;
}

- (NSInteger)previousSelectItemIndex {
    return _previousSelectItemIndex ?: self.previousSelectedBtn.tag;
}

- (NSInteger)currentSelectItemIndex {
    return self.currentSelectBtn.tag;
}

- (void)setChannelCates:(NSMutableArray *)channelCates {
    
    // 将之前的保存在这个数组中
    self.previousChannelCates = [_channelCates mutableCopy];
    _channelCates = channelCates;

    // 当数据发送改变时，重新布局button
    if (_channelCates.count) {
        
        [self reloadSubviews];
    }
}

- (NSMutableArray *)channelCates {
    if (_channelCates == nil) {
        _channelCates = [NSMutableArray arrayWithCapacity:0];
    }
    return _channelCates;
}

- (UIColor *)separatorBackgroundColor {
    return _separatorBackgroundColor ?: [UIColor colorWithRed:140 / 255.0 green:140 / 255.0 blue:140 / 255.0 alpha:0.6];
}

- (void)setSeparatorBackgroundColor:(UIColor *)separatorBackgroundColor {
    
    _separatorBackgroundColor = separatorBackgroundColor;
    if (separatorBackgroundColor) {
        self.separatorView.image = [UIImage new];
        _separatorImage = [UIImage new];
        self.separatorView.backgroundColor = separatorBackgroundColor;
    }
    
}

- (void)setSeparatorImage:(UIImage *)separatorImage {
    _separatorImage = separatorImage;
    
    if (separatorImage) {
        self.separatorView.backgroundColor = [UIColor clearColor];
        _separatorBackgroundColor = [UIColor clearColor];
        self.separatorView.image = separatorImage;
    }
}


- (void)setBackgroundColor:(UIColor *)backgroundColor {
    [super setBackgroundColor:backgroundColor];

    self.cateTitleView.backgroundColor = backgroundColor;
    self.currentItemBackgroundColor = backgroundColor;
    self.otherItemBackgroundColor = backgroundColor;
    self.rightButton.backgroundColor = backgroundColor;
}

- (UIImage *)separatorImage {
    
    return _separatorImage ?: nil;
}

- (UIImage *)underLineImage {
    
    return _underLineImage ?: nil;
}

- (void)setUnderLineImage:(UIImage *)underLineImage {
    _underLineImage = underLineImage;
    
    if (_underLineImage) {
        _underLineBackgroundColor = [UIColor clearColor];
        self.underLine.backgroundColor = _underLineBackgroundColor;
        self.underLine.image = underLineImage;
    }
}

- (UIColor *)underLineBackgroundColor {
    
    return _underLineBackgroundColor ?: [UIColor clearColor];
    
}

- (void)setUnderLineBackgroundColor:(UIColor *)underLineBackgroundColor {
    _underLineBackgroundColor = underLineBackgroundColor;
    if (underLineBackgroundColor) {
        self.underLine.image = [UIImage new];
        _underLineImage = [UIImage new];
        self.underLine.backgroundColor = underLineBackgroundColor;
    }
}

- (UIColor *)currentItemBackGroundColor {
    
    if (self.currentSelectBtn != self.previousSelectedBtn) {
        
        return _currentItemBackgroundColor ?: [UIColor whiteColor];
    } else {
        return self.currentSelectBtn.backgroundColor;
    }
}

- (UIColor *)otherItemBackGroundColor {
    if (self.currentSelectBtn != self.previousSelectedBtn) {
        
        return _otherItemBackgroundColor ?: [UIColor whiteColor];
    } else {
        return self.previousSelectedBtn.backgroundColor;
    }
}

- (void)setCurrentItemBackgroundColor:(UIColor *)currentItemBackgroundColor {
    _currentItemBackgroundColor = currentItemBackgroundColor;
    
    if (self.currentSelectBtn != self.previousSelectedBtn) {
    
        self.currentSelectBtn.backgroundColor = currentItemBackgroundColor;
    }
}

- (void)setOtherItemBackGroundColor:(UIColor *)otherItemBackgroundColor {
    _otherItemBackgroundColor = otherItemBackgroundColor;
    
    for (UIButton *btn in self.items) {
        if (btn != self.currentSelectBtn) {
            btn.backgroundColor = otherItemBackgroundColor;
        }
    }
}

- (void)setItemScale:(CGFloat)itemScale {
    _itemScale = itemScale;
    /// 设置标题按钮的缩放
    self.currentSelectBtn.transform = CGAffineTransformMakeScale(1.0f + _itemScale, 1.0f + _itemScale);
}

- (CGFloat)itemScale {
    return _itemScale ?: 0.0;
}

- (CGFloat)btnContentMargin {
    CGFloat btnW = self.currentSelectBtn.frame.size.width;
    CGFloat margin = (btnW - self.btnContentWidth) * 0.5;
    return margin;
}

- (UIFont *)titleItemFont {
    
    return self.currentSelectBtn.titleLabel.font ?: [UIFont systemFontOfSize:15 weight:0.3];
    
}
- (void)setTitleItemFont:(UIFont *)titleItemFont {
    
    _titleItemFont = titleItemFont;
    for (UIButton *btn in self.items) {
        [btn.titleLabel setFont:titleItemFont];
    }
}

- (CGFloat)btnContentWidth {
    NSString *currentText = self.currentSelectBtn.currentTitle;
    UIImage *currentImage = self.currentSelectBtn.currentImage;
    CGSize size = [currentText sizeWithAttributes:@{NSFontAttributeName : self.titleItemFont}];
    /// 只有文字， 没有图片时
    if ((currentText != nil || ![currentText isEqualToString:@""]) && !currentImage) {
        return size.width;
        
    }
    
    /// 没有文字， 只有图片时
    if ((currentText == nil || [currentText isEqualToString:@""]) && currentImage != nil) {
        return currentImage.size.width;
    }
    
    /// 图片和文字都有
    if ((currentText != nil || ![currentText isEqualToString:@""]) && currentImage) {
        return  currentImage.size.width + size.width + 10;
    }
    
    /// 全都没有
    return 0;
    
}

- (void)creatUnderLine {
    UIImageView *underLine = [UIImageView new];
    [self.cateTitleView insertSubview:underLine aboveSubview:self.currentSelectBtn];
    [self.cateTitleView bringSubviewToFront:underLine];
    underLine.backgroundColor = self.underLineBackgroundColor;
    underLine.image = self.underLineImage;
    _underLine = underLine;
    [self updateUnderLineFrameFromBtn:self.previousSelectedBtn];
}

- (void)updateUnderLineFrameFromBtn:(UIButton *)btn {
    // 计算差值
    CGFloat less = self.underLineWidth - self.btnContentWidth;
    
    CGRect underLineFrame = self.underLine.frame;
    underLineFrame.size.width = self.btnContentWidth + less;
    underLineFrame.origin.x = btn.frame.origin.x + self.btnContentMargin - less * 0.5;
    underLineFrame.origin.y = CGRectGetHeight(self.frame)-2;
    underLineFrame.size.height = 2;
    self.underLine.frame = underLineFrame;
    
}

- (CGFloat)underLineWidth {
    if (!_underLineWidth) {
        return self.btnContentWidth;
    } else {
        if (_underLineWidth > CGRectGetWidth(self.previousSelectedBtn.frame)) {
            return self.btnContentWidth;
        }
        return _underLineWidth;
    }
}

- (NSInteger)selectedIndex {
    
    return  _selectedIndex == 0 || _selectedIndex > self.channelCates.count ? self.previousSelectItemIndex : _selectedIndex;
}

- (void)setSelectedIndex:(NSInteger)selectedIndex {
    _selectedIndex = selectedIndex;
    
    if (selectedIndex > self.items.count - 1) {
        NSLog(@"选中的按钮索引已超出按钮的数量");
        return;
    }

    [self selecteTitleItemWithIndex:selectedIndex];
}


- (NSMutableArray *)items {
    
    if (_items == nil) {
        
        _items = [NSMutableArray array];
    }
    return _items;
}

- (UIButton *)rightButton {
    if (_rightButton == nil) {
        UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
        [btn setImage:[UIImage imageNamed:@"addbutton"] forState:UIControlStateNormal];
        _rightButton = btn;
        _rightButton.frame = CGRectMake(CGRectGetWidth(self.frame) - self.rightBtnWidth, 0, self.rightBtnWidth, CGRectGetHeight(self.frame));
        [_rightButton addTarget:self action:@selector(rightButtonClick:) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:_rightButton];
    }
    
    return _rightButton;
}

- (UIScrollView *)cateTitleView {
    if (_cateTitleView == nil) {
        UIScrollView *scrollView = [[UIScrollView alloc] init];
        scrollView.showsHorizontalScrollIndicator = NO;
        scrollView.showsVerticalScrollIndicator = NO;
        _cateTitleView = scrollView;
        _cateTitleView.delegate = self;
        _cateTitleView.frame = CGRectMake(0, 0, CGRectGetWidth(self.frame) - self.rightBtnWidth, CGRectGetHeight(self.frame));
        [self addSubview:_cateTitleView];
    }
    return _cateTitleView;
}

- (UIView *)separatorView {
    if (_separatorView == nil) {
        UIImageView *separatorView = [[UIImageView alloc] init];
        separatorView.image = self.separatorImage;
        separatorView.backgroundColor = self.separatorBackgroundColor;
        _separatorView = separatorView;
        CGRect frame = _separatorView.frame;
        frame.origin.y = CGRectGetHeight(self.cateTitleView.frame)-0.5;
        frame.size.height = 0.5;
        frame.size.width = CGRectGetWidth(self.frame);
        frame.origin.x = 0;
        _separatorView.frame = frame;
        [self addSubview:separatorView];
        [self bringSubviewToFront:_separatorView];
    }
    return _separatorView;
}


#pragma mark - Events
/// 切换到index索引对应的子控制
- (void)selecteTitleItemWithIndex:(NSInteger)index {
    
    if (index > self.items.count - 1 || index < 0) {
        return;
    }
    
    UIButton *btn = self.items[index];
    [self titleButtonClick:btn];
    

}

/// 监听标题按钮的点击
- (void)titleButtonClick:(UIButton *)button {
    
    [self selectedBtn:button];
    
}


- (void)rightButtonClick:(UIButton *)button {
    
    button.selected = !button.isSelected;
    
    if (self.selectedRightBtnCallBack) {
        self.selectedRightBtnCallBack(button);
        return;
    }
    
    if (self.delegate && [self.delegate respondsToSelector:@selector(cateTitleView:didSelectedAddSubTitle:)]) {
        [self.delegate cateTitleView:self didSelectedAddSubTitle:button];
    }
    
}

#pragma mark - 设置选中按钮文字的默认颜色
- (void)selectedBtn:(UIButton *)button {
    
    _currentSelectBtn = button; /// 记录当前选中的按钮
    
    _currentSelectBtn.backgroundColor = self.currentItemBackGroundColor;
    _previousSelectedBtn.backgroundColor = self.otherItemBackGroundColor;
    _previousSelectedBtn.selected = NO;
    _previousSelectedBtn.transform = CGAffineTransformIdentity;
    button.selected = YES;
    [_previousSelectedBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    
    [button setTitleColor:kColorGlobalGreen forState:UIControlStateNormal];
    
    [self setupTitleCenter:button];
    
    button.transform = CGAffineTransformMakeScale(1.0f + self.itemScale, 1.0f + self.itemScale);
    
    if (_isFirst) {
        [self updateUnderLineFrameFromBtn:button];
        _isFirst = false;
    } else {
        [UIView animateWithDuration:0.15 animations:^{
            [self updateUnderLineFrameFromBtn:button];
        }];
    }

    /// 将当前点击的按钮相关的频道信息写入到本地
    /// 通知代理，并把点击按钮的索引传递出去，让外界切换对应的子控制器的view,内容滚动范围滚动到对应的位置
    if (self.delegate && [self.delegate respondsToSelector:@selector(cateTitleView:didSelectedItem:)]) {
        NSInteger i = [button tag];
        [self.delegate cateTitleView:self didSelectedItem:i];
    }
    
    if (self.selectedItemCallBack) {
        self.selectedItemCallBack(button.ename, button.tag);
    }
    
    if (self.delegate && [self.delegate respondsToSelector:@selector(cateTitleView:didSelectedItem:ename:)]) {
        [self.delegate cateTitleView:self didSelectedItem:button ename:button.ename];
    }
    if (self.delegate && [self.delegate respondsToSelector:@selector(cateTitleView:didSelectedItem:cname:)]) {
        [self.delegate cateTitleView:self didSelectedItem:button cname:button.cname];
    }
    self.previousSelectedBtn = button; /// 记录上次选中的按钮
    
}



#pragma mark - 设置标题居中
- (void)setupTitleCenter:(UIButton *)button {
    
    /// 本质：移动标题滚动视图的偏移量
    /// 计算当选择的标题按钮的中心点x在屏幕屏幕中心点时，标题滚动视图的x轴的偏移量
    CGFloat offsetX = button.center.x - CGRectGetWidth(self.cateTitleView.frame) * 0.5;
    if (offsetX < 0) {
        offsetX = 0;
    }
    
    CGFloat maxOffsetX = self.cateTitleView.contentSize.width - CGRectGetWidth(self.cateTitleView.frame);

    if (offsetX > maxOffsetX) {
        offsetX = maxOffsetX;
    }
    
    [self.cateTitleView setContentOffset:CGPointMake(offsetX, 0) animated:YES];
}

#pragma mark - XYHomeContainerViewDelegate
//- (void)containerViewDidScroll:(XYHomeContainerView *)containerView {
//    
//    [self contentViewDidScroll:containerView];
//}
//
//- (void)containerViewDidScrollDidEndDecelerating:(XYHomeContainerView *)containerView {
//    
//    [self contentViewDidScrollDidEndDecelerating:containerView];
//}

/// 此方法父类未实现，子类如果想在containerView滚动的时候做事情，可重写此方法
- (void)contentViewDidScroll:(UIScrollView *)scrollView {

}

- (void)contentViewDidScrollDidEndDecelerating:(UIScrollView *)scrollView {

    NSInteger i = scrollView.contentOffset.x / CGRectGetWidth(scrollView.frame);
    
    UIButton *button = self.items[i];
    [self selectedBtn:button];
    
    
}

#pragma mark - <UIScrollViewDelegate>
- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    if (self.delegate && [self.delegate respondsToSelector:@selector(cateTitleViewDidScroll:)]) {
        [self.delegate cateTitleViewDidScroll:scrollView];
    }
}


// 深拷贝
//- (id)copyWithZone:(NSZone *)zone {
//    
//    XYCateTitleView *cateTitleView = [XYCateTitleView allocWithZone:zone];
//    
//    return cateTitleView;
//}

// 浅拷贝
- (id)copyWithZone:(NSZone *)zone {
    
    return self;
}


- (instancetype)init {
    
    NSAssert(NO, @"请使用：initWithFrame:(CGRect)frame channelCates:(NSArray *)channelCates");
    @throw nil;
}
- (instancetype)initWithFrame:(CGRect)frame {
    NSAssert(NO, @"请使用：initWithFrame:(CGRect)frame channelCates:(NSArray *)channelCates");
    @throw nil;
}

+ (instancetype)new {
    NSAssert(NO, @"请使用：initWithFrame:(CGRect)frame channelCates:(NSArray *)channelCates");
    @throw nil;
}

- (void)dealloc {
    
    NSLog(@"%s", __FUNCTION__);
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (instancetype)initWithCoder:(NSCoder *)aDecoder {
    NSAssert(NO, @"请使用：initWithFrame:(CGRect)frame titles:(NSArray *)titles subscribeWidth:(CGFloat)subscribeWidth");
    @throw nil;
}

@end


char *const ENAME_KEY = "enameKey";
char *const CNAME_KEY = "cnameKey";

@implementation UIButton (XYCateTitle)

- (void)setEname:(NSString *)ename {
    
    objc_setAssociatedObject(self, &ENAME_KEY, ename, OBJC_ASSOCIATION_COPY_NONATOMIC);
}

- (NSString *)ename {
    
    return objc_getAssociatedObject(self, &ENAME_KEY);
}

- (void)setCname:(NSString *)cname {
    
    objc_setAssociatedObject(self, &CNAME_KEY, cname, OBJC_ASSOCIATION_COPY_NONATOMIC);
}

- (NSString *)cname {
    return objc_getAssociatedObject(self, &CNAME_KEY);
}

@end


