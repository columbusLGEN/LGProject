//
//  OLExamModel.m
//  HBDJProj
//
//  Created by Peanut Lee on 2018/5/7.
//  Copyright © 2018年 Lee. All rights reserved.
//

#import "OLExamSingleModel.h"

#import "OLExamSingleLineModel.h"

@implementation OLExamSingleModel

+ (NSDictionary *)mj_objectClassInArray{
    return @{@"contents":@"OLExamSingleLineModel"};
}

/// testcode
- (NSArray<OLExamSingleLineModel *> *)contents{
    if (!_contents) {
        NSMutableArray *arrMu = [NSMutableArray new];
        for (NSInteger i = 0; i < 5; i++) {
            OLExamSingleLineModel *model = [OLExamSingleLineModel new];
            if (!i) {
                model.lineType = ExamSingleLineTypeContent;
            }else{
                model.lineType = ExamSingleLineTypeOption;
            }
            model.choiceMutiple = (arc4random_uniform(2) == 1);
            model.questionContent = [NSString stringWithFormat:@"%ld.领导干部的()，不仅关系自己的家庭，而且关系党风政风。",self.index + 1];
            model.optionContent = @"作风";
            [arrMu addObject:model];
        }
        _contents = arrMu.copy;
    }
    return _contents;
}

@end
