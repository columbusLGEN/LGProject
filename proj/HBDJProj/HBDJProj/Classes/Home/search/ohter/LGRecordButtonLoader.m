//
//  LGRecordButtonLoader.m
//  HBDJProj
//
//  Created by Peanut Lee on 2018/6/9.
//  Copyright © 2018年 Lee. All rights reserved.
//

#import "LGRecordButtonLoader.h"

#define btnH 30

@interface LGRecordButtonLoader ()

@property (assign,nonatomic) CGFloat btnTotalW;
@property (assign,nonatomic) CGFloat btnTotalH;

@end

@implementation LGRecordButtonLoader

+ (void)addButtonTo:(UIScrollView *)scrollView viewController:(UIViewController *)vc array:(NSArray<UIButton *> *)array action:(SEL)action{
    [[self sharedInstance] addButtonTo:scrollView viewController:vc array:array action:action];
}
- (void)addButtonTo:(UIScrollView *)scrollView viewController:(UIViewController *)vc array:(NSArray<UIButton *> *)array action:(SEL)action {
    if (array.count == 0) {
    }else{
        
        [array enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            
            UIButton *button;
            if (idx > 0) {// 之后的所有按钮
                UIButton *lastButton = array[idx - 1];
                CGRect lastFrame = lastButton.frame;
                CGFloat x = CGRectGetMaxX(lastFrame) + marginFive;
                CGFloat y = lastFrame.origin.y;
                
                CGRect frame = CGRectZero;
                button = (UIButton *)obj;
                _btnTotalW += button.frame.size.width + marginFive;
                if (_btnTotalW >= [UIScreen mainScreen].bounds.size.width) {
                    // 换行
                    x = marginFive;
                    y = CGRectGetMaxY(lastFrame) + marginFive;
                    _btnTotalW = button.frame.size.width + marginFive;
                    
                    _btnTotalH += button.frame.size.height + marginFive;
                    
//                    if (_btnTotalH >= self.frame.size.height) {
//                        CGRect frame = self.frame;
//                        frame.size.height = _btnTotalH + marginFive;
//                        self.frame = frame;
//                    }
                }else{
                    
                }
                
                [button sizeToFit];
                frame = CGRectMake(x, y, button.bounds.size.width, btnH);
                button.frame = frame;
                
                [scrollView addSubview:button];
                
            }else{
                button = (UIButton *)obj;// 第一个按钮
                button.frame = CGRectMake(marginFive, marginFive, button.bounds.size.width, btnH);
                [scrollView addSubview:button];
                _btnTotalW += button.frame.size.width + marginFive;
                _btnTotalH = button.frame.size.height + marginFive;
            }
            [button addTarget:vc action:action forControlEvents:UIControlEventTouchUpInside];
//            NSLog(@"%zd.frame: %@",idx,NSStringFromCGRect(button.frame));
            
        }];
        
    }
    
    [scrollView setContentSize:CGSizeMake(0, _btnTotalH)];
}
+ (UIButton *)buttonWith:(NSString *)text frame:(CGRect)frame{
    return [[self sharedInstance] buttonWith:text frame:frame];
}
- (UIButton *)buttonWith:(NSString *)text frame:(CGRect)frame{
    UIButton *button = [[UIButton alloc] initWithFrame:frame];
    
    button.contentEdgeInsets = UIEdgeInsetsMake(0, 10, 0, 10);
    button.backgroundColor = [UIColor orangeColor];
    [button setTitle:text forState:UIControlStateNormal];
    [button setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    button.titleLabel.font = [UIFont systemFontOfSize:14];
    [button sizeToFit];
    
    frame.size.height = 30;
    frame.size.width = button.bounds.size.width;
    
    button.frame = frame;
    
    return button;
}

+ (instancetype)sharedInstance{
    static id instance;
    static dispatch_once_t once;
    dispatch_once(&once, ^{
        instance = [self new];
    });
    return instance;
}
@end
