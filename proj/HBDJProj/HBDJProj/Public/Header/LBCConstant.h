//
//  LBCConstant.h
//  HBDJProj
//
//  Created by Peanut Lee on 2018/4/2.
//  Copyright © 2018年 Lee. All rights reserved.
//

static const CGFloat marginFive = 5;
static const CGFloat marginEight = 8;
static const CGFloat marginTen = 10;
static const CGFloat marginTwelve = 12;
static const CGFloat marginFifteen = 15;
static const CGFloat marginTwenty = 20;

static const CGFloat widthFifty = 50;
static const CGFloat homeImageLoopHeight = 211;
static const CGFloat homeSegmentHeight = 50;
static const CGFloat homeSegmentContentWidth = 38;
static const CGFloat homeMicroLessonHeaderHeight = 148;
static const CGFloat homeMicroLessonSubCellBaseHeight = 90;
static const CGFloat homeMicroLessonHeaderFooterHeight = 55;
static const CGFloat tabBarHeight = 49;

static const CGFloat plusScreenHeight = 736;
static const CGFloat plusScreenWidth = 414;

/** 时间字符串统一判定长度,精确到分 */
static const NSInteger length_timeString = 15;
/** 时间字符串统一判定长度,精确到日 */
static const NSInteger length_timeString_1 = 10;

static NSString * const UserCenterStoryboardName = @"UserCenter";
static NSString * const OnlineStoryboardName = @"Online";
static NSString * const textBold = @"Helvetica-Bold";
static NSString * const testImg = @"party_history";
static NSString * const uploadNeedsCheckString = @"发布成功，请耐心等待管理员审核";
static NSString * const widthheigth = @"widthheigth";
static NSString * const path_key = @"path";
static NSString * const cover_key = @"cover";
static NSString * const mechanismid_key = @"mechanismid";
static NSString * const userid_key = @"userid";
static NSString * const ugctype_key = @"ugctype";
static NSString * const select_key = @"select";
static NSString * const seqid_key = @"seqid";
static NSString * const options_key = @"options";
static NSString * const isLogin_key = @"isLogin";
static NSString * const collectionidKey = @"collectionid";
static NSString * const loginnumKey = @"loginnum";

static NSString *limitTextLength = @"100";
/** 本地偏好中存储客服电话的key */
static NSString * const dj_service_numberKey = @"dj_service_number";

static NSString * const op_failure_notice = @"操作失败，请检查网络后重试";

typedef  void(^LGShowAlertVcActionBlock)(UIAlertAction * _Nonnull action);

#pragma mark - 在线页面相关常量、枚举等
/** 在线首页 实例的 modeltype 与seqid对应 */
typedef NS_ENUM(NSUInteger, OnlineModelType) {
    OnlineModelTypeKnowleageTest = 1,
    OnlineModelTypeVote,
    OnlineModelTypePayPartyFee,
    OnlineModelTypeThreeMeetings,
    OnlineModelTypeThemePartyDay,
    OnlineModelTypeMindReport,
    OnlineModelTypeSpeakCheap,
    OnlineModelTypeSpeakCheapXG/// 孝感党建
};

typedef NS_ENUM(NSUInteger, DJOnlineUGCType) {
    /** 党员舞台 */
    DJOnlineUGCTypeStage = 1,
    /** 思想汇报 */
    DJOnlineUGCTypeMindReport,
    /** 述职述廉 */
    DJOnlineUGCTypeComponce,
};


/// MARK: 函数声明
CGFloat rateForMicroLessonCellHeight(void);
CGFloat rate16_9(void);
