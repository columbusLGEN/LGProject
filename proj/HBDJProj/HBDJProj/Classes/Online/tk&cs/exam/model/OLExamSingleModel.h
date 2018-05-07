//
//  OLExamModel.h
//  HBDJProj
//
//  Created by Peanut Lee on 2018/5/7.
//  Copyright © 2018年 Lee. All rights reserved.
//

/// 单页model，表示一道题

#import "LGBaseModel.h"

@class OLExamSingleLineModel;

@interface OLExamSingleModel : LGBaseModel
@property (strong,nonatomic) NSArray<OLExamSingleLineModel *> *contents;

/// textcode
@property (assign,nonatomic) NSInteger index;

/** 本套试题总数 */
@property (assign,nonatomic) NSInteger questioTotalCount;

@end
