//
//  DCSubPartStateWithoutImgCell.m
//  HBDJProj
//
//  Created by Peanut Lee on 2018/4/27.
//  Copyright © 2018年 Lee. All rights reserved.
//

#import "DCSubPartStateWithoutImgCell.h"
#import "DCSubPartStateModel.h"

@interface DCSubPartStateWithoutImgCell ()
@property (strong,nonatomic) DCSubPartStateModel *subModel;
@property (weak, nonatomic) IBOutlet UILabel *contentLabel;

@end

@implementation DCSubPartStateWithoutImgCell

- (void)setModel:(DCSubPartStateModel *)model{
    _subModel = model;
    /// 设置数据
//    _contentLabel.text = @"";
}


- (void)awakeFromNib {
    [super awakeFromNib];

}


@end
