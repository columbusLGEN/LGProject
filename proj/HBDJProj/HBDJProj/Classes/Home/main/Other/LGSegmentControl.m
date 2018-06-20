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

@end

@interface LGSegmentSingleView ()
@property (strong,nonatomic) UIImageView *imageView;
@property (strong,nonatomic) UIButton *button;
- (void)addTarget:(id)target action:(SEL)action forControlEvents:(UIControlEvents)controlEvents;

@end

@implementation LGSegmentSingleView


- (void)setImageName:(NSString *)imageName{
    _imageName = imageName;
    [self.imageView setImage:[UIImage imageNamed:imageName]];
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
        CGFloat imgH = self.bounds.size.height;
        CGFloat imgX = (self.bounds.size.width - imgW) * 0.5;
        _imageView = [[UIImageView alloc] initWithFrame:CGRectMake(imgX, 0, imgW, imgH)];
        _imageView.contentMode = UIViewContentModeScaleAspectFit;
    }
    return _imageView;
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
@property (strong,nonatomic) NSArray<LGSegmentSingleView *> *subSingleViews;

@end

@implementation LGSegmentControl

- (void)segmentClick:(UIButton *)sender{
    /// 通知代理,可能需要切换数据
    if ([self.delegate respondsToSelector:@selector(segmentControl:didClick:)]) {
        [self.delegate segmentControl:self didClick:sender.tag];
    }
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
        CGFloat singleViewH = self.frame.size.height;
        CGFloat x = idx * singleViewWidth;
        CGFloat y = 0;
        CGRect frame = CGRectMake(x, y, singleViewWidth, singleViewH);
        
        LGSegmentSingleView *singleView = [[LGSegmentSingleView alloc] initWithFrame:frame];
        singleView.tag = idx;
        singleView.imageName = obj.imageName;
        
        [singleView addTarget:self action:@selector(segmentClick:) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:singleView];
        [arr addObject:singleView];
    }];
    self.subSingleViews = arr.copy;
    
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


@end

@implementation LGSegmentControlModel
@end
