//
//  UCQuestionModel.h
//  HBDJProj
//
//  Created by Peanut Lee on 2018/4/23.
//  Copyright © 2018年 Lee. All rights reserved.
//

/// 学习问答模型

#import "DJUcMyCollectQAModel.h"

@interface UCQuestionModel : DJUcMyCollectQAModel

/** 问题 */
@property (strong,nonatomic) NSString *question;
/** 答案 */
@property (strong,nonatomic) NSString *answer;

@property (strong,nonatomic) NSArray *tags;
@property (strong,nonatomic) NSString *tagString;
@property (assign,nonatomic) BOOL showAll;

@end
