//
//  ECRSwichView.m
//  EasyChineseReading-ios
//
//  Created by lee on 2017/9/5.
//  Copyright © 2017年 lee. All rights reserved.
//

#import "LGSegmentControl.h"

@implementation LGSegmentControlModel
@end

/// ------------------------------------------------------------------------
@interface LGSegmentSingleView: UIView
@property (copy,nonatomic) NSString *imageName;
@property (copy,nonatomic) NSString *title;

@end

@interface LGSegmentSingleView ()
@property (strong,nonatomic) UIImageView *imageView;
@property (strong,nonatomic) UILabel *label;
@property (strong,nonatomic) UIButton *button;
- (void)addTarget:(id)target action:(SEL)action forControlEvents:(UIControlEvents)controlEvents;

@end

@implementation LGSegmentSingleView

- (void)addTarget:(id)target action:(SEL)action forControlEvents:(UIControlEvents)controlEvents{
    [self.button addTarget:target action:action forControlEvents:controlEvents];
}

- (void)setImageName:(NSString *)imageName{
    _imageName = imageName;
    [_imageView setImage:[UIImage imageNamed:imageName]];
}
- (void)setTitle:(NSString *)title{
    _title = title;
    [_label setText:title];
}

- (void)setTag:(NSInteger)tag{
    [super setTag:tag];
    self.button.tag = tag;
}

- (void)singleViewSetupUI{
    [self addSubview:self.imageView];
    _imageView.image = [UIImage imageNamed:@"home_test0"];
    /// 获取实例的引用计数 retain count
//    NSLog(@"imgeview.retaincoutn -- %ld",CFGetRetainCount((__bridge CFTypeRef)(_imageView)));
    
    [_imageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.mas_top);
        make.centerX.equalTo(self.mas_centerX);
        make.width.mas_equalTo(homeSegmentContentWidth);
        make.height.equalTo(self.mas_height).multipliedBy(0.63);
    }];
    
    [self addSubview:self.label];
    [_label mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.mas_left);
        make.right.equalTo(self.mas_right);
        make.top.equalTo(self.imageView.mas_bottom).offset(7);
    }];
    
    [_label setText:@"微党课"];

    [self addSubview:self.button];
    [_button mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.mas_top);
        make.left.equalTo(self.mas_left);
        make.width.equalTo(self.mas_width);
        make.height.equalTo(self.mas_height);
    }];
}
- (instancetype)initWithFrame:(CGRect)frame{
    if (self = [super initWithFrame:frame]) {
        [self singleViewSetupUI];
    }
    return self;
}
- (instancetype)initWithCoder:(NSCoder *)aDecoder{
    if (self = [super initWithCoder:aDecoder]) {
        [self singleViewSetupUI];
    }
    return self;
}

- (UIImageView *)imageView{
    if (_imageView == nil) {
        _imageView = [[UIImageView alloc] initWithFrame:CGRectZero];
        _imageView.contentMode = UIViewContentModeScaleAspectFill;
    }
    return _imageView;
}
- (UILabel *)label{
    if (_label == nil) {
        _label = [[UILabel alloc] initWithFrame:CGRectZero];
        _label.textColor = [UIColor blackColor];
        _label.font = [UIFont systemFontOfSize:15];
        _label.textAlignment = NSTextAlignmentCenter;
    }
    return _label;
}
- (UIButton *)button{
    if (_button == nil) {
        _button = [[UIButton alloc] initWithFrame:CGRectZero];
    }
    return _button;
}

@end
/// ------------------------------------------------------------------------

@interface LGSegmentControl ()
@property (weak,nonatomic) NSArray<LGSegmentControlModel *> *models;
@property (strong,nonatomic) UIView *elf;
@property (strong,nonatomic) NSArray *subSingleViews;

@end

@implementation LGSegmentControl

- (void)layoutSubviews{
    [super layoutSubviews];
    [self setupSubviews];
}

- (void)segmentClick:(UIButton *)sender{
    /// 通知代理,可能需要切换数据
    if ([self.delegate respondsToSelector:@selector(segmentControl:didClick:)]) {
        [self.delegate segmentControl:self didClick:sender.tag];
    }

    /// 展示动画
    CGRect tmpFrame = self.elf.frame;
    tmpFrame.origin.x = [self elfXWithIndex:sender.tag];
    [UIView animateWithDuration:0.2 animations:^{
        self.elf.frame = tmpFrame;
    }];
    
}

/// MARK: 初始化
//- (instancetype)initWithFrame:(CGRect)frame models:(NSArray<LGSegmentControlModel *> *)models{
//    _models = models;
//    return [self initWithFrame:frame];
//}
-  (instancetype)initWithCoder:(NSCoder *)aDecoder{
    if (self = [super initWithCoder:aDecoder]) {
        [self setupSubviews];
    }
    return self;
}
- (instancetype)initWithFrame:(CGRect)frame{
    if (self = [super initWithFrame:frame]) {
//        [self setupSubviews];
    }
    return self;
}

- (void)setupSubviews{
    if (CGRectEqualToRect(self.frame, CGRectZero)) {
        NSLog(@"self.frame == cgrectzero");
    }
    /// 布局 子控件
    self.backgroundColor = [UIColor whiteColor];
    
    CGFloat singleViewWidth = [self singleViewWidth];
    NSMutableArray *arr = [NSMutableArray arrayWithCapacity:10];
    for (NSInteger i = 0; i < 3; i++) {
        /// frame
        
        CGFloat h = homeSegmentHeight;
        CGFloat x = i * singleViewWidth;
        CGFloat y = 0;
        CGRect frame = CGRectMake(x, y, singleViewWidth, h);
        
        LGSegmentSingleView *singleView = [[LGSegmentSingleView alloc] initWithFrame:frame];
        singleView.tag = i;
        [singleView addTarget:self action:@selector(segmentClick:) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:singleView];
        [arr addObject:singleView];
    }
    self.subSingleViews = arr.copy;
    [_models enumerateObjectsUsingBlock:^(LGSegmentControlModel * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        
    }];
    
    /// 动画横条
    UIView *first = self.subSingleViews[0];
    [self addSubview:self.elf];
    CGFloat elfHeight = 2;

    self.elf.frame = CGRectMake([self elfXWithIndex:0], first.height - elfHeight, homeSegmentContentWidth, elfHeight);
    
}

- (CGFloat)elfXWithIndex:(NSUInteger)index{
    //    CGFloat elfX = ([self singleViewWidth] - homeSegmentContentWidth) / 2;
    //    /**
    //     第n个 elf 的 x 为: (2n+1)*elfX + n * homeSegmentContentWidth
    //     (n 从 0 开始)
    //     */
    //    CGFloat secondElfx = 3 * elfX + homeSegmentContentWidth;
    //    CGFloat thirdElfx = 5 * elfX + 2 * homeSegmentContentWidth;
    CGFloat elfX = ([self singleViewWidth] - homeSegmentContentWidth) / 2;
    return (2 * index + 1) * elfX + index * homeSegmentContentWidth;
}

- (CGFloat)singleViewWidth{
    return kScreenWidth / 3;
}

- (UIView *)elf{
    if (_elf == nil) {
        _elf = [[UIView alloc] initWithFrame:CGRectZero];
        _elf.backgroundColor = [UIColor EDJMainColor];
    }
    return _elf;
}

@end
