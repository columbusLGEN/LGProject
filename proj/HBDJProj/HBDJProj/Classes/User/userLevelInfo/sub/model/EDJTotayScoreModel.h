//
//  EDJTotayScoreModel.h
//  HBDJProj
//
//  Created by Peanut Lee on 2018/4/23.
//  Copyright © 2018年 Lee. All rights reserved.
//

#import "LGBaseModel.h"

@interface EDJTotayScoreModel : LGBaseModel
@property (copy,nonatomic) NSString *item;
@property (strong,nonatomic) NSString *rate;
@property (strong,nonatomic) NSNumber *score;

@end
