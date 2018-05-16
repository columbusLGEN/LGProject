//
//  EDJMicroBuildNoImgCell.m
//  HBDJProj
//
//  Created by Peanut Lee on 2018/4/11.
//  Copyright © 2018年 Lee. All rights reserved.
//

#import "EDJMicroBuildNoImgCell.h"
#import "EDJMicroBuildModel.h"

@interface EDJMicroBuildNoImgCell ()
@property (weak, nonatomic) IBOutlet UILabel *title;
@property (strong,nonatomic) EDJMicroBuildModel *subModel;
@property (weak, nonatomic) IBOutlet UILabel *sub_title;

@end

@implementation EDJMicroBuildNoImgCell

- (void)setModel:(EDJMicroBuildModel *)model{
    _subModel = model;
    
}

- (void)awakeFromNib {
    [super awakeFromNib];
    
    
}


@end
