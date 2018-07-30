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
        return (self.selectValue == self.rightValue);
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
- (NSInteger)rightValue{
    if (!_rightValue) {
        NSInteger value = 0;
        for (OLExamSingleLineModel *option in _frontSubjectsDetail) {
            if (option.isright) {
                value++;
            }
        }
        _rightValue = value;
    }
    return _rightValue;
}


+ (NSDictionary *)mj_objectClassInArray{
    return @{@"frontSubjectsDetail":@"OLExamSingleLineModel"};
}

- (void)setFrontSubjectsDetail:(NSMutableArray<OLExamSingleLineModel *> *)frontSubjectsDetail{
    for (OLExamSingleLineModel *option in frontSubjectsDetail) {
        option.lineType = ExamSingleLineTypeOption;
    }
    _frontSubjectsDetail = frontSubjectsDetail;
}

///// testcode
//- (NSArray<OLExamSingleLineModel *> *)contents{
//    if (!_contents) {
//        self.answer = arc4random_uniform(4);
//        NSMutableArray *arrMu = [NSMutableArray new];
//
//        for (NSInteger i = 0; i < 5; i++) {
//            OLExamSingleLineModel *model = [OLExamSingleLineModel new];
//            model.belongTo = self;
//
//            if (i > 0) {
//                model.repreAnswer = i - 1;///i==0为题干, 选项从 i==1时开始
//            }
//
//            if (i == 0) {
//                model.lineType = ExamSingleLineTypeContent;
//            }else{
//                model.lineType = ExamSingleLineTypeOption;
//            }
//            model.choiceMutiple = (arc4random_uniform(2) == 1);
//            model.questionContent = [NSString stringWithFormat:@"%ld.领导干部的()，不仅关系自己的家庭，而且关系党风政风。",self.index + 1];
//            model.optionContent = [NSString stringWithFormat:@"%@ 作风",abcdStringWithAnswer(model.repreAnswer)];
//            [arrMu addObject:model];
//        }
//            OLExamSingleLineModel *standAnswer = [OLExamSingleLineModel new];
//            standAnswer.belongTo = self;
//            standAnswer.lineType = ExamSingleLineTypeAnswer;
//            standAnswer.optionContent = [self answerStringWithState:ExamSingleRespondStateDefault];
//            [arrMu addObject:standAnswer];
//            _standAnswer = standAnswer;
//
//        _contents = arrMu.copy;
//        if (self.backLook) {
//            /// 如果是回看，随机取一个模型选中
//            NSInteger number = arc4random_uniform(4) + 1;
//            OLExamSingleLineModel *random = _contents[number];
//            random.selected = YES;
//            if (random.repreAnswer == self.answer) {
//                _standAnswer.optionContent = [self answerStringWithState:ExamSingleRespondStateCorrect];
//            }else{
//
//                _standAnswer.optionContent = [self answerStringWithState:ExamSingleRespondStateWrong];
//            }
//        }
//    }
//
//    return _contents;
//}

- (void)setRespondState:(ExamSingleRespondState)respondState{
    _respondState = respondState;
    /// 回答正确，回答错误，时，分别修改 standAnswer 的 optionContent
    _standAnswer.optionContent = [self answerStringWithState:respondState];
    NSLog(@"_standAnswer -- %@ optionContent -- %@",_standAnswer,_standAnswer.optionContent);
}

NSString *abcdStringWithAnswer(ExamSingleAnswer answer){
    switch (answer) {
        case ExamSingleAnswerA:{
            return @"A";
        }
            break;
        case ExamSingleAnswerB:{
            return @"B";
        }
            break;
        case ExamSingleAnswerC:{
            return @"C";
        }
            break;
        case ExamSingleAnswerD:{
            return @"D";
        }
            break;
    }
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
    return [NSString stringWithFormat:@"%@: %@",string,abcdStringWithAnswer(self.answer)];
}

- (NSMutableArray<OLExamSingleLineModel *> *)selectOptions{
    if (!_selectOptions) {
        _selectOptions = NSMutableArray.new;
    }
    return _selectOptions;
}

@end
