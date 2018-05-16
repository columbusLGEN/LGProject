//
//  UCQuestionTableViewCell.m
//  HBDJProj
//
//  Created by Peanut Lee on 2018/4/23.
//  Copyright © 2018年 Lee. All rights reserved.
//

#import "UCQuestionTableViewCell.h"
#import "LGThreeRightButtonView.h"

@interface UCQuestionTableViewCell ()
@property (weak, nonatomic) IBOutlet UILabel *question;
@property (weak, nonatomic) IBOutlet UILabel *content;
@property (weak, nonatomic) IBOutlet UILabel *tagLabel0;
@property (weak, nonatomic) IBOutlet UILabel *tagLabel1;
@property (weak, nonatomic) IBOutlet UILabel *tagLabel2;
@property (strong, nonatomic) IBOutlet LGThreeRightButtonView *boInterView;

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
    [_boInterView setBtnConfigs:@[@{TRConfigTitleKey:@"99+",
                                    TRConfigImgNameKey:@"uc_icon_ganxie_gray",
                                    TRConfigSelectedImgNameKey:@"uc_icon_ganxie_red",
                                    TRConfigTitleColorNormalKey:[UIColor EDJGrayscale_C6],
                                    TRConfigTitleColorSelectedKey:[UIColor EDJColor_FC4E45]
                                    },
                                  @{TRConfigTitleKey:@"99+",
                                    TRConfigImgNameKey:@"uc_icon_shouc_gray",
                                    TRConfigSelectedImgNameKey:@"uc_icon_shouc_yellow",
                                    TRConfigTitleColorNormalKey:[UIColor EDJGrayscale_C6],
                                    TRConfigTitleColorSelectedKey:[UIColor EDJColor_FDBF2D]
                                    },
                                  @{TRConfigTitleKey:@"",
                                    TRConfigImgNameKey:@"uc_icon_fenxiang_gray",
                                    TRConfigSelectedImgNameKey:@"uc_icon_fenxiang_green",
                                    TRConfigTitleColorNormalKey:[UIColor EDJGrayscale_C6],
                                    TRConfigTitleColorSelectedKey:[UIColor EDJColor_8BCA32]
                                    }]];
}


@end
