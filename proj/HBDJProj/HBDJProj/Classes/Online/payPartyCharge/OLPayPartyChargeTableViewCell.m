//
//  OLPayPartyChargeTableViewCell.m
//  HBDJProj
//
//  Created by Peanut Lee on 2018/5/3.
//  Copyright © 2018年 Lee. All rights reserved.
//

#import "OLPayPartyChargeTableViewCell.h"
#import "OLPayPartyChargeModel.h"

@interface OLPayPartyChargeTableViewCell ()
@property (weak, nonatomic) IBOutlet UILabel *time;
@property (weak, nonatomic) IBOutlet UILabel *status;


@end

@implementation OLPayPartyChargeTableViewCell

- (void)setModel:(OLPayPartyChargeModel *)model{
    _model = model;
    _time.text = model.testTime;
    if (model.isPay) {
        _status.text = @"已交";
        _status.textColor = [UIColor EDJGrayscale_66];
    }else{
        _status.text = @"未交";
        _status.textColor = [UIColor EDJMainColor];
    }
    
}

- (void)awakeFromNib {
    [super awakeFromNib];
    
}


@end
