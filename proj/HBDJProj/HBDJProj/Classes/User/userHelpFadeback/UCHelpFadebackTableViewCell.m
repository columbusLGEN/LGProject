//
//  UCHelpFadebackTableViewCell.m
//  HBDJProj
//
//  Created by Peanut Lee on 2018/4/20.
//  Copyright © 2018年 Lee. All rights reserved.
//

#import "UCHelpFadebackTableViewCell.h"
#import "UCHelpFadebackModel.h"

static CGFloat marginLeft = 19;
static CGFloat marginTop = 21;

@interface UCHelpFadebackTableViewCell ()
@property (weak,nonatomic) UILabel *question;
@property (weak,nonatomic) UILabel *answer;
@property (weak,nonatomic) UILabel *time;
@property (weak,nonatomic) UIView *line;

@end

@implementation UCHelpFadebackTableViewCell

- (void)setModel:(UCHelpFadebackModel *)model{
    _model = model;
    [_answer sizeToFit];
    if (model.showTimeLabel) {
        /// 显示 时间lable
        _time.text = @"2018-4-21";
        [_time sizeToFit];
        /// 修改 question 的 frame
        _question.frame = CGRectMake(marginLeft, marginTop, kScreenWidth - marginLeft - _time.width - 20, 17);
    }
}

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {

        UILabel *question = [[UILabel alloc] initWithFrame:CGRectMake(marginLeft, marginTop, kScreenWidth - 2 * marginLeft, 17)];
        question.numberOfLines = 1;
        question.textColor = [UIColor EDJColor_9B1212];
        question.font = [UIFont systemFontOfSize:17];
        question.text = @"问: 讲习不能刷新加载怎么办";
        [self.contentView addSubview:question];
        
        UILabel *time = [UILabel new];
        time.textColor = [UIColor EDJGrayscale_33];
        time.font = [UIFont systemFontOfSize:15];
        [self.contentView addSubview:time];
        [time mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.equalTo(self.contentView.mas_right).offset(-marginLeft);
            make.top.equalTo(self.contentView.mas_top).offset(marginTop);
        }];
        
        UILabel *answer = [[UILabel alloc] initWithFrame:CGRectMake(marginLeft, CGRectGetMaxY(question.frame)+marginLeft, kScreenWidth - 2 * marginLeft, 0)];
        answer.numberOfLines = 0;
        answer.textColor = [UIColor EDJGrayscale_33];
        answer.font = [UIFont systemFontOfSize:14];
        answer.text = @"答: 您好,请先清理缓存balalab请先清理缓存balalab请先清理缓存balalab";
        [self.contentView addSubview:answer];
        
        UIView *line = [[UIView alloc] initWithFrame:CGRectZero];
        line.backgroundColor = [UIColor EDJGrayscale_F3];
        [self.contentView addSubview:line];
        [line mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.contentView.mas_left);
            make.right.equalTo(self.contentView.mas_right);
            make.bottom.equalTo(self.contentView.mas_bottom);
            make.height.mas_equalTo(1);
        }];
        
        _question = question;
        _time     = time;
        _answer   = answer;
        _line     = line;
        
    }
    return self;
}

@end
