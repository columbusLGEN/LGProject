//
//  HPBookInfoBaseCell.m
//  HBDJProj
//
//  Created by Peanut Lee on 2018/5/2.
//  Copyright © 2018年 Lee. All rights reserved.
//

#import "HPBookInfoBaseCell.h"
#import "HPBookInfoModel.h"

@implementation HPBookInfoBaseCell

+ (NSString *)cellReuseIdWithModel:(HPBookInfoModel *)model{
    if (model.isHeader) {
        return @"HPBookInfoHeaderCell";
    }else{
        return @"HPBookInfoBriefCell";
    }
}

+ (CGFloat)cellHeightWithModel:(HPBookInfoModel *)model{
    if (model.isHeader) {
        return 220;
    }else{
        return model.cellHeight;
    }
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
