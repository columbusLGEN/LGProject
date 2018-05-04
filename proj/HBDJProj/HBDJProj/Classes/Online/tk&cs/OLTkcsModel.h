//
//  OLTkcsModel.h
//  HBDJProj
//
//  Created by Peanut Lee on 2018/5/4.
//  Copyright © 2018年 Lee. All rights reserved.
//

#import "LGBaseModel.h"

@interface OLTkcsModel : LGBaseModel
@property (copy,nonatomic) NSString *title;
/** 题目数量 */
@property (assign,nonatomic) NSInteger testCount;

@end
