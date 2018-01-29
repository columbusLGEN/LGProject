//
//  ECRBaseViewController.h
//  EasyChineseReading-ios
//
//  Created by lee on 2017/8/29.
//  Copyright © 2017年 lee. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSUInteger, ECRBaseControllerPushWay) {
    ECRBaseControllerPushWayPush,
    ECRBaseControllerPushWayModal,
};

@interface ECRBaseViewController : UIViewController

@property (assign,nonatomic) ECRBaseControllerPushWay viewControllerPushWay;

/**
 更换主题 
 */
- (void)reloadThemeImage;

/**
 自定义顶部导航栏返回按钮
 */
- (void)createNavLeftBackItem;

/**
 销毁控制器
 */
- (void)baseViewControllerDismiss;

/**
 检查是否登录
 
 @param unLogin 未登录回调
 */
//- (void)checkLogin:(void(^)())unLogin;

/**
 修改 app 语言
 */
- (void)updateSystemLanguage;

/**
 修改系统主题
 */
- (void)updateSystemTheme;
- (void)textDependsLauguage;

@end
