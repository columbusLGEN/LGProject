//
//  LGTransitionAnimater.m
//  ViewControllerTransitionDemo
//
//  Created by Peanut Lee on 2018/1/19.
//  Copyright © 2018年 LG. All rights reserved.
//

#import "LGTransitionAnimater.h"

@interface LGTransitionAnimater ()


@end

@implementation LGTransitionAnimater

#pragma mark - UIViewControllerAnimatedTransitioning
// MARK: 返回动画时间
- (NSTimeInterval)transitionDuration:(nullable id <UIViewControllerContextTransitioning>)transitionContext{
    NSLog(@" -- %s",__func__);
    return 1.0;
}
// MARK: 执行动画的地方,最核心的方法
- (void)animateTransition:(id <UIViewControllerContextTransitioning>)transitionContext{
    NSLog(@" -- %s",__func__);
}
//// MARK: 转场之后调用,执行收尾工作
//- (void)animationEnded:(BOOL)transitionCompleted{
//
//}


@end
