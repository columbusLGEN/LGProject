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
@property (strong,nonatomic) NSMutableArray *buttonArray;

@end

@implementation LGRecordButtonLoader

- (void)addButtonTo:(UIScrollView *)scrollView viewController:(UIViewController *)vc array:(NSArray<UIButton *> *)array action:(SEL)action {
    _btnTotalH = 0;
    _btnTotalW = 0;
    if (scrollView.subviews.count) {
        [scrollView.subviews enumerateObjectsUsingBlock:^(__kindof UIView * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            [obj removeFromSuperview];
        }];
    }
    
    /// 初始化buttonarray
    self.buttonArray = [array mutableCopy];
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
                _btnTotalH = button.frame.size.height + marginFive;
            }
            [button addTarget:vc action:action forControlEvents:UIControlEventTouchUpInside];
            [self.buttonArray addObject:button];
        }];
        
    }
    
    [scrollView setContentSize:CGSizeMake(0, _btnTotalH)];
}


//- (void)addANewButtonWithTitle:(NSString *)title{
//    /// TODO: 添加 buttonarray 判空
//    /// 创建按钮
//    UIButton *freshButton = [self createButtonWithArray:self.buttonArray.copy idx:(self.buttonArray.count - 1)];
//    [freshButton addTarget:_currentvc action:destiAction forControlEvents:UIControlEventTouchUpInside];
//    [_currentScrollv addSubview:freshButton];
//    /// 将按钮添加至buttonarray？
//    [self.buttonArray addObject:freshButton];
//}

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
        _btnTotalH += button.frame.size.height + marginFive;
        
    }else{
        
    }
    
    [button sizeToFit];
    frame = CGRectMake(x, y, button.bounds.size.width, btnH);
    button.frame = frame;
    return button;
}

/// 生成UIButton
- (UIButton *)buttonWith:(NSString *)text frame:(CGRect)frame{
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

- (instancetype)init{
    self = [super init];
    if (self) {
        
    }
    return self;
}
//+ (instancetype)sharedInstance{
//    static id instance;
//    static dispatch_once_t once;
//    dispatch_once(&once, ^{
//        instance = [self new];
//    });
//    return instance;
//}
@end
