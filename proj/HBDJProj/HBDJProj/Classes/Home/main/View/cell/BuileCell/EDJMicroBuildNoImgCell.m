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
@property (weak, nonatomic) IBOutlet UILabel *sub_title;

@end

@implementation EDJMicroBuildNoImgCell

@synthesize model = _model;
- (void)setModel:(EDJMicroBuildModel *)model{
    _model = model;
    _title.text = model.title;
    _sub_title.text = model.source;
}

- (void)awakeFromNib {
    [super awakeFromNib];
    
    
}


@end
