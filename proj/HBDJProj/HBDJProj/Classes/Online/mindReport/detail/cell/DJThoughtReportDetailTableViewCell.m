//
//  DJThoughtReportDetailTableViewCell.m
//  HBDJProj
//
//  Created by Peanut Lee on 2018/7/24.
//  Copyright © 2018年 Lee. All rights reserved.
//

#import "DJThoughtReportDetailTableViewCell.h"
#import "DJThoughtReportDetailModel.h"

@implementation DJThoughtReportDetailTableViewCell

- (void)setModel:(DJThoughtReportDetailModel *)model{
    _model = model;
    
}

+ (NSString *)cellReuseIdWithModel:(DJThoughtReportDetailModel *)model{
    switch (model.type) {
        case DJThoughtReportDetailModelTypeHeaderInfo:
            return trdHeaderCell;
            break;
        case DJThoughtReportDetailModelTypeContent:
            return trdTextCell;
            break;
        case DJThoughtReportDetailModelTypeImage:
            return trdNineImageCell;
            break;

    }
}

@end
