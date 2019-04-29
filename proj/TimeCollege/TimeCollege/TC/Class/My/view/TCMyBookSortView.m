//
//  TCMyBookSortView.m
//  TimeCollege
//
//  Created by Peanut Lee on 2019/4/17.
//  Copyright © 2019 lee. All rights reserved.
//

#import "TCMyBookSortView.h"

@interface TCMyBookSortView ()
@property (strong,nonatomic) UIImageView *rightIcon;

@end

@implementation TCMyBookSortView

- (void)setSortWay:(NSInteger)sortWay{
    if (sortWay == 1) {
        [_switchButton setTitle:@"最近加入" forState:UIControlStateNormal];
    }
    if (sortWay == 2) {
        [_switchButton setTitle:@"最近阅读" forState:UIControlStateNormal];
    }
}

- (instancetype)initWithFrame:(CGRect)frame{
    if (self = [super initWithFrame:frame]) {
        [self addSubview:self.switchButton];
        [self addSubview:self.rightIcon];
        
        [self.switchButton mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.equalTo(self);
            make.left.equalTo(self.mas_left).offset(15);
            
        }];
        
        [self.rightIcon mas_makeConstraints:^(MASConstraintMaker *make) {
            
        }];
    }
    return self;
}

- (UIButton *)switchButton{
    if (!_switchButton) {
        _switchButton = UIButton.new;
        [_switchButton setTitle:@"最近加入" forState:UIControlStateNormal];
        _switchButton.titleLabel.font = [UIFont systemFontOfSize:15];
        [_switchButton setTitleColor:UIColor.YBColor_6A6A6A forState:UIControlStateNormal];
        
    }
    return _switchButton;
}
- (UIImageView *)rightIcon{
    if (!_rightIcon) {
        _rightIcon = [UIImageView.alloc initWithImage:[UIImage imageNamed:@""]];
    }
    return _rightIcon;
}

@end
