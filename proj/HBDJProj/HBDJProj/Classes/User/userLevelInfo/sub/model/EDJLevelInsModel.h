//
//  EDJLevelInsModel.h
//  HBDJProj
//
//  Created by Peanut Lee on 2018/4/23.
//  Copyright © 2018年 Lee. All rights reserved.
//

#import "LGBaseModel.h"

@interface EDJLevelInsModel : LGBaseModel

//{"neededintegral":1,"seqid":1,"creatorid":1,"status":1,"minday":0,"grade":1,
//    "gradename":"先锋一级"}
@property (strong,nonatomic) NSNumber *grade;
@property (strong,nonatomic) NSString *gradename;
@property (strong,nonatomic) NSNumber *neededintegral;
@property (strong,nonatomic) NSString *minday;

@end
