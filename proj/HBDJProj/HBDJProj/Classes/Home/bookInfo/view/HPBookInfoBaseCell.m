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

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
