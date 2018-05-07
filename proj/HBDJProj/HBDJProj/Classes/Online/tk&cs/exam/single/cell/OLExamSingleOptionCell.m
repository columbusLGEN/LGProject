//
//  OLExamSingleOptionCell.m
//  HBDJProj
//
//  Created by Peanut Lee on 2018/5/7.
//  Copyright © 2018年 Lee. All rights reserved.
//

#import "OLExamSingleOptionCell.h"
#import "OLExamSingleLineModel.h"

@interface OLExamSingleOptionCell ()
@property (strong,nonatomic) OLExamSingleLineModel *subModel;
@property (weak, nonatomic) IBOutlet UIImageView *icon;
@property (weak, nonatomic) IBOutlet UILabel *optionContent;

@end

@implementation OLExamSingleOptionCell

- (void)setModel:(OLExamSingleLineModel *)model{
    _subModel = model;
    [self optionStateWithSelected:model.isSelected];
    _optionContent.text = model.optionContent;
}

- (void)awakeFromNib {
    [super awakeFromNib];
//    self.contentView.backgroundColor = [UIColor randomColor];
    [self optionStateWithSelected:NO];
}

- (void)optionStateWithSelected:(BOOL)isSelected{
    if (isSelected) {
        self.backgroundColor = [UIColor EDJGrayscale_FA];
        _icon.image = [UIImage imageNamed:@"home_segment_icon2"];
        _optionContent.textColor = [UIColor EDJColor_30A5E1];
    }else{
        self.backgroundColor = [UIColor whiteColor];
        _icon.image = [UIImage imageNamed:@"home_segment_icon0"];
        _optionContent.textColor = [UIColor EDJGrayscale_33];
    }
}

@end
