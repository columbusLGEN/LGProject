//
//  DJThoughtReportDetailTextCell.m
//  HBDJProj
//
//  Created by Peanut Lee on 2018/7/24.
//  Copyright © 2018年 Lee. All rights reserved.
//

#import "DJThoughtReportDetailTextCell.h"
#import "DJThoughtReportDetailModel.h"

@interface DJThoughtReportDetailTextCell ()
@property (weak, nonatomic) IBOutlet UILabel *infoText;

@end

@implementation DJThoughtReportDetailTextCell

- (void)setModel:(DJThoughtReportDetailModel *)model{
    [super setModel:model];
    _infoText.text = model.content;
    
}


- (void)awakeFromNib{
    [super awakeFromNib];
    
}

@end
