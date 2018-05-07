//
//  OLExamSingleStemCell.m
//  HBDJProj
//
//  Created by Peanut Lee on 2018/5/7.
//  Copyright © 2018年 Lee. All rights reserved.
//

#import "OLExamSingleStemCell.h"
#import "OLExamSingleLineModel.h"

@interface OLExamSingleStemCell ()
@property (strong,nonatomic) OLExamSingleLineModel *subModel;
@property (weak, nonatomic) IBOutlet UIImageView *icon;
@property (weak, nonatomic) IBOutlet UILabel *content;

@end

@implementation OLExamSingleStemCell

- (void)setModel:(OLExamSingleLineModel *)model{
    _subModel = model;
    [self optionStateWithMutiple:model.isChoiceMutiple];
    _content.text = model.questionContent;
}

- (void)awakeFromNib {
    [super awakeFromNib];
    self.userInteractionEnabled = NO;
    
}

- (void)optionStateWithMutiple:(BOOL)isMutiple{
    if (isMutiple) {
        _icon.image = [UIImage imageNamed:@"ol_exam_qctp_chioce_mutilple"];
    }else{
        _icon.image = [UIImage imageNamed:@"ol_exam_qctp_chioce_single"];
        
    }
}


@end
