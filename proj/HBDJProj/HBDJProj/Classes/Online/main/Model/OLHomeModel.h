//
//  OLHomeModel.h
//  HBDJProj
//
//  Created by Peanut Lee on 2018/4/25.
//  Copyright © 2018年 Lee. All rights reserved.
//

#import "LGBaseModel.h"

typedef NS_ENUM(NSUInteger, OnlineModelType) {
    OnlineModelTypeThreeMeetings,
    OnlineModelTypeThemePartyDay,
    OnlineModelTypeMindReport,
    OnlineModelTypeKnowleageTest,
    OnlineModelTypeSpeakCheap,
    OnlineModelTypePayPartyFee,
    OnlineModelTypeVote
};
typedef NS_ENUM(NSUInteger, ControllerInitType) {
    ControllerInitTypeCode,
    ControllerInitTypeStoryboard,
};

@interface OLHomeModel : LGBaseModel

/** YES: 该项服务已经开通，NO:该项服务还未开通 */
@property (assign,nonatomic) BOOL limit;
@property (copy,nonatomic) NSString *imgName_haveLimit;
@property (copy,nonatomic) NSString *imgName_noLimit;

@property (copy,nonatomic) NSString *title;
@property (assign,nonatomic) OnlineModelType modelType;

@property (assign,nonatomic) ControllerInitType controllerInitType;
@property (copy,nonatomic) NSString *storyboardName;
@property (copy,nonatomic) NSString *controllerID;



@end
