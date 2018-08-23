//
//  LGRecordButtonLoader.m
//  HBDJProj
//
//  Created by Peanut Lee on 2018/6/9.
//  Copyright © 2018年 Lee. All rights reserved.
//

/// 后期重构该类：将两个生成按钮的方法合并

#import "LGRecordButtonLoader.h"

#define btnH 30

@interface LGRecordButtonLoader ()

@property (assign,nonatomic) CGFloat btnTotalW;
@property (assign,nonatomic) CGFloat btnTotalH;
/// 是否将button 都添加至该数组中？

@end

@implementation LGRecordButtonLoader{
    
    CGFloat bW_con;
    CGFloat bH_con;
}

- (void)addButtonToContainerView:(UIView *)container viewController:(UIViewController *)vc array:(NSArray<UIButton *> *)array action:(SEL)action{
    bW_con = 0;
    bH_con = 0;
    
    if (container.subviews.count) {
        [container.subviews enumerateObjectsUsingBlock:^(__kindof UIView * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            [obj removeFromSuperview];
        }];
    }
    
    /// 初始化buttonarray
    if (!(array.count == 0 || array == nil)) {
        [array enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            UIButton *button;
            if (idx > 0) {
                /// MARK: 其余按钮
                button = [self traverseButtonWithArray:array idx:idx];
                [container addSubview:button];
            }else{
                /// MARK: 第一个按钮
                button = (UIButton *)obj;
                button.frame = CGRectMake(marginFive, marginFive, button.bounds.size.width, btnH);
                [container addSubview:button];
                bW_con += button.frame.size.width + marginFive;
                bH_con = btnH + marginFive;
            }
            [button addTarget:vc action:action forControlEvents:UIControlEventTouchUpInside];
        }];
    }
    
    [container mas_updateConstraints:^(MASConstraintMaker *make) {
        make.height.mas_equalTo(bH_con);
    }];
}

- (void)addButtonToScrollView:(UIScrollView *)scrollView viewController:(UIViewController *)vc array:(NSArray<UIButton *> *)array action:(SEL)action {
    _btnTotalH = 0;
    _btnTotalW = 0;
    
    if (scrollView.subviews.count) {
        [scrollView.subviews enumerateObjectsUsingBlock:^(__kindof UIView * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            [obj removeFromSuperview];
        }];
    }

    /// 初始化buttonarray
    if (!(array.count == 0 || array == nil)) {
        [array enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            UIButton *button;
            if (idx > 0) {
                /// MARK: 其余按钮
                button = [self createButtonWithArray:array idx:idx];
                [scrollView addSubview:button];
            }else{
                /// MARK: 第一个按钮
                button = (UIButton *)obj;
                button.frame = CGRectMake(marginFive, marginFive, button.bounds.size.width, btnH);
                [scrollView addSubview:button];
                _btnTotalW += button.frame.size.width + marginFive;
                _btnTotalH = btnH + marginFive;
            }
            [button addTarget:vc action:action forControlEvents:UIControlEventTouchUpInside];
        }];
    }
    
    [scrollView setContentSize:CGSizeMake(0, _btnTotalH)];
}


/// 生成可以添加到scrollview上的UIButton
/// array参数是为了获取前一个button
- (UIButton *)createButtonWithArray:(NSArray *)array idx:(NSInteger)idx{
    UIButton *lastButton = array[idx - 1];
    CGRect lastFrame = lastButton.frame;
    CGFloat x = CGRectGetMaxX(lastFrame) + marginFive;
    CGFloat y = lastFrame.origin.y;
    
    CGRect frame = CGRectZero;
    UIButton *button = (UIButton *)array[idx];
    _btnTotalW += button.frame.size.width + marginFive;
    if (_btnTotalW >= [UIScreen mainScreen].bounds.size.width) {
        // 换行
        x = marginFive;
        y = CGRectGetMaxY(lastFrame) + marginFive;
        _btnTotalW = button.frame.size.width + marginFive;
        _btnTotalH += btnH + marginFive;
        
    }else{
        
    }
    
    [button sizeToFit];
    frame = CGRectMake(x, y, button.bounds.size.width, btnH);
    button.frame = frame;
    return button;
}

- (UIButton *)traverseButtonWithArray:(NSArray *)array idx:(NSInteger)idx{
    UIButton *lastButton = array[idx - 1];
    CGRect lastFrame = lastButton.frame;
    CGFloat x = CGRectGetMaxX(lastFrame) + marginFive;
    CGFloat y = lastFrame.origin.y;
    
    CGRect frame = CGRectZero;
    UIButton *button = (UIButton *)array[idx];
    bW_con += button.frame.size.width + marginFive;
    if (bW_con >= [UIScreen mainScreen].bounds.size.width) {
        // 换行
        x = marginFive;
        y = CGRectGetMaxY(lastFrame) + marginFive;
        bW_con = button.frame.size.width + marginFive;
        bH_con += btnH + marginFive;
        
    }else{
        
    }
    
    [button sizeToFit];
    frame = CGRectMake(x, y, button.bounds.size.width, btnH);
    button.frame = frame;
    return button;
}

/// 生成UIButton
- (UIButton *)buttonWithText:(NSString *)text frame:(CGRect)frame{
    UIButton *button = [[UIButton alloc] initWithFrame:frame];
    
    button.contentEdgeInsets = UIEdgeInsetsMake(0, 10, 0, 10);
    [button setTitle:text forState:UIControlStateNormal];
    button.titleLabel.font = [UIFont systemFontOfSize:14];
    [button sizeToFit];
    
    frame.size.height = 30;
    frame.size.width = button.bounds.size.width;
    
    button.backgroundColor = [UIColor whiteColor];
    [button setTitleColor:[UIColor EDJMainColor] forState:UIControlStateNormal];
    [button cutBorderWithBorderWidth:1 borderColor:[UIColor EDJMainColor] cornerRadius:15];
    
    return button;
}

@end
