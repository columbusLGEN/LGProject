//
//  TCMyBookrackEditCell.m
//  TimeCollege
//
//  Created by Peanut Lee on 2019/5/10.
//  Copyright © 2019 lee. All rights reserved.
//

#import "TCMyBookrackEditCell.h"
#import "TCMyBookrackModel.h"

@interface TCMyBookrackEditCell ()
@property (strong,nonatomic) UIButton *seButton;

@end

@implementation TCMyBookrackEditCell

- (void)setModel:(TCMyBookrackModel *)model{
    [super setModel:model];
    _seButton.selected = model.editSelect;
    
}

- (instancetype)initWithFrame:(CGRect)frame{
    if (self = [super initWithFrame:frame]) {
        [self.contentView addSubview:self.seButton];
        [self.seButton mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.equalTo(self.cover.mas_right).offset(-marginFive);
            make.bottom.equalTo(self.cover.mas_bottom).offset(-marginFive);
            make.width.height.mas_equalTo(20);
        }];
    }
    return self;
}

- (UIButton *)seButton{
    if (!_seButton) {
        _seButton = UIButton.new;
        [_seButton setBackgroundImage:[UIImage imageNamed:@"icon_bookrack_edit_no"] forState:UIControlStateNormal];
        [_seButton setBackgroundImage:[UIImage imageNamed:@"icon_bookrack_edit_se"] forState:UIControlStateSelected];
    }
    return _seButton;
}

@end
