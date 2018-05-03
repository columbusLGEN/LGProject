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

@interface OLHomeModel : LGBaseModel
@property (copy,nonatomic) NSString *imgName;
@property (copy,nonatomic) NSString *title;
@property (assign,nonatomic) OnlineModelType modelType;

@end
