//
//  DJTestScoreListModel.h
//  HBDJProj
//
//  Created by Peanut Lee on 2018/7/9.
//  Copyright © 2018年 Lee. All rights reserved.
//

#import "LGBaseModel.h"

@interface DJTestScoreListModel : LGBaseModel

@property (strong,nonatomic) NSString *rank;
@property (strong,nonatomic) NSString *name;
@property (strong,nonatomic) NSString *timeConsume;
@property (strong,nonatomic) NSString *correctRate;

@end
