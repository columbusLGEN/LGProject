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
static const CGFloat homeMicroLessonHeaderHeight = 128;
static const CGFloat homeMicroLessonSubCellBaseHeight = 90;
static const CGFloat homeMicroLessonHeaderFooterHeight = 55;
static const CGFloat tabBarHeight = 49;
static const CGFloat richTextTopInfoViewHeight = 110;

static const CGFloat plusScreenHeight = 736;
static const CGFloat plusScreenWidth = 414;

/** 时间字符串统一判定长度 */
static const NSInteger length_timeString = 15;

static NSString * const UserCenterStoryboardName = @"UserCenter";
static NSString * const OnlineStoryboardName = @"Online";
static NSString * const textBold = @"Helvetica-Bold";
static NSString * const testImg = @"party_history";

#pragma mark - 在线页面相关常量、枚举等
/** 在线首页 实例的 modeltype 与seqid对应 */
typedef NS_ENUM(NSUInteger, OnlineModelType) {
    OnlineModelTypeKnowleageTest = 1,
    OnlineModelTypeVote,
    OnlineModelTypePayPartyFee,
    OnlineModelTypeThreeMeetings,
    OnlineModelTypeThemePartyDay,
    OnlineModelTypeMindReport,
    OnlineModelTypeSpeakCheap
};


/// MARK: 函数声明
CGFloat rateForMicroLessonCellHeight(void);
CGFloat rate16_9(void);
