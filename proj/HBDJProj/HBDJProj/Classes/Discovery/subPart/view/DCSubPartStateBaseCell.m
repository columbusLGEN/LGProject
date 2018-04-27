//
//  DCSubPartStateBaseCell.m
//  HBDJProj
//
//  Created by Peanut Lee on 2018/4/27.
//  Copyright © 2018年 Lee. All rights reserved.
//

#import "DCSubPartStateBaseCell.h"
#import "model/DCSubPartStateModel.h"

@implementation DCSubPartStateBaseCell

+ (NSString *)cellReuseIdWithModel:(DCSubPartStateModel *)model{
    
    return withoutImgCell;
}

- (void)awakeFromNib {
    [super awakeFromNib];
    
    UIView *rect = [UIView new];
    rect.backgroundColor = [UIColor EDJGrayscale_F3];
    [self.contentView addSubview:rect];
    [rect mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(self.mas_bottom);
        make.left.equalTo(self.mas_left);
        make.right.equalTo(self.mas_right);
        make.height.mas_equalTo(5);
    }];
}



@end
