//
//  LGTransitionAnimater.h
//  ViewControllerTransitionDemo
//
//  Created by Peanut Lee on 2018/1/19.
//  Copyright © 2018年 LG. All rights reserved.
//

//UIViewControllerTransitioningDelegate
//UIViewControllerAnimatedTransitioning     --- 非交互式场景
//UIViewControllerInteractiveTransitioning
//UIViewControllerTransitionCoordinator

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface LGTransitionAnimater : NSObject <
UIViewControllerTransitioningDelegate,
UIViewControllerAnimatedTransitioning>

@end
