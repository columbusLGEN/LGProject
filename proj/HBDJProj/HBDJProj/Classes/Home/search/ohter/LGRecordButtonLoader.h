//
//  LGRecordButtonLoader.h
//  HBDJProj
//
//  Created by Peanut Lee on 2018/6/9.
//  Copyright © 2018年 Lee. All rights reserved.
//

/// 本类接受 view vc 和 button 参数，将button添加到 view 上，实现代码分离

#import <Foundation/Foundation.h>

@interface LGRecordButtonLoader : NSObject


- (void)addButtonToContainerView:(UIView *)container viewController:(UIViewController *)vc array:(NSArray<UIButton *> *)array action:(SEL)action;

/**
 将array中的按钮添加到界面上

 @param scrollView 容器scrollview
 @param vc 所属控制器(用于接收按钮的点击等事件)
 @param array 原始数组
 @param action 按钮点击方法
 */
- (void)addButtonToScrollView:(UIScrollView *)scrollView viewController:(UIViewController *)vc array:(NSArray<UIButton *> *)array action:(SEL)action;

///**
// 添加一个新的按钮到界面上
//
// @param title 用户输入的内容
// */
//- (void)addANewButtonWithTitle:(NSString *)title;

/**
 根据用户输入的内容生成按钮

 @param text 内容
 @param frame CGRectZero
 @return UIButton
 */
- (UIButton *)buttonWithText:(NSString *)text frame:(CGRect)frame;
- (UIButton *)hotButtonWithText:(NSString *)text frame:(CGRect)frame;

@end
