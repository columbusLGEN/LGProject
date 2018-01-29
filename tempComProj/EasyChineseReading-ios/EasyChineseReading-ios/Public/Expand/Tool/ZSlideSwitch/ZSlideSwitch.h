//
//  ZSlideSwitch.h
//  EasyChineseReading-ios
//
//  Created by 赵春阳 on 17/9/2.
//  Copyright © 2017年 lee. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ZSlideSwitchDelegate.h"

@interface ZSlideSwitch : UIView

/**
 * 需要显示的视图
 */
@property (strong, nonatomic) NSArray *arrViewControllers;
/**
 * 标题
 */
@property (strong, nonatomic) NSArray *arrTitles;
/**
 * 选中位置
 */
@property (assign, nonatomic) NSInteger selectedIndex;
/**
 * 按钮正常时的颜色
 */
@property (strong, nonatomic) UIColor *normalColor;
/**
 * 按钮选中时的颜色
 */
@property (strong, nonatomic) UIColor *selectedColor;
/**
 * 隐藏阴影
 */
@property (assign, nonatomic) BOOL hideShadow;

/* 滚动 */
@property (assign, nonatomic) BOOL canScroll;
/**
 * 代理方法
 */
@property (weak, nonatomic) id <ZSlideSwitchDelegate> delegate;
/**
 * 初始化方法
 */
-(instancetype)initWithFrame:(CGRect)frame titles:(NSArray <NSString *>*)titles viewControllers:(NSArray <UIViewController *>*)viewControllers;
-(instancetype)initWithFrame:(CGRect)frame titles:(NSArray <NSString *>*)titles viewControllers:(NSArray <UIViewController *>*)viewControllers canScroll:(BOOL)canScroll needCenter:(BOOL)needCenter;
/**
 * 标题显示在ViewController中
 */
-(void)showInViewController:(UIViewController *)viewController;
/**
 * 标题显示在NavigationBar中
 */
-(void)showInNavigationController:(UINavigationController *)navigationController;

@end
