
//
//  LGPageView.m
//  RGTestPorject
//
//  Created by Peanut Lee on 2018/4/13.
//  Copyright © 2018年 Lee. All rights reserved.
//

#import "LGPageView.h"
#import "LGSegmentControl.h"

@interface LGPageView ()
@property (strong,nonatomic) NSArray<UIViewController *> *viewControllers;
@property (strong,nonatomic) UIViewController<LGSegmentControlDelegate> *mainViewController;

@property (strong,nonatomic) UIView *header;
@property (strong,nonatomic) LGSegmentControl *segment;
@property (strong,nonatomic) UIScrollView *scrollView;

@end

@implementation LGPageView

- (instancetype)initWithFrame:(CGRect)frame mainViewController:(UIViewController<LGSegmentControlDelegate> *)mainViewController viewControllers:(NSArray<UIViewController *> *)viewControllers{
    _mainViewController = mainViewController;
    _viewControllers = viewControllers;
    return [self initWithFrame:frame];
}

- (void)layoutSubviews{
    [super layoutSubviews];
    
}

- (void)setupSubviews{
    [self addSubview:self.header];
    [self addSubview:self.segment];
    [self addSubview:self.scrollView];
    [_viewControllers enumerateObjectsUsingBlock:^(UIViewController * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        [_scrollView addSubview:obj.view];
    }];
    
}

/// MARK: lazy load
- (UIView *)header{
    if (_header == nil) {
        _header = [UIView new];
    }
    return _header;
}
- (LGSegmentControl *)segment{
    if (_segment == nil) {
        NSMutableArray *arr = [NSMutableArray array];
        for (int i = 0; i < 3; i++) {
            LGSegmentControlModel *model = [LGSegmentControlModel new];
            model.imageName = @"home_test0";
            model.title = @"测试";
            [arr addObject:model];
        }
        _segment = [[LGSegmentControl alloc] initWithFrame:CGRectMake(0, 200, [UIScreen mainScreen].bounds.size.width, 64) models:arr.copy];
        _segment.elfColor = [UIColor orangeColor];
        _segment.displayIcon = YES;
        _segment.delegate = _mainViewController;
        _segment.textFont = 13;
    }
    return _segment;
}
- (UIScrollView *)scrollView{
    if (_scrollView == nil) {
        _scrollView = [UIScrollView new];
        _scrollView.delegate;
    }
    return _scrollView;
}

@end
