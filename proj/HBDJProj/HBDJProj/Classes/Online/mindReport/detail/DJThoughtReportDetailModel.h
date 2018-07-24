//
//  DJThoughtReportDetailModel.h
//  HBDJProj
//
//  Created by Peanut Lee on 2018/7/24.
//  Copyright © 2018年 Lee. All rights reserved.
//

#import "DJThoutghtRepotListModel.h"

typedef NS_ENUM(NSUInteger, DJThoughtReportDetailModelType) {
    DJThoughtReportDetailModelTypeHeaderInfo,
    DJThoughtReportDetailModelTypeContent,
    DJThoughtReportDetailModelTypeImage,
};

@interface DJThoughtReportDetailModel : DJThoutghtRepotListModel
@property (assign,nonatomic) DJThoughtReportDetailModelType type;

@end
