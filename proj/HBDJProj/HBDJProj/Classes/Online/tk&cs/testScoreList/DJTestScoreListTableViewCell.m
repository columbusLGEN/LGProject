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

- (void)setIndexPath:(NSIndexPath *)indexPath{
    _indexPath = indexPath;
    _rank.text = [NSString stringWithFormat:@"%ld",(indexPath.row + 1)];
}

- (void)setModel:(DJTestScoreListModel *)model{
    _model = model;
//    _rank.text = model.rank;
    _name.text = model.name;
    /// TODO: 格式：1分20秒
    _time.text = model.timeused_string;//model.timeused;
    _rate.text = [NSString stringWithFormat:@"%@%%",model.score];
    
}

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}


@end
