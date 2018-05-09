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

@interface OLExamSingleOptionCell ()
@property (strong,nonatomic) OLExamSingleLineModel *subModel;
@property (weak, nonatomic) IBOutlet UIImageView *icon;
@property (weak, nonatomic) IBOutlet UILabel *optionContent;

@end

@implementation OLExamSingleOptionCell

- (void)setModel:(OLExamSingleLineModel *)model{
    _subModel = model;
    
    /// 如果处于试题回看状态

    if (model.belongTo.backLook) {
        self.userInteractionEnabled = NO;/// 回看状态，不允许有选中交互
        
        /// 如果是正确答案，标蓝
        if (model.repreAnswer == model.belongTo.answer) {
            [self optionStateWithRespondState:ExamSingleRespondStateCorrect];
        }else{
            /// 如果不是正确答案，需要根据用户是否选中 进行标识
            if (model.selected) {
                /// 如果用户选中，标红，
                [self optionStateWithRespondState:ExamSingleRespondStateWrong];
            }else{
                /// 如果用户未选中，默认显示
                [self optionStateWithRespondState:ExamSingleRespondStateDefault];
            }
        }
        
        
        if (model.lineType == ExamSingleLineTypeAnswer) {/// 该行为 答案行
//            self.icon.hidden = YES;
            /// 由于，做多只显示 题干 + 4个选项 + 答案行 最多6个cell，所以暂时可以使用这种方法。但这不是好方法，因为如果之后这个cell被重用的话，icon同样是被删除的状态
            /// 但是如果只是隐藏 icon 的话，optionContent 的 lower 约束无法起作用
            [self.icon removeFromSuperview];
            _optionContent.textColor = [UIColor EDJColor_30A5E1];
            self.backgroundColor = [UIColor whiteColor];
        }
    }else{
        [self optionStateWithSelected:model.selected];
    }
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
