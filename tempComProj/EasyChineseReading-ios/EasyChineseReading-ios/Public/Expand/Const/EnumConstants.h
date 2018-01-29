//
//  EnumConstants.h
//  ZProject
//
//  Created by 赵春阳 on 16/9/21.
//  Copyright © 2016年 Z. All rights reserved.
//

#ifndef EnumConstants_h
#define EnumConstants_h

#import <Foundation/Foundation.h>

#pragma mark - 网络请求方式
/** 网络请求, 本项目所有请求都用 post */
typedef NS_ENUM(NSUInteger, ENUM_ZHttpRequestMethod) {
    /** 增加数据 */
    ENUM_ZHttpRequestMethodPost = 1,
    /** 获取数据 */
    ENUM_ZHttpRequestMethodGet,
    /** 修改数据 */
    ENUM_ZHttpRequestMethodPut,
    /** 删除数据 */
    ENUM_ZHttpRequestMethodDelete,
};

#pragma mark - 安全中心操作
/** 安全中心操作 (密码, 邮箱, 手机, 支付, 忘记)*/
typedef NS_ENUM(NSUInteger, ENUM_ZUserSecurityCenterUpdateMethod) {
    /** 修改登录密码 */
    ENUM_ZUserSecurityCenterUpdateMethodPassword = 0,
    /** 绑定（修改）邮箱 */
    ENUM_ZUserSecurityCenterUpdateMethodEmail,
    /** 修改手机号 */
    ENUM_ZUserSecurityCenterUpdateMethodPhone,
    /** 修改支付密码 */
    ENUM_ZUserSecurityCenterUpdateMethodPay,
    /** 忘记密码 */
    ENUM_ZUserSecurityCenterUpdateMethodForget,
};

#pragma mark - 订单支付状态
/** 订单支付状态 (待付款, 待评价, 完成, 支付中, 取消, 删除, 全部)*/
typedef NS_ENUM(NSUInteger, ENUM_ZOrderState) {
    /** 待付款 */
    ENUM_ZOrderStateObligation = 0,
    /** 待评价 */
    ENUM_ZOrderStateScore,
    /** 完成 */
    ENUM_ZOrderStateDone,
    /** 支付中 */
    ENUM_ZOrderStatePaying,
    /** 取消订单 */
    ENUM_ZOrderStateCancel,
    /** 删除订单 */
    ENUM_ZOrderStateDelete,
    /** 全部 */
    ENUM_ZOrderStateAll,
};

#pragma mark - 创建订单类型
/** 创建订单状态（购买, 租赁, 续租, 充值, 全平台租赁） */
typedef NS_ENUM(NSUInteger, ENUM_PayPurpose) {
    /** 购买 */
    ENUM_PayPurposeBuy = 0,
    /** 租赁 */
    ENUM_PayPurposeLease,
    /** 续租 */
    ENUM_PayPurposeContinue,
    /** 充值 */
    ENUM_PayPurposeRecharge,
    /** 全平台租赁 */
    ENUM_PayPurposeAllLease,
};

#pragma mark - 验证码类型
/** 验证码类型（注册, 密码, 邮箱） */
typedef NS_ENUM(NSUInteger, ENUM_VerifyCodeType) {
    /** 注册 */
    ENUM_VerifyCodeTypeRegister = 1,
    /** 修改密码 */
    ENUM_VerifyCodeTypeModifyPwd,
    /** 修改邮箱 */
    ENUM_VerifyCodeTypeEmail,
};

#pragma mark - 修改密码类型
/** 修改密码类型（登录, 支付） */
typedef NS_ENUM(NSUInteger, ENUM_UpdatePasswordType) {
    /** 登录密码 */
    ENUM_UpdatePasswordTypeLogin = 1,
    /** 支付密码 */
    ENUM_UpdatePasswordTypePay,
};

#pragma mark - 验证码验证方式
/** 验证码验证方式（手机, 邮箱) */
typedef NS_ENUM(NSUInteger, ENUM_AccountType) {
    /** 手机验证 */
    ENUM_AccountTypePhone = 1,
    /** 邮箱验证 */
    ENUM_AccountTypeEmail,
};

#pragma mark - 用户类型
/** 用户类型（个人, 机构, 教师, 学生） */
typedef NS_ENUM(NSUInteger, ENUM_UserType) {
    /** 个人用户 */
    ENUM_UserTypePerson = 1,
    /** 机构用户 */
    ENUM_UserTypeOrganization = 3,
    /** 教师 */
    ENUM_UserTypeTeacher = 4,
    /** 学生 */
    ENUM_UserTypeStudent = 5,
};

#pragma mark - 登录类型
/** 登录类型（token登录,  密码） */
typedef NS_ENUM(NSUInteger, ENUM_LoginType) {
    /** token登录 已经登录过账号关闭app后重新打开 验证token有效期 */
    ENUM_LoginTypeToken = 1,
    /** 密码登录 退出登录重新登录 或首次登录 */
    ENUM_LoginTypePassword = 2,
};

#pragma mark - 图书获取方式 

/** 图书获取方式（购买, 租赁） */
typedef NS_ENUM(NSUInteger, ENUM_GetBookType) {
    /** 购买 */
    ENUM_GetBookTypeBuy = 1,
    /** 租赁 */
    ENUM_GetBookTypeLease,
};

#pragma mark - 购物车操作方式

/** 购物车操作方式（添加, 删除） */
typedef NS_ENUM(NSUInteger, ENUM_ShopCarAction) {
    /** 添加到购物车 */
    ENUM_ShopCarActionAdd = 1,
    /** 从购物车中删除 */
    ENUM_ShopCarActionDelete,
};

#pragma mark - 收藏操作方式

/** 收藏操作方式（删除, 添加） */
typedef NS_ENUM(NSUInteger, ENUM_FavouriteActionType) {
    /** 删除收藏 */
    ENUM_FavouriteActionTypeDelete = 0,
    /** 添加收藏 */
    ENUM_FavouriteActionTypeAdd = 1,
};

#pragma mark - 收藏排序
/** 收藏排序（时间, 价格, 热度） */
typedef NS_ENUM(NSUInteger, ENUM_FavouriteSortType) {
    /** 时间降序 */
    ENUM_FavouriteSortTypeTimeDown = 0,
    /** 时间升序 */
    ENUM_FavouriteSortTypeTimeUp,
    /** 价格降序 */
    ENUM_FavouriteSortTypePriceDown,
    /** 价格升序 */
    ENUM_FavouriteSortTypePriceUp,
    /** 收藏人数降序 */
    ENUM_FavouriteSortTypeHotDown,
    /** 收藏人数升序 */
    ENUM_FavouriteSortTypeHotUp,
};

#pragma mark - 积分变化类型

/** 积分变化类型（花费，获取，赠送，卡券充值） */
typedef NS_ENUM(NSUInteger, ENUM_IntegralType) {
    /** 花费积分 */
    ENUM_IntegralTypeCost = 0,
    /** 获取积分 */
    ENUM_IntegralTypeGet,
    /** 赠送 */
    ENUM_IntegralTypeGive,
    /** 卡券充值 */
    ENUM_IntegralTypeTicket,
};

#pragma mark - 语言类型

/** 语言类型(中文, English) */
typedef NS_ENUM(NSUInteger, ENUM_LanguageType) {
    /** 汉语 */
    ENUM_LanguageTypeChinese = 0,
    /** 英语 */
    ENUM_LanguageTypeEnglish,
};

#pragma mark - 任务类型

/** 任务类型（每日, 长期） */
typedef NS_ENUM(NSUInteger, ENUM_TaskType) {
    /** 每日任务 */
    ENUM_TaskTypeEveryDay = 0,
    /** 长期任务 */
    ENUM_TaskTypeLongTime,
};

#pragma mark - 支付方式

/** 支付方式选择（virtualCurrency, apple, ali, wechat） */
typedef NS_ENUM(NSUInteger, ENUM_PayType) {
    /** 虚拟币支付 */
    ENUM_PayTypeVirtualCurrency = 0,
    /** 苹果支付 */
    ENUM_PayTypeApplePay,
    /** 支付宝 */
    ENUM_PayTypeAliPay,
    /** 微信 */
    ENUM_PayTypeWeChat,
};

#pragma mark - 任务状态

/** 任务状态 (未完成, 完成, 已领取) */
typedef NS_ENUM(NSUInteger, ENUM_TaskStatusType) {
    /** 未完成 */
    ENUM_TaskStatusTypeUnFinish = 1,
    /** 完成 */
    ENUM_TaskStatusTypeDone = 3,
    /** 已领取 */
    ENUM_TaskStatusTypeGetIntegral = 4,
};

#pragma mark - 学校类型

/** 学校类型(小学, 中学, 大学, 教育机构) */
typedef NS_ENUM(NSUInteger, ENUM_SchoolType) {
    /** 小学 */
    ENUM_SchoolTypePrimary = 0,
    /** 中学 */
    ENUM_SchoolTypeSecondary,
    /** 大学 */
    ENUM_SchoolTypeUniversity,
    /** 教育机构 */
    ENUM_SchoolTypeEducational,
};

#pragma mark - 推荐图书类型

/** 推荐图书类型(推荐, 授权) */
typedef NS_ENUM(NSUInteger, ENUM_RecommendType) {
    /** 推荐 */
    ENUM_RecommendTypeRecommend = 0,
    /** 授权 */
    ENUM_RecommendTypeImpower,
};

#pragma mark - 更新类型

/** 更新类型(无操作, 创建, 修改, 删除) */
typedef NS_ENUM(NSUInteger, ENUM_UpdateType) {
    /** 没有任何操作 */
    ENUM_UpdateTypeNo = 0,
    /** 创建 */
    ENUM_UpdateTypeAdd,
    /** 修改 */
    ENUM_UpdateTypeUp,
    /** 删除 */
    ENUM_UpdateTypeDelete,
};

#pragma mark - 性别类型

/** 性别类型(男, 女) */
typedef NS_ENUM(NSUInteger, ENUM_SexType) {
    /** 男 */
    ENUM_SexTypeMan = 0,
    /** 女 */
    ENUM_SexTypeWoMan,
};

#pragma mark - 消息类型

/** 消息类型(专题, 系统消息, 站内信, 卡券, 活动) */
typedef NS_ENUM(NSUInteger, ENUM_MessageType) {
    /** 专题 */
    ENUM_MessageTypeActivity = 0,
    /** 系统消息 */
    ENUM_MessageTypeSystem,
    /** 站内信 */
    ENUM_MessageTypeChat,
    /** 卡券 */
    ENUM_MessageTypeCoupon,
    /** 活动 */
    ENUM_MessageTypeUrl,
    /** 不是消息的内容 */
    ENUM_MessageTypeUnknow,
};

#pragma mark - 消息阅读类型

/** 消息阅读类型(未读, 已读) */
typedef NS_ENUM(NSUInteger, ENUM_MessageReadType) {
    /** 未读 */
    ENUM_MessageReadTypeUnRead = 0,
    /** 已读 */
    ENUM_MessageReadTypeReaded,
};

#pragma mark - 数据为空的类型

/** 数据为空的类型(未知, 搜索结构, 没有网络,  没有好友, 没有添加购物车, 没有界面, 没有班级, 没有教师, 没有学生, 没有卡券) */
typedef NS_ENUM(NSUInteger, ENUM_EmptyResultType) {
    /** 未知 */
    ENUM_EmptyResultTypeUnknow = 0,
    /** 没有数据 */
    ENUM_EmptyResultTypeData,
    /** 搜索结构 */
    ENUM_EmptyResultTypeSearch,
    /** 没有网络 */
    ENUM_EmptyResultTypeNetwork,
    /** 没有好友 */
    ENUM_EmptyResultTypeFriend,
    /** 没有添加购物车 */
    ENUM_EmptyResultTypeShopCar,
    /** 没有班级 */
    ENUM_EmptyResultTypeClass,
    /** 没有教师 */
    ENUM_EmptyResultTypeTeacher,
    /** 没有学生 */
    ENUM_EmptyResultTypeStudent,
    /** 没有卡券 */
    ENUM_EmptyResultTypeTicket,
};

#pragma mark - 卡券的使用情况

/** 卡券的使用情况(未领取, 已领取, 已使用或失效) */
typedef NS_ENUM(NSUInteger, ENUM_TicketStatus)
{
    /** 未领取 */
    ENUM_TicketStatusHaveNot = 0,
    /** 已领取 */
    ENUM_TicketStatusHave,
    /** 已使用, 失效 */
    ENUM_TicketStatusUsed
};

#pragma mark - 卡券的类型

/** 卡券的类型(满减, 充值, 阅读) */
typedef NS_ENUM(NSUInteger, ENUM_TicketType)
{
    /** 满减券 */
    ENUM_TicketTypeDiscount = 0,
    /** 充值券 */
    ENUM_TicketTypeRecharge,
    /** 阅读卡 */
    ENUM_TicketTypeReading,
};

#pragma mark - 分享到

/** 分享到(朋友, 朋友圈) */
typedef NS_ENUM(NSUInteger, ENUM_ShareType)
{
    /** 朋友 */
    ENUM_ShareTypeFriend = 0,
    /** 好友动态 */
    ENUM_ShareTypeDynamic,
};

#endif /* EnumConstants_h */
