//
//  ECRHomeMainModel.m
//  EasyChineseReading-ios
//
//  Created by lee on 2017/8/29.
//  Copyright © 2017年 lee. All rights reserved.
//

#import "ECRHomeMainModel.h"

@implementation ECRHomeMainModel

+ (NSDictionary *)mj_objectClassInArray{
    return @{@"Rank": @"ECRRankUser",
             @"Advertisement": @"ECRAdvModel",
             @"thematic": @"ECRThematicModel",
             @"Series": @"ECRSeriesModel",
             @"reco": @"ECRHomeBook",
             @"SeriesClassif": @"ECRClassSortModel"
             };
}


@end
