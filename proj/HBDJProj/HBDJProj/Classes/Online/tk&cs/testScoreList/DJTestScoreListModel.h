//
//  DJTestScoreListModel.h
//  HBDJProj
//
//  Created by Peanut Lee on 2018/7/9.
//  Copyright © 2018年 Lee. All rights reserved.
//

#import "OLTkcsModel.h"

@interface DJTestScoreListModel : OLTkcsModel

/// 备注：排名按数组中的索引 显示

@property (strong,nonatomic) NSString *name;
@property (strong,nonatomic) NSString *timeused;
/** 后台反的正确率,取值范围：0~100 */
@property (strong,nonatomic) NSString *score;

@end
