//
//  ECRSwichView.m
//  EasyChineseReading-ios
//
//  Created by lee on 2017/9/5.
//  Copyright © 2017年 lee. All rights reserved.
//

#import "LGSegmentControl.h"
#import "UIColor+Extension.h"

/// ------------------------------------------------------------------------
@interface LGSegmentSingleView: UIView
@property (copy,nonatomic) NSString *imageName;
@property (copy,nonatomic) NSString *title;
@property (assign,nonatomic) BOOL displayIcon;
@property (assign,nonatomic) NSInteger textFont;

@end

@interface LGSegmentSingleView ()
@property (strong,nonatomic) UIImageView *imageView;
@property (strong,nonatomic) UILabel *label;
@property (strong,nonatomic) UIButton *button;
- (void)addTarget:(id)target action:(SEL)action forControlEvents:(UIControlEvents)controlEvents;
@property (nonatomic) UIColor *labelColor;

@end

@implementation LGSegmentSingleView

- (void)setLabelColor:(UIColor *)labelColor{
    self.label.textColor = labelColor;
}

- (void)setImageName:(NSString *)imageName{
    _imageName = imageName;
    [self.imageView setImage:[UIImage imageNamed:imageName]];
}
- (void)setTitle:(NSString *)title{
    _title = title;
    [self.label setText:title];
}
- (void)setTag:(NSInteger)tag{
    [super setTag:tag];
    self.button.tag = tag;
}
- (void)addTarget:(id)target action:(SEL)action forControlEvents:(UIControlEvents)controlEvents{
    [self.button addTarget:target action:action forControlEvents:controlEvents];
}
- (void)setupUI{
    [self addSubview:self.imageView];
    [self addSubview:self.label];
    [self addSubview:self.button];
    
}

- (instancetype)initWithFrame:(CGRect)frame{
    if (self = [super initWithFrame:frame]) {
        [self setupUI];
    }
    return self;
}
- (instancetype)initWithCoder:(NSCoder *)aDecoder{
    if (self = [super initWithCoder:aDecoder]) {
        [self setupUI];
    }
    return self;
}


- (UIImageView *)imageView{
    if (_imageView == nil) {
        CGFloat imgW = self.bounds.size.width * 0.9;
        CGFloat imgH = self.bounds.size.height * 0.7;
        CGFloat imgX = (self.bounds.size.width - imgW) * 0.5;
//        CGFloat imgY = (self.bounds.size.height - imgH) * 0.5;
        _imageView = [[UIImageView alloc] initWithFrame:CGRectMake(imgX, 8, imgW, imgH)];
        _imageView.contentMode = UIViewContentModeScaleAspectFit;
    }
    return _imageView;
}
- (UILabel *)label{
    if (_label == nil) {
        _label = [[UILabel alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(_imageView.frame) + 5, self.bounds.size.width, (_textFont == 0)?12:_textFont)];
        _label.textColor = [UIColor blackColor];
        _label.font = [UIFont systemFontOfSize:(_textFont == 0)?12:_textFont];
        _label.textAlignment = NSTextAlignmentCenter;
    }
    return _label;
}
- (UIButton *)button{
    if (_button == nil) {
        _button = [[UIButton alloc] initWithFrame:self.bounds];
    }
    return _button;
}

@end
/// ------------------------------------------------------------------------

@interface LGSegmentControl ()
@property (strong,nonatomic) UIView *elf;
@property (strong,nonatomic) NSArray<LGSegmentSingleView *> *subSingleViews;

@end

@implementation LGSegmentControl

- (void)elfAnimateWithIndex:(NSInteger)index{
    CGRect tmpFrame = self.elf.frame;
    tmpFrame.origin.x = [self elfXWithIndex:index];
    [UIView animateWithDuration:0.2 animations:^{
        self.elf.frame = tmpFrame;
    }];
    [self.subSingleViews enumerateObjectsUsingBlock:^(LGSegmentSingleView * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        if (index == idx) {
            obj.labelColor = [UIColor EDJMainColor];
        }else{
            obj.labelColor = [UIColor EDJGrayscale_11];
        }
    }];

}

- (void)segmentClick:(UIButton *)sender{
    /// 通知代理,可能需要切换数据
    if ([self.delegate respondsToSelector:@selector(segmentControl:didClick:)]) {
        [self.delegate segmentControl:self didClick:sender.tag];
    }
    /// 展示动画
    [self elfAnimateWithIndex:sender.tag];
}

/// MARK: 初始化
- (instancetype)initWithFrame:(CGRect)frame models:(NSArray<LGSegmentControlModel *> *)models{
    _models = models;
    return [self initWithFrame:frame];
}

- (instancetype)initWithFrame:(CGRect)frame{
    if (self = [super initWithFrame:frame]) {
        self.backgroundColor = [UIColor whiteColor];
        [self setupSubviews];
    }
    return self;
}

- (void)setupSubviews{
    /// 布局 子控件
    self.backgroundColor = [UIColor whiteColor];
    
    CGFloat singleViewWidth = [self singleViewWidth];
    
    NSMutableArray *arr = [NSMutableArray arrayWithCapacity:10];
    [_models enumerateObjectsUsingBlock:^(LGSegmentControlModel * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        CGFloat singleViewH = self.frame.size.height * 0.8;
        CGFloat x = idx * singleViewWidth;
        CGFloat y = 0;
        CGRect frame = CGRectMake(x, y, singleViewWidth, singleViewH);
        
        LGSegmentSingleView *singleView = [[LGSegmentSingleView alloc] initWithFrame:frame];
        singleView.tag = idx;
        singleView.imageName = obj.imageName;
        singleView.textFont = _textFont;
        singleView.title = obj.title;
        if (idx == 0) {
            singleView.labelColor = [UIColor EDJMainColor];
        }
        
        [singleView addTarget:self action:@selector(segmentClick:) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:singleView];
        [arr addObject:singleView];
    }];
    self.subSingleViews = arr.copy;
    
    /// 动画横条
    [self addSubview:self.elf];
    CGFloat elfHeight = 2;
    self.elf.frame = CGRectMake([self elfXWithIndex:0], self.frame.size.height - elfHeight, [self singleViewIconWidth], elfHeight);
    
}

- (CGFloat)elfXWithIndex:(NSUInteger)index{/// 返回动画横条的 坐标点 x
    CGFloat elfX = ([self singleViewWidth] - [self singleViewIconWidth]) / 2;
    return (2 * index + 1) * elfX + index * [self singleViewIconWidth];
}
- (CGFloat)singleViewWidth{/// 单项宽度
    return [UIScreen mainScreen].bounds.size.width / _models.count;
}
- (CGFloat)singleViewIconWidth{/// 单项icon宽度
    LGSegmentControlModel *model = _models[0];
    return [UIImage imageNamed:model.imageName].size.width;
}

/// MARK: lazy load
- (UIView *)elf{
    if (_elf == nil) {
        _elf = [[UIView alloc] initWithFrame:CGRectZero];
        _elf.backgroundColor = _elfColor?_elfColor:[UIColor blackColor];
    }
    return _elf;
}
- (void)setElfColor:(UIColor *)elfColor{
    _elfColor = elfColor;
    _elf.backgroundColor = elfColor;
}

@end

@implementation LGSegmentControlModel
@end
