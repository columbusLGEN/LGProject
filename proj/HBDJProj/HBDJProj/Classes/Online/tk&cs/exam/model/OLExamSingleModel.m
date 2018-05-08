//
//  OLExamModel.m
//  HBDJProj
//
//  Created by Peanut Lee on 2018/5/7.
//  Copyright © 2018年 Lee. All rights reserved.
//

#import "OLExamSingleModel.h"

@interface OLExamSingleModel ()
@property (weak,nonatomic) OLExamSingleLineModel *standAnswer;

@end

@implementation OLExamSingleModel

+ (NSDictionary *)mj_objectClassInArray{
    return @{@"contents":@"OLExamSingleLineModel"};
}

/// testcode
- (NSArray<OLExamSingleLineModel *> *)contents{
    if (!_contents) {
        self.answer = arc4random_uniform(4);
        NSMutableArray *arrMu = [NSMutableArray new];
        
        for (NSInteger i = 0; i < 5; i++) {
            OLExamSingleLineModel *model = [OLExamSingleLineModel new];
            model.belongTo = self;
            
            if (i > 0) {
                model.repreAnswer = i - 1;///i==0为题干, 选项从 i==1时开始
            }
            
            if (i == 0) {
                model.lineType = ExamSingleLineTypeContent;
            }else{
                model.lineType = ExamSingleLineTypeOption;
            }
            model.choiceMutiple = (arc4random_uniform(2) == 1);
            model.questionContent = [NSString stringWithFormat:@"%ld.领导干部的()，不仅关系自己的家庭，而且关系党风政风。",self.index + 1];
            model.optionContent = [NSString stringWithFormat:@"%@ 作风",abcdStringWithAnswer(model.repreAnswer)];
            [arrMu addObject:model];
        }
            OLExamSingleLineModel *standAnswer = [OLExamSingleLineModel new];
            standAnswer.belongTo = self;
            standAnswer.lineType = ExamSingleLineTypeAnswer;
            standAnswer.optionContent = [self answerStringWithState:ExamSingleRespondStateDefault];
            [arrMu addObject:standAnswer];
            _standAnswer = standAnswer;
        
        _contents = arrMu.copy;
        if (self.backLook) {
            /// 如果是回看，随机取一个模型选中
            NSInteger number = arc4random_uniform(4) + 1;
            OLExamSingleLineModel *random = _contents[number];
            random.selected = YES;
            if (random.repreAnswer == self.answer) {
                _standAnswer.optionContent = [self answerStringWithState:ExamSingleRespondStateCorrect];
            }else{
                
                _standAnswer.optionContent = [self answerStringWithState:ExamSingleRespondStateWrong];
            }
        }
    }
    
    return _contents;
}

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

@end
