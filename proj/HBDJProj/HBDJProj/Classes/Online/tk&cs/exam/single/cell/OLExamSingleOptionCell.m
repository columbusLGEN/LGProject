//
//  OLExamSingleOptionCell.m
//  HBDJProj
//
//  Created by Peanut Lee on 2018/5/7.
//  Copyright © 2018年 Lee. All rights reserved.
//

#import "OLExamSingleOptionCell.h"
#import "OLExamSingleLineModel.h"
#import "OLExamSingleModel.h"
#import "OLTkcsModel.h"

@interface OLExamSingleOptionCell ()
@property (weak, nonatomic) IBOutlet UIImageView *icon;
@property (weak, nonatomic) IBOutlet UILabel *optionContent;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *optionContentLeading;

@end

@implementation OLExamSingleOptionCell

- (void)setModel:(OLExamSingleLineModel *)model{
    [super setModel:model];
    
    /// 如果处于试题回看状态
    if (self.backLook) {
        self.userInteractionEnabled = NO;/// 回看状态，不允许有选中交互
        
        if (model.belongTo.right) {
            /// 如果该题 用户答对了，
            if (model.isright) {
                [self optionStateWithRespondState:ExamSingleRespondStateCorrect];
            }else{
                [self optionStateWithRespondState:ExamSingleRespondStateDefault];
            }
        }else{
            if (model.type) {
                /// 用户选错了，标红
                [self optionStateWithRespondState:ExamSingleRespondStateWrong];
            }else{
                [self optionStateWithRespondState:ExamSingleRespondStateDefault];
            }
        }
        

        if (model.lineType == ExamSingleLineTypeAnswer) {/// 该行为 答案行
            
//            [self.icon removeFromSuperview];
            self.icon.hidden = YES;
            self.optionContentLeading.constant = 25;
            _optionContent.textColor = [UIColor EDJColor_30A5E1];
            self.backgroundColor = [UIColor whiteColor];
        }else{
            self.optionContentLeading.constant = 50;
            self.icon.hidden = NO;
        }
    }else{
        [self optionStateWithSelected:model.selected];
    }
    
    if (model.belongTo.testPaper == nil) {
    }else{
        if (model.belongTo.testPaper.tkcsType == 0) {
            self.userInteractionEnabled = NO;
            if (model.isright) {
                /// 题库 -- 正确选项 标蓝
                [self optionStateWithRespondState:ExamSingleRespondStateCorrect];
            }
        }
        
    }
    
//    [self optionStateWithSelected:model.selected];
    _optionContent.text = model.optionContent;
}

- (void)awakeFromNib {
    [super awakeFromNib];
    [self optionStateWithSelected:NO];
}

- (void)optionStateWithSelected:(BOOL)isSelected{
    if (isSelected) {
        /// 选中
        self.backgroundColor = [UIColor EDJGrayscale_FA];
        _icon.image = [UIImage imageNamed:@"ol_test_option_icon_correct"];
        _optionContent.textColor = [UIColor EDJColor_30A5E1];
    }else{
        /// 未选中
        self.backgroundColor = [UIColor whiteColor];
        _icon.image = [UIImage imageNamed:@"ol_test_option_icon_normal"];
        _optionContent.textColor = [UIColor EDJGrayscale_33];
    }
    
}

- (void)optionStateWithRespondState:(ExamSingleRespondState)respondState{
    switch (respondState) {
        case ExamSingleRespondStateDefault:{
            [self optionStateWithSelected:NO];
        }
            break;
        case ExamSingleRespondStateCorrect:{
            self.backgroundColor = [UIColor EDJGrayscale_FA];
            _icon.image = [UIImage imageNamed:@"ol_test_option_icon_correct"];
            _optionContent.textColor = [UIColor EDJColor_30A5E1];
        }
            break;
        case ExamSingleRespondStateWrong:{
            self.backgroundColor = [UIColor whiteColor];
            _icon.image = [UIImage imageNamed:@"ol_test_option_icon_user_wrong"];
            _optionContent.textColor = [UIColor EDJMainColor];
        }
            break;
        
    }
}

@end
