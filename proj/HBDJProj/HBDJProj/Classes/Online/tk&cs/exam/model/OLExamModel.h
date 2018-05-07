//
//  OLExamModel.h
//  HBDJProj
//
//  Created by Peanut Lee on 2018/5/7.
//  Copyright © 2018年 Lee. All rights reserved.
//
/// 试卷模型，表示一套试题

#import "LGBaseModel.h"
@class OLExamSingleModel;

@interface OLExamModel : LGBaseModel
@property (strong,nonatomic) NSArray<OLExamSingleModel *> *questions;

@end
