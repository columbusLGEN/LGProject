//
//  NotificationConstants.h
//  ZProject
//
//  Created by 赵春阳 on 16/9/21.
//  Copyright © 2016年 Z. All rights reserved.
//

#ifndef NotificationConstants_h
#define NotificationConstants_h

/** 更换主题 */
static NSString * const kNotificationThemeChanged    = @"kNotificationThemeChanged";
/** 更换语言 */
static NSString * const kNotificationLanguageChanged = @"kNotificationLanguageChanged";

/** 用户登录 */
static NSString * const kNotificationUserLogin  = @"kNotificationUserLogin";
/** 退出登录 */
static NSString * const kNotificationUserLogout = @"kNotificationUserLogout";

/** 微信登录 */
//static NSString * const kNotificationWXLogin    = @"kNotificationWXLogin";
/** 微信获取 AccessToken */
static NSString * const kNotificationWXAccessToken    = @"kNotificationWXAccessToken";
/** 微信获取 RefreshToken */
static NSString * const kNotificationWXRefreshToken   = @"kNotificationWXRefreshToken";

/** 删除推荐购物车中选中的图书 */
static NSString * const kNotificationRemoveSelectedBook    = @"kNotificationRemoveSelectedBook";
/** 删除推荐购物车中全部的图书 */
static NSString * const kNotificationRemoveAllBooks        = @"kNotificationRemoveAllBooks";
/** 删除推荐购物车中的选中的学生 */
static NSString * const kNotificationRemoveSelectedStudent = @"kNotificationRemoveSelectedStudent";
/** 删除推荐购物车中全部的学生 */
static NSString * const kNotificationRemoveAllStudents     = @"kNotificationRemoveAllStudents";
/** 删除推荐购物车中的选中的教师 */
static NSString * const kNotificationRemoveSelectedTeacher = @"kNotificationRemoveSelectedTeacher";
/** 删除推荐购物车中全部的教师 */
static NSString * const kNotificationRemoveAllTeachers     = @"kNotificationRemoveAllTeachers";


/** 删除推荐购物车中选中的图书 第二步 */
static NSString * const kNotificationRemoveSelectedBook_2    = @"kNotificationRemoveSelectedBook_2";
/** 删除推荐购物车中全部的图书 第二步 */
static NSString * const kNotificationRemoveAllBooks_2        = @"kNotificationRemoveAllBooks_2";
/** 删除推荐购物车中的选中的学生 第二步 */
static NSString * const kNotificationRemoveSelectedStudent_2 = @"kNotificationRemoveSelectedStudent_2";
/** 删除推荐购物车中全部的学生 第二步 */
static NSString * const kNotificationRemoveAllStudents_2     = @"kNotificationRemoveAllStudents_2";
/** 删除推荐购物车中的选中的教师 第二步 */
static NSString * const kNotificationRemoveSelectedTeacher_2 = @"kNotificationRemoveSelectedTeacher_2";
/** 删除推荐购物车中全部的教师 第二步 */
static NSString * const kNotificationRemoveAllTeachers_2     = @"kNotificationRemoveAllTeachers_2";

/** 刷新班级列表 */
static NSString * const kNotificationUpdateClasses  = @"kNotificationUpdateClasses";
/** 刷新教师列表 */
static NSString * const kNotificationUpdateTeachers = @"kNotificationUpdateTeachers";
/** 刷新学生列表 */
static NSString * const kNotificationUpdateStudents = @"kNotificationUpdateStudents";

/** 新建学生 */
static NSString * const kNotificationCreateStudentInfo = @"kNotificationCreateStudentInfo";
/** 修改学生 */
static NSString * const kNotificationUpdateStudentInfo = @"kNotificationUpdateStudentInfo";
/** 删除学生 */
static NSString * const kNotificationDeleteStudentInfo = @"kNotificationDeleteStudentInfo";

/** 新增推荐后刷新推荐列表 */
static NSString * const kNotificationReloadRecommends = @"kNotificationReloadRecommends";
/** 新增授权后刷新授权列表 */
static NSString * const kNotificationReloadImpowers   = @"kNotificationReloadImpowers";

/** 分享图书到朋友圈 */
static NSString * const kNotificationShareBookToDynamic = @"kNotificationShareBookToDynamic";
/** 分享图书给好友 */
static NSString * const kNotificationShareBookToFriend  = @"kNotificationShareBookToFriend";
/** 分享图书到朋友圈成功 */
static NSString * const kNotificationShareBookToDynamicSuccess = @"kNotificationShareBookToDynamicSuccess";
/** 分享图书给好友成功 */
static NSString * const kNotificationShareBookToFriendSuccess  = @"kNotificationShareBookToFriendSuccess";

/** 提示错误 */
static NSString * const kNotificationAlertError = @"kNotificationAlertError";

/** 选择首页 */
static NSString * const kNotificationSelectHome = @"kNotificationSelectHome";
/** 选择用户 */
static NSString * const kNotificationSelectUser = @"kNotificationSelectUser";

/** 收到推送消息 */
static NSString * const kNotificationPush = @"kNotificationPush";

/** 关闭引导页 */
static NSString * const kNotificationCloseLaunch = @"kNotificationCloseLaunch";

/** 修改订单信息 */
static NSString * const kNotificationUpdateOrderInfo = @"kNotificationUpdateOrderInfo";
/** 删除订单信息 */
static NSString * const kNotificationDeleteOrderInfo = @"kNotificationDeleteOrderInfo";
/** 修改包月订单信息 */
static NSString * const kNotificationUpdateSerialInfo = @"kNotificationUpdateSerialInfo";
/** 收藏管理通知 */
static NSString * const kNotificationCollectManage = @"kNotificationCollectManage";
/** value --> 1:添加收藏; 0:移除收藏 */
static NSString *const kNotificationCollectMangeKeyType = @"collectType";

/** 未读消息数量为0 */
static NSString *const kNotificationNoUnReadMessage = @"kNotificationNoUnReadMessage";

#endif /* NotificationConstants_h */
