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
@property (assign,nonatomic) BOOL displayIcon;
@property (assign,nonatomic) NSInteger textFont;

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


- (void)setupUI{
    [self addSubview:self.imageView];
    _imageView.image = [UIImage imageNamed:@"home_test0"];
    /// 获取实例的引用计数 retain count
//    NSLog(@"imgeview.retaincoutn -- %ld",CFGetRetainCount((__bridge CFTypeRef)(_imageView)));
    
    [_imageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.mas_top);
        make.centerX.equalTo(self.mas_centerX);
        make.width.mas_equalTo(self.frame.size.width);
        make.height.equalTo(self.mas_height).multipliedBy(0.63);
    }];
    
    [self addSubview:self.label];
    [_label mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.mas_left);
        make.right.equalTo(self.mas_right);
        make.top.equalTo(self.imageView.mas_bottom).offset(7);
    }];
    

    [self addSubview:self.button];
    [_button mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.mas_top);
        make.left.equalTo(self.mas_left);
        make.width.equalTo(self.mas_width);
        make.height.equalTo(self.mas_height);
    }];
    
    /// 只展示文字
    if (_displayIcon == NO) {
        [self.imageView removeFromSuperview];
        _imageView = nil;
        [self.label mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.mas_left);
            make.right.equalTo(self.mas_right);
            make.centerY.equalTo(self.mas_centerY);
        }];
    }
}
- (void)layoutSubviews{
    [super layoutSubviews];
    [self setupUI];
}

- (UIImageView *)imageView{
    if (_imageView == nil) {
        _imageView = [[UIImageView alloc] initWithFrame:CGRectZero];
        _imageView.contentMode = UIViewContentModeScaleAspectFit;
    }
    return _imageView;
}
- (UILabel *)label{
    if (_label == nil) {
        _label = [[UILabel alloc] initWithFrame:CGRectZero];
        _label.textColor = [UIColor blackColor];
        _label.font = [UIFont systemFontOfSize:(_textFont == 0)?12:_textFont];
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
@property (strong,nonatomic) UIView *elf;
@property (strong,nonatomic) NSArray<LGSegmentSingleView *> *subSingleViews;

@end

@implementation LGSegmentControl


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

- (void)setDisplayIcon:(BOOL)displayIcon{
    _displayIcon = displayIcon;
    [self.subSingleViews enumerateObjectsUsingBlock:^(LGSegmentSingleView * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        obj.displayIcon = displayIcon;
    }];
}

/// MARK: 初始化
- (instancetype)initWithFrame:(CGRect)frame models:(NSArray<LGSegmentControlModel *> *)models{
    _models = models;
    return [self initWithFrame:frame];
}

- (void)layoutSubviews{
    [super layoutSubviews];
    self.backgroundColor = [UIColor whiteColor];
    [self setupSubviews];
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
        
        [singleView addTarget:self action:@selector(segmentClick:) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:singleView];
        [arr addObject:singleView];
    }];
    self.subSingleViews = arr.copy;
    
    /// 动画横条
    [self addSubview:self.elf];
    CGFloat elfHeight = 2;
    self.elf.frame = CGRectMake([self elfXWithIndex:0], self.frame.size.height - elfHeight, [self singleViewIconWidth], elfHeight);
    
    self.displayIcon = _displayIcon;
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
}

@end
