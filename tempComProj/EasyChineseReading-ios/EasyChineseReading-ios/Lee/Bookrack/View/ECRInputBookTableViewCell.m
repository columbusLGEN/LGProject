//
//  ECRInputBookTableViewCell.m
//  EasyChineseReading-ios
//
//  Created by Peanut Lee on 2017/11/22.
//  Copyright © 2017年 retech. All rights reserved.
//

#import "ECRInputBookTableViewCell.h"
#import "ECRBRLoadLocalBookModel.h"

@interface ECRInputBookTableViewCell ()
@property (weak, nonatomic) IBOutlet UILabel *step;
@property (weak, nonatomic) IBOutlet UILabel *info;
@property (weak, nonatomic) IBOutlet UIImageView *img;



@end

@implementation ECRInputBookTableViewCell

- (void)setModel:(ECRBRLoadLocalBookModel *)model{
    _model = model;
    // 赋值
    _step.text = model.cellTitle;
    _info.text = model.cellInfo;
    _img.image = [UIImage imageNamed:model.cellImageName];
    
}

- (void)awakeFromNib {
    [super awakeFromNib];
    self.selectionStyle = UITableViewCellSelectionStyleNone;
}

+ (NSString *)cellID{
    return @"ECRInputBookTableViewCell";
}

@end
