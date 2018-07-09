//
//  DJTestScoreListTableViewCell.m
//  HBDJProj
//
//  Created by Peanut Lee on 2018/7/9.
//  Copyright © 2018年 Lee. All rights reserved.
//

#import "DJTestScoreListTableViewCell.h"
#import "DJTestScoreListLabel.h"
#import "DJTestScoreListModel.h"

@interface DJTestScoreListTableViewCell ()
@property (weak, nonatomic) IBOutlet DJTestScoreListLabel *rank;
@property (weak, nonatomic) IBOutlet DJTestScoreListLabel *name;
@property (weak, nonatomic) IBOutlet DJTestScoreListLabel *time;
@property (weak, nonatomic) IBOutlet DJTestScoreListLabel *rate;


@end

@implementation DJTestScoreListTableViewCell

- (void)setModel:(DJTestScoreListModel *)model{
    _model = model;
    _rank.text = model.rank;
    _name.text = model.name;
    _time.text = model.timeConsume;
    _rate.text = model.correctRate;
}

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}


@end
