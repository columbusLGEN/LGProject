//
//  LGRecordButtonLoader.h
//  HBDJProj
//
//  Created by Peanut Lee on 2018/6/9.
//  Copyright © 2018年 Lee. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface LGRecordButtonLoader : NSObject


/**
 将array中的按钮添加到界面上

 @param scrollView 容器scrollview
 @param vc 所属控制器(用于接收按钮的点击等事件)
 @param array 原始数组
 @param action 按钮点击方法
 */
- (void)addButtonTo:(UIScrollView *)scrollView viewController:(UIViewController *)vc array:(NSArray<UIButton *> *)array action:(SEL)action;

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
- (UIButton *)buttonWith:(NSString *)text frame:(CGRect)frame;

@end
