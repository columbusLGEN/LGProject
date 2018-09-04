//
//  EDJTotayScoreTableViewCell.m
//  HBDJProj
//
//  Created by Peanut Lee on 2018/4/23.
//  Copyright © 2018年 Lee. All rights reserved.
//

#import "EDJTotayScoreTableViewCell.h"
#import "EDJLevelInfoModel.h"

@interface EDJTotayScoreTableViewCell ()
@property (weak, nonatomic) IBOutlet UILabel *item;
@property (weak, nonatomic) IBOutlet UILabel *score;

@end

@implementation EDJTotayScoreTableViewCell

- (void)setModel:(EDJLevelInfoModel *)model{
    _model = model;
    _item.text = [NSString stringWithFormat:@"%@(%ld%@)",model.item,model.completenum,model.unit];
    _score.text = [NSString stringWithFormat:@"+%ld分",model.getintegral];
}

- (void)awakeFromNib {
    [super awakeFromNib];
    
}



@end
