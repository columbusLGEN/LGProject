//
//  DJDisSearchHigCell.m
//  HBDJProj
//
//  Created by Peanut Lee on 2018/8/22.
//  Copyright © 2018年 Lee. All rights reserved.
//

#import "DJDisSearchHisCell.h"
#import "EDJSearchTagModel.h"

@interface DJDisSearchHisCell ()
@property (weak,nonatomic) UIButton *label;

@end

@implementation DJDisSearchHisCell{
    CGFloat buttonHeight;
}

- (void)setModel:(EDJSearchTagModel *)model{
    _model = model;
    [_label setTitle:model.name forState:UIControlStateNormal];
    
    if (model.isHis) {
        [_label setBackgroundColor:UIColor.whiteColor];
        [_label setTitleColor:UIColor.EDJMainColor forState:UIControlStateNormal];
        [_label cutBorderWithBorderWidth:1 borderColor:UIColor.EDJMainColor cornerRadius:buttonHeight * 0.5];
        
    }else{
        [_label setBackgroundColor:UIColor.EDJMainColor];
        [_label setTitleColor:UIColor.whiteColor forState:UIControlStateNormal];
        [_label cutBorderWithBorderWidth:0 borderColor:nil cornerRadius:buttonHeight * 0.5];
    }
}

- (instancetype)initWithFrame:(CGRect)frame{
    if (self = [super initWithFrame:frame]) {
        UIButton *label = UIButton.new;
        _label = label;
        _label.userInteractionEnabled = NO;
        [self.contentView addSubview:_label];
        buttonHeight = 34;
        [_label mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.equalTo(self.contentView.mas_centerY);
            make.left.equalTo(self.contentView).offset(marginEight);
            make.right.equalTo(self.contentView).offset(-marginEight);
            make.height.mas_equalTo(buttonHeight);
        }];
//        self.contentView.backgroundColor = UIColor.randomColor;
    }
    return self;
}

@end
