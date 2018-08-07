//
//  OLExamSingleModel.m
//  HBDJProj
//
//  Created by Peanut Lee on 2018/5/7.
//  Copyright © 2018年 Lee. All rights reserved.
//

#import "OLExamSingleModel.h"
#import "OLExamSingleLineModel.h"

@interface OLExamSingleModel ()
@property (weak,nonatomic) OLExamSingleLineModel *standAnswer;

@end

@implementation OLExamSingleModel

- (NSString *)subjectid{
    if (!_subjectid) {
        _subjectid = [NSString stringWithFormat:@"%ld",self.seqid];
    }
    return _subjectid;
}

- (void)addSubjectModel{
    /// 添加题干
    OLExamSingleLineModel *subject = OLExamSingleLineModel.new;
    subject.lineType = ExamSingleLineTypeContent;
    subject.questionContent = self.subject;
    subject.choiceMutiple = (self.subjecttype == 2);
    [self.frontSubjectsDetail insertObject:subject atIndex:0];
}

/**
 * 多选题对错原则：只要没有全部选对，就算错。例如正确答案 ACB，用户选择AB 或者 BC，都算错
 * 判断逻辑
 * 0.所有isright的选项  optionValue = 1, 错误的选项optionValue = 0
 * 1.为题目创建一个属性 rightValue 记录正确值,selectValue记录用户选择值
 * 2.选项中有几个idright，rightValue 就等于几
 * 3.判断用户所选
 * 如果所有的isright都是YES，再把所有选项的 optionValue 相加赋值给 selectValue，再判断selectValue 和 rightValue 是否相等,如果相等，该题才算对
 */
- (BOOL)isright{
    if (_subjecttype == 1) {
        /// 单选题目
        
        return _selectOption.isright;
    }else{
        /// 多选题目
        
        return (self.selectValue == self.rightOptionCount);
    }
}
- (NSInteger)selectValue{
    NSInteger value = 0;
    if (_selectOptions.count) {
        for (OLExamSingleLineModel *option in _selectOptions) {
            if (!option.isright) {
                /// 如果用户所选选项中有错误的选项，跳出循环
                value = 0;
                break;
            }
            value += option.optionValue;
        }
    }
    return value;
}
- (NSInteger)rightOptionCount{
    if (!_rightOptionCount) {
        NSInteger value = 0;
        for (OLExamSingleLineModel *option in _frontSubjectsDetail) {
            if (option.isright) {
                value++;
            }
        }
        _rightOptionCount = value;
    }
    
    return _rightOptionCount;
}

- (NSString *)answer_display{
    if (!_answer_display) {
        NSString *string = @"";
        for (NSInteger i = 0; i < _frontSubjectsDetail.count; i++) {
            OLExamSingleLineModel *option = _frontSubjectsDetail[i];
            option.answerString = [NSString stringWithFormat:@"%@ ",
                                   [self abcdStringWithIndex:i]];
            
            if (option.isright) {
                string = [string stringByAppendingString:[NSString stringWithFormat:@"、%@",
                                                          [self abcdStringWithIndex:i]]];
            }
        }
        
        if ([string hasPrefix:@"、"]) {/// 去掉最前面的 、
            string = [string substringFromIndex:1];
        }
        _answer_display = string;
        
    }
    return _answer_display;
}

- (NSString *)abcdStringWithIndex:(NSInteger)index{
    /// 因为 题干模型插入了 frontSubjectsDetail 的第一个位置 , 所以 index 需要 -1
    index--;
    NSString *letter = @"";
    char char_A = 'A';
    for (NSInteger i = 0; i < 26; i++) {
        char char_letter = char_A + i;
        if (index == i) {
            letter = [NSString stringWithFormat:@"%c",char_letter];
        }
    }
    return letter;
}

+ (NSDictionary *)mj_objectClassInArray{
    return @{@"frontSubjectsDetail":@"OLExamSingleLineModel"};
}

/// 一下的代码有可能会删除

- (void)setFrontSubjectsDetail:(NSMutableArray<OLExamSingleLineModel *> *)frontSubjectsDetail{
    for (OLExamSingleLineModel *option in frontSubjectsDetail) {
        option.lineType = ExamSingleLineTypeOption;
    }
    _frontSubjectsDetail = frontSubjectsDetail;
}

- (void)setRespondState:(ExamSingleRespondState)respondState{
    _respondState = respondState;
    /// 回答正确，回答错误，时，分别修改 standAnswer 的 optionContent
    _standAnswer.optionContent = [self answerStringWithState:respondState];
    NSLog(@"_standAnswer -- %@ optionContent -- %@",_standAnswer,_standAnswer.optionContent);
}

- (NSString *)answerStringWithState:(ExamSingleRespondState)state{
    NSString *string;
    switch (state) {
        case ExamSingleRespondStateDefault:{
            string = @"参考答案";
        }
            break;
        case ExamSingleRespondStateCorrect:{
            string = @"回答正确，参考答案";
            NSLog(@"string -- %@",string);
        }
            break;
        case ExamSingleRespondStateWrong:{
            string = @"回答错误，参考答案";
        }
            break;
    }
    return [NSString stringWithFormat:@"%@: %@",string,self.answer_display];
}

- (NSMutableArray<OLExamSingleLineModel *> *)selectOptions{
    if (!_selectOptions) {
        _selectOptions = NSMutableArray.new;
    }
    return _selectOptions;
}

@end
