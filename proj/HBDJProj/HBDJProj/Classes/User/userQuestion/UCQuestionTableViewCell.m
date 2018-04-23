//
//  UCQuestionTableViewCell.m
//  HBDJProj
//
//  Created by Peanut Lee on 2018/4/23.
//  Copyright © 2018年 Lee. All rights reserved.
//

#import "UCQuestionTableViewCell.h"

@interface UCQuestionTableViewCell ()
@property (weak, nonatomic) IBOutlet UILabel *question;
@property (weak, nonatomic) IBOutlet UILabel *content;
@property (weak, nonatomic) IBOutlet UILabel *tagLabel0;
@property (weak, nonatomic) IBOutlet UILabel *tagLabel1;
@property (weak, nonatomic) IBOutlet UILabel *tagLabel2;



@end

@implementation UCQuestionTableViewCell


- (IBAction)share:(UIButton *)sender {
    if (sender.isSelected) {
        sender.selected = NO;
    }else{
        sender.selected = YES;
    }
}
- (IBAction)collect:(UIButton *)sender {
    if (sender.isSelected) {
        sender.selected = NO;
    }else{
        sender.selected = YES;
    }
}
- (IBAction)thanks:(UIButton *)sender {
    if (sender.isSelected) {
        sender.selected = NO;
    }else{
        sender.selected = YES;
    }
}


- (void)setModel:(UCQuestionModel *)model{
    _model = model;
    
}


- (void)awakeFromNib {
    [super awakeFromNib];
    _question.textColor = [UIColor EDJColor_A2562C];
    _tagLabel0.textColor = [UIColor EDJMainColor];
    _tagLabel1.textColor = [UIColor EDJMainColor];
    _tagLabel2.textColor = [UIColor EDJMainColor];
    _content.textColor = [UIColor EDJGrayscale_33];
}


@end
