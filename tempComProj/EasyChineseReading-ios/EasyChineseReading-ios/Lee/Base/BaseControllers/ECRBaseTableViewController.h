//
//  ECRBaseTableViewController.h
//  EasyChineseReading-ios
//
//  Created by 赵春阳 on 17/8/30.
//  Copyright © 2017年 lee. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSUInteger, ECRBaseTBControllerPushWay) {
    LEEBaseTBControllerPushWayPush,
    LEEBaseTBControllerPushWayModal,
};

@interface ECRBaseTableViewController : UITableViewController

@property (assign,nonatomic) ECRBaseTBControllerPushWay viewControllerPushWay;

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

@end
