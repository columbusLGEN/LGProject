//
//  OLExamViewBottomBar.m
//  HBDJProj
//
//  Created by Peanut Lee on 2018/5/7.
//  Copyright © 2018年 Lee. All rights reserved.
//

#import "OLExamViewBottomBar.h"

@interface OLExamViewBottomBar ()
@property (weak, nonatomic) IBOutlet UIButton *closeBackLook;
@property (weak, nonatomic) IBOutlet UILabel *alreadyAnswer;
@property (weak, nonatomic) IBOutlet UILabel *totalQuestions;


@end

@implementation OLExamViewBottomBar

- (void)setBackLook:(BOOL)backLook{
    if (backLook) {
        self.closeBackLook.hidden = NO;
    }
}

- (void)setAlreadyCount:(NSInteger)alreadyCount{
    _alreadyCount = alreadyCount;
    _alreadyAnswer.text = [NSString stringWithFormat:@"%ld",alreadyCount];
}
- (void)setTotalCount:(NSInteger)totalCount{
    _totalCount = totalCount;
    _totalQuestions.text = [NSString stringWithFormat:@"/%ld",totalCount];
}

- (IBAction)closeBackLook:(id)sender {
    
}

- (void)layoutSubviews{
    [super layoutSubviews];
    [_closeBackLook cutBorderWithBorderWidth:1 borderColor:[UIColor EDJMainColor] cornerRadius:_closeBackLook.height / 2];
}

- (void)awakeFromNib{
    [super awakeFromNib];
    
    /// 默认隐藏 退出回看
    self.closeBackLook.hidden = YES;
    [_closeBackLook setBackgroundColor:[UIColor whiteColor]];
    [_closeBackLook setTitle:@"退出回看" forState:UIControlStateNormal];
    [_closeBackLook setTitleColor:[UIColor EDJMainColor] forState:UIControlStateNormal];
    
    _alreadyAnswer.textColor = [UIColor EDJMainColor];
    _totalQuestions.textColor = [UIColor EDJGrayscale_33];
}

+ (instancetype)examViewBottomBar{
    return [[[NSBundle mainBundle] loadNibNamed:@"OLExamViewBottomBar" owner:nil options:nil] lastObject];
}

@end
