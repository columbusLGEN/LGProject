//
//  DJSelectPeopleCell.m
//  HBDJProj
//
//  Created by Peanut Lee on 2018/7/5.
//  Copyright © 2018年 Lee. All rights reserved.
//

#import "DJSelectPeopleCell.h"
#import "DJSelectPeopleModel.h"

static NSString * const selectPresntKeyPath = @"select_present";
static NSString * const selectAbsentKeyPath = @"select_absent";
static NSString * const selectHostKeyPath = @"select_host";

@interface DJSelectPeopleCell ()
@property (weak,nonatomic) UILabel *peopleName;
@property (weak,nonatomic) UIButton *selectButton;

@end

@implementation DJSelectPeopleCell

- (void)setModel:(DJSelectPeopleModel *)model{
    _model = model;
    _peopleName.text = model.name;
    if (self.repSpType == 0) {
        /// 出席
        _selectButton.selected = model.select_present;
        [model addObserver:self forKeyPath:selectPresntKeyPath options:NSKeyValueObservingOptionNew context:nil];
    }else if(self.repSpType == 1){
        /// 缺席
        _selectButton.selected = model.select_absent;
        [model addObserver:self forKeyPath:selectAbsentKeyPath options:NSKeyValueObservingOptionNew context:nil];
    }else{
        /// 主持人
        _selectButton.selected = model.select_host;
        [model addObserver:self forKeyPath:selectHostKeyPath options:NSKeyValueObservingOptionNew context:nil];
    }

}

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary<NSKeyValueChangeKey,id> *)change context:(void *)context{
    
    if (self.repSpType == 0) {
        if ([keyPath isEqualToString:selectPresntKeyPath] && object == self.model) {
            self.selectButton.selected = self.model.select_present;
        }
    }else if(self.repSpType == 1){
        if ([keyPath isEqualToString:selectAbsentKeyPath] && object == self.model) {
            self.selectButton.selected = self.model.select_absent;
        }
    }else{
        //        主持人
        if ([keyPath isEqualToString:selectHostKeyPath] && object == self.model) {
            self.selectButton.selected = self.model.select_host;
        }
    }

}


- (void)dealloc{
    if (self.repSpType == 0) {
        [self.model removeObserver:self forKeyPath:selectPresntKeyPath];
    }else if(self.repSpType == 1){
        [self.model removeObserver:self forKeyPath:selectAbsentKeyPath];
    }else{
        //        主持人
        [self.model removeObserver:self forKeyPath:selectHostKeyPath];
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


@end
