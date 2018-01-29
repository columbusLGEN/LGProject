//
//  UIViewController+Category.h
//  EasyChineseReading-ios
//
//  Created by 赵春阳 on 17/8/30.
//  Copyright © 2017年 lee. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIViewController(Category)

// 根据类名(string) push 界面（应用于无需传输数据的界面跳转）
- (void)pushToViewControllerWithClassName:(NSString *)className;

/**
 获取当前最顶端 viewController
 */
- (UIViewController *)topViewController;

/**
 返回控制器
 */
- (void)popToViewControllerWithController:(Class)controller completionBlock:(void (^)())completeBlock;

@end
