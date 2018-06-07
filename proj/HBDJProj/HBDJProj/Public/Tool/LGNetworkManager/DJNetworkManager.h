//
//  DJNetworkManager.h
//  HBDJProj
//
//  Created by Peanut Lee on 2018/6/6.
//  Copyright © 2018年 Lee. All rights reserved.
//

/// MARK: 党建项目专用请求管理者

#import <Foundation/Foundation.h>

typedef void(^DJNetworkSuccess)(id responseObj);
typedef void(^DJNetworkFailure)(id failureObj);

/** 1新闻;2微党课;3学习问答;4支部动态;5党员舞台 */
typedef NS_ENUM(NSUInteger, DJDataPraisetype) {
    /** 新闻 */
    DJDataPraisetypeNews = 1,
    /** 微党课 */
    DJDataPraisetypeMicrolesson,
    /** 学习问答 */
    DJDataPraisetypeQA,
    /** 支部动态 */
    DJDataPraisetypeState,
    /** 党员舞台 */
    DJDataPraisetypeStage
};

@interface DJNetworkManager : NSObject

/// MARK: 数字阅读图书详情
+ (void)homeDigitalDetailWithId:(NSString *)id success:(DJNetworkSuccess)success failure:(DJNetworkFailure)failure;

/**
 党建要闻详情接口

 @param id 数据id
 @param type 1新闻;2微党课;3学习问答;4支部动态;5党员舞台
 @param success success
 @param failure failure
 */
+ (void)homePointNewsDetailWithId:(NSString *)id type:(DJDataPraisetype)type success:(DJNetworkSuccess)success failure:(DJNetworkFailure)failure;
/**
 点赞/收藏
 

 @param seqid 主键id
 @param add 0:添加 1:删除
 @param praisetype 数据类型
 @param collect 1：收藏。0：点赞
 */
+ (void)homeLikeSeqid:(NSString *)seqid add:(BOOL)add praisetype:(DJDataPraisetype)praisetype success:(DJNetworkSuccess)success failure:(DJNetworkFailure)failure collect:(BOOL)collect;
/// MARK: 主席要闻列表,专辑列表
+ (void)homeChairmanPoineNewsClassid:(NSString *)classid offset:(NSInteger)offset length:(NSInteger)length sort:(NSInteger)sort success:(DJNetworkSuccess)success failure:(DJNetworkFailure)failure;
/// MARK: 搜索接口
+ (void)homeSearchWithString:(NSString *)string type:(NSInteger)type offset:(NSInteger)offset length:(NSInteger)length sort:(NSInteger)sort success:(DJNetworkSuccess)success failure:(DJNetworkFailure)failure;
/// MARK: 首页接口
+ (void)homeIndexWithSuccess:(DJNetworkSuccess)success failure:(DJNetworkFailure)failure;

+ (instancetype)sharedInstance;
@end
