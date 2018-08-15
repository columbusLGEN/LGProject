//
//  UCQuestionTableViewCell.m
//  HBDJProj
//
//  Created by Peanut Lee on 2018/4/23.
//  Copyright © 2018年 Lee. All rights reserved.
//

#import "UCQuestionTableViewCell.h"
#import "LGThreeRightButtonView.h"
#import "UCQuestionModel.h"

static NSString * const showAll_key = @"showAll";

@interface UCQuestionTableViewCell ()
@property (weak, nonatomic) IBOutlet UILabel *question;
@property (weak, nonatomic) IBOutlet UILabel *content;
@property (weak, nonatomic) IBOutlet UILabel *tagLabel0;
@property (weak, nonatomic) IBOutlet UILabel *tagLabel1;
@property (weak, nonatomic) IBOutlet UILabel *tagLabel2;
@property (strong, nonatomic) IBOutlet LGThreeRightButtonView *boInterView;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *questionTextHeight;
@property (weak, nonatomic) IBOutlet UIImageView *arrow;
@property (weak, nonatomic) IBOutlet UIButton *showAll;

@end

@implementation UCQuestionTableViewCell

- (void)setModel:(UCQuestionModel *)model{
    _model = model;
    
    CGFloat questionHeight = [model.question sizeOfTextWithMaxSize:CGSizeMake(kScreenWidth - 57, MAXFLOAT) font:[UIFont systemFontOfSize:16]].height;
    NSInteger lines = questionHeight / 19;
//    NSLog(@"questionHeight: %f",questionHeight);
//    NSLog(@"lines: %ld",lines);
    
    _questionTextHeight.constant = lines * 20;
    _question.numberOfLines = lines;
    _question.text = model.question;
    
    _content.text = model.answer;

    _showAll.selected = model.showAll;
    if (model.showAll) {
        _content.numberOfLines = 0;
        _arrow.transform = CGAffineTransformMakeRotation(-M_PI);
    }else{
        _content.numberOfLines = 3;
        _arrow.transform = CGAffineTransformIdentity;
    }
}

- (IBAction)showAllClick:(UIButton *)sender {
    self.model.showAll = !self.model.showAll;
    if ([self.delegate respondsToSelector:@selector(qaCellshowAllClickWith:)]) {
        [self.delegate qaCellshowAllClickWith:self.indexPath];
    }
}

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

- (void)awakeFromNib {
    [super awakeFromNib];
    
    NSLog(@"[_content.font fontName]: %@",[_content.font fontName]);
    NSLog(@"[_content.font familyName]: %@",[_content.font familyName]);
    
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
