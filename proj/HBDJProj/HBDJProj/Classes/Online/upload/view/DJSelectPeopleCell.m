//
//  DJSelectPeopleCell.m
//  HBDJProj
//
//  Created by Peanut Lee on 2018/7/5.
//  Copyright © 2018年 Lee. All rights reserved.
//

#import "DJSelectPeopleCell.h"
#import "DJSelectPeopleModel.h"

static NSString * const selectKeyPath = @"select";

@interface DJSelectPeopleCell ()
@property (weak,nonatomic) UILabel *peopleName;
@property (weak,nonatomic) UIButton *selectButton;

@end

@implementation DJSelectPeopleCell

- (void)setModel:(DJSelectPeopleModel *)model{
    _model = model;
    _peopleName.text = model.name;
    _selectButton.selected = model.select;
    
    [model addObserver:self forKeyPath:selectKeyPath options:NSKeyValueObservingOptionNew context:nil];
}

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary<NSKeyValueChangeKey,id> *)change context:(void *)context{
    if ([keyPath isEqualToString:selectKeyPath] && object == self.model) {
        self.selectButton.selected = self.model.select;
    }
}


- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        
        UIView *line = UIView.new;
        line.backgroundColor = [UIColor EDJGrayscale_F3];
        [self.contentView addSubview:line];
        [line mas_makeConstraints:^(MASConstraintMaker *make) {
            make.bottom.equalTo(self.contentView.mas_bottom);
            make.height.mas_equalTo(1);
            make.left.equalTo(self.contentView.mas_left);
            make.right.equalTo(self.contentView.mas_right);
        }];
        
        UILabel *label = UILabel.new;
        _peopleName = label;
        [self.contentView addSubview:_peopleName];
        _peopleName.font = [UIFont systemFontOfSize:15];
        _peopleName.textColor = [UIColor EDJGrayscale_11];
        [_peopleName mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.equalTo(self.contentView.mas_centerY);
            make.left.equalTo(self.contentView.mas_left).offset(marginTen);
        }];
        
        UIButton *button = UIButton.new;
        _selectButton = button;
        [self.contentView addSubview:_selectButton];
        _selectButton.userInteractionEnabled = NO;
        [_selectButton setImage:[UIImage imageNamed:@"ol_test_option_icon_normal"] forState:UIControlStateNormal];
        [_selectButton setImage:[UIImage imageNamed:@"ol_test_option_icon_correct"] forState:UIControlStateSelected];
        [_selectButton mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.equalTo(self.contentView.mas_centerY);
            make.right.equalTo(self.contentView.mas_right).offset(-marginFifteen);
        }];
    }
    return self;
}

- (void)dealloc{
    [self.model removeObserver:self forKeyPath:selectKeyPath];
}

@end
