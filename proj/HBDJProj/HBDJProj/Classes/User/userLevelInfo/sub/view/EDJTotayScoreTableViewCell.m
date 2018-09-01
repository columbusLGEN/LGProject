//
//  EDJTotayScoreTableViewCell.m
//  HBDJProj
//
//  Created by Peanut Lee on 2018/4/23.
//  Copyright © 2018年 Lee. All rights reserved.
//

#import "EDJTotayScoreTableViewCell.h"
#import "EDJTotayScoreModel.h"

@interface EDJTotayScoreTableViewCell ()
@property (weak, nonatomic) IBOutlet UILabel *item;
@property (weak, nonatomic) IBOutlet UILabel *score;

@end

@implementation EDJTotayScoreTableViewCell

- (void)setModel:(EDJTotayScoreModel *)model{
    _model = model;
    _item.text = [NSString stringWithFormat:@"%@(%@%@)",model.item,model.integraldimension,model.unit];
    _score.text = [NSString stringWithFormat:@"+%@分",model.singleintegral];
}

- (void)awakeFromNib {
    [super awakeFromNib];
    
}



@end
