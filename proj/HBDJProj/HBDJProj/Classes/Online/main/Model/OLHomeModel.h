//
//  OLHomeModel.h
//  HBDJProj
//
//  Created by Peanut Lee on 2018/4/25.
//  Copyright © 2018年 Lee. All rights reserved.
//

#import "LGBaseModel.h"

/** 实例的 modeltype 与seqid对应 */
typedef NS_ENUM(NSUInteger, OnlineModelType) {
    OnlineModelTypeKnowleageTest = 1,
    OnlineModelTypeVote,
    OnlineModelTypePayPartyFee,
    OnlineModelTypeThreeMeetings,
    OnlineModelTypeThemePartyDay,
    OnlineModelTypeMindReport,
    OnlineModelTypeSpeakCheap
};
typedef NS_ENUM(NSUInteger, ControllerInitType) {
    ControllerInitTypeCode,
    ControllerInitTypeStoryboard,
};

@interface OLHomeModel : LGBaseModel

/** 获取 “更多” 项 */
+ (instancetype)loadItemOfMore;

/** 1: 默认激活
    0:
    该字段用于后台判断，客户端不处理
 */
@property (assign,nonatomic) BOOL isDefault;
@property (strong,nonatomic) NSString *toolname;
@property (strong,nonatomic) NSString *iconUrl;

/// 本地图标name
@property (strong,nonatomic) NSString *locaImage;

@property (assign,nonatomic) OnlineModelType modelType;

@end
