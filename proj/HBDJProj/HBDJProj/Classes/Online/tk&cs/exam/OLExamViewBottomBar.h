//
//  OLExamViewBottomBar.h
//  HBDJProj
//
//  Created by Peanut Lee on 2018/5/7.
//  Copyright © 2018年 Lee. All rights reserved.
//

#import "LGBaseView.h"

@interface OLExamViewBottomBar : LGBaseView

/** 是否是回看状态 */
@property (assign,nonatomic) BOOL backLook;

@property (assign,nonatomic) NSInteger alreadyCount;
@property (assign,nonatomic) NSInteger totalCount;
+ (instancetype)examViewBottomBar;

@end
