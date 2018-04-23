//
//  EDJLevelInsTableViewCell.m
//  HBDJProj
//
//  Created by Peanut Lee on 2018/4/23.
//  Copyright © 2018年 Lee. All rights reserved.
//

#import "EDJLevelInsTableViewCell.h"
#import "EDJLevelInsModel.h"

@interface EDJLevelInsTableViewCell ()
@property (weak, nonatomic) IBOutlet UILabel *level;
@property (weak, nonatomic) IBOutlet UILabel *levelName;
@property (weak, nonatomic) IBOutlet UILabel *needsScore;



@end

@implementation EDJLevelInsTableViewCell

- (void)setModel:(EDJLevelInsModel *)model{
    _model = model;
    _level.text = model.level.stringValue;
    _levelName.text = model.levelName;
    _needsScore.text = model.needScore.stringValue;
}

- (void)awakeFromNib {
    [super awakeFromNib];
    
}


@end
