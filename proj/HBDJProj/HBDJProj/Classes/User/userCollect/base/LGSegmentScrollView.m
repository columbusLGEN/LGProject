//
//  LGSegmentView.m
//  HBDJProj
//
//  Created by Peanut Lee on 2018/4/20.
//  Copyright © 2018年 Lee. All rights reserved.
//

#import "LGSegmentScrollView.h"

static CGFloat marginBetweenButton = 10;

@interface LGSegmentScrollView ()<
UIScrollViewDelegate>

@property (strong,nonatomic) NSMutableArray<NSString *> *buttonTitleFrames;
@property (strong,nonatomic) UIScrollView *scrollView;
@property (weak,nonatomic) UIView *fly;
@property (strong,nonatomic) NSArray *segmentItems;
@property (strong,nonatomic) NSArray *buttons;

@end

@implementation LGSegmentScrollView{
    UIColor *highLightColor;
    CGFloat totalW;
    UIButton *currentButton;
}

- (instancetype)initWithSegmentItems:(NSArray<NSString *> *)items frame:(CGRect)frame{
    self.segmentItems = items;
    return [self initWithFrame:frame];
}

- (void)buttonClick:(UIButton *)button{
    [self setFlyLocationWithIndex:button.tag];
    if ([self.delegate respondsToSelector:@selector(segmentView:index:)]) {
        [self.delegate segmentView:self index:button.tag];
    }
}

/** button 点击事件 */
- (void)setFlyLocationWithIndex:(NSInteger)index{
    
    UIButton *curButton = self.buttons[index];
    currentButton = curButton;
    for (UIButton *button in self.buttons) {
        if (curButton == button) {
            button.selected = YES;
        }else{
            button.selected = NO;
        }
    }
    
    CGRect flyFrame = self.fly.frame;
    flyFrame.origin.x = currentButton.frame.origin.x; //= [self flyXWithIndex:index];
    flyFrame.size.width = currentButton.bounds.size.width;//[self flyWidthWithIndex:index];
    [UIView animateWithDuration:0.2 animations:^{
        self.fly.frame = flyFrame;
        
    } completion:^(BOOL finished) {
        [self refreshContenOffset];
    }];
}

- (instancetype)initWithFrame:(CGRect)frame{
    if (self = [super initWithFrame:frame]) {
        [self setupUI];
    }
    return self;
}

- (void)setupUI{
    self.backgroundColor = [UIColor whiteColor];
    _buttonTitleFrames = [NSMutableArray array];
    
    highLightColor = UIColor.EDJMainColor;
    
    [self addSubview:self.scrollView];
    [self.scrollView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self);
    }];
    
    totalW = 0;
    CGFloat marginLR = 8;
    
    CGRect firstButtonFrame;
    NSMutableArray *arrmu = NSMutableArray.new;
    for (int i = 0; i < self.segmentItems.count; i++) {
        NSString *content = self.segmentItems[i];
        
        /// 左边间距 8
        CGFloat x = marginLR;
        /// 前一个button
        UIButton *lastButton;
        if (i != 0) {
            lastButton = arrmu[i - 1];
            x = CGRectGetMaxX(lastButton.frame) + marginBetweenButton;
        }
        
        UIButton *button = [[UIButton alloc] initWithFrame:CGRectMake(x, 0, 0, 40)];
//        UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
//        button.frame = CGRectMake(x, 0, 0, 40);
        
        if (i == 0) {
            firstButtonFrame = button.frame;
            button.selected = YES;
        }
        button.tag = i;
        
        button.titleLabel.textAlignment = NSTextAlignmentCenter;
        [button setTitle:content forState:UIControlStateNormal];
        [button sizeToFit];
        
        /// TODO: 为什么button 不显示 文字后面的空格？
        
        /// normal文字颜色
        [button setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        
        /// 选中文字颜色
        [button setTitleColor:highLightColor forState:UIControlStateSelected];
        
        button.titleLabel.font = [UIFont systemFontOfSize:14];
        [button addTarget:self action:@selector(buttonClick:) forControlEvents:UIControlEventTouchUpInside];
        [self.scrollView addSubview:button];
        [arrmu addObject:button];
        totalW += button.bounds.size.width;
    }
    CGFloat csw = totalW + marginBetweenButton * (arrmu.count - 1);
    /// 有变间距 8
    [self.scrollView setContentSize:CGSizeMake(csw + 2 * marginLR, 0)];
    
    self.buttons = arrmu.copy;
    
    UIButton *firstButton = self.buttons[0];
    currentButton = firstButton;
    
    CGRect flyDefaultFrame = CGRectMake(firstButton.frame.origin.x, firstButtonFrame.size.height - 2, firstButton.bounds.size.width, 2);
    
    UIView *fly = [[UIView alloc] initWithFrame:flyDefaultFrame];
    fly.backgroundColor = highLightColor;
    [self.scrollView addSubview:fly];
    _fly = fly;

}

/// 让选中的item位于中间
- (void)refreshContenOffset {
    /// 该方法代码来源：https://github.com/tianliangyihou/headlineNews
    CGRect frame = currentButton.frame;
    CGFloat itemX = frame.origin.x;
    CGFloat width = self.scrollView.frame.size.width;
    CGSize contentSize = self.scrollView.contentSize;
    if (itemX > width/2) {
        CGFloat targetX;
        if ((contentSize.width-itemX) <= width/2) {
            targetX = contentSize.width - width;
        } else {
            targetX = frame.origin.x - width/2 + frame.size.width/2;
        }
        /// 应该有更好的解决方法
        if (targetX + width > contentSize.width) {
            targetX = contentSize.width - width;
        }
        [self.scrollView setContentOffset:CGPointMake(targetX, 0) animated:YES];
    } else {
        [self.scrollView setContentOffset:CGPointMake(0, 0) animated:YES];
    }
    
}

- (UIScrollView *)scrollView{
    if (!_scrollView) {
        _scrollView = UIScrollView.new;
        _scrollView.showsHorizontalScrollIndicator = NO;
        _scrollView.delegate = self;
    }
    return _scrollView;
}

@end
