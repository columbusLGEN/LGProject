//
//  EDJLevelInsModel.h
//  HBDJProj
//
//  Created by Peanut Lee on 2018/4/23.
//  Copyright © 2018年 Lee. All rights reserved.
//

#import "LGBaseModel.h"

@interface EDJLevelInsModel : LGBaseModel
@property (strong,nonatomic) NSNumber *level;
@property (copy,nonatomic) NSString *levelName;
@property (strong,nonatomic) NSNumber *needScore;

@end
