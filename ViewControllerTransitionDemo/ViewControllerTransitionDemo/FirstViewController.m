//
//  FirstViewController.m
//  ViewControllerTransitionDemo
//
//  Created by Peanut Lee on 2018/1/19.
//  Copyright © 2018年 LG. All rights reserved.
//

#import "FirstViewController.h"
#import "TestViewController0.h"
#import "LGTransitionAnimater.h"

@interface FirstViewController ()
/** 转场动画代理 */
@property (strong,nonatomic) LGTransitionAnimater *animater;

@end

@implementation FirstViewController

- (IBAction)transitionClick:(UIButton *)sender {
    TestViewController0 *test = [TestViewController0 new];
//    UINavigationController *nav = [[UINavigationController alloc] initWithRootViewController:test];
    
//    // 1.设置转场代理
//    nav.transitioningDelegate = self.animater;
//    // 2.设置转场style 为自定义
//    nav.modalPresentationStyle = UIModalPresentationCustom;
//    // 3.转场动画管理者遵守 转场动画协议, 并实现代理方法
    
    test.transitioningDelegate = self.animater;
    test.modalPresentationStyle = UIModalPresentationCustom;
    
//    nav.modalTransitionStyle = UIModalTransitionStyleFlipHorizontal;// 系统提供的转场效果
    
    [self presentViewController:test animated:YES completion:nil];
    
    
//    https://github.com/seedante/iOS-ViewController-Transition-Demo/blob/master/CustomModalTransition/CustomModalTransition/SDEModalTransitionDelegate.swift

}

- (LGTransitionAnimater *)animater{
    if (_animater == nil) {
        _animater = [LGTransitionAnimater new];
//        NSLog(@"transitionDuration -- %d",[_animater respondsToSelector:@selector(transitionDuration:)]);
//        NSLog(@"animateTransition -- %d",[_animater respondsToSelector:@selector(animateTransition:)]);
    }
    return _animater;
}


@end
