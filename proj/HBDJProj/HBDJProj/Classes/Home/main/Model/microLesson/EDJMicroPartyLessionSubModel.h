//
//  EDJMicroPartyLessionSonModel.h
//  HBDJProj
//
//  Created by Peanut Lee on 2018/4/24.
//  Copyright © 2018年 Lee. All rights reserved.
//
/// MARK: 微党课单条模型
#import "LGBaseModel.h"

@interface EDJMicroPartyLessionSubModel : LGBaseModel

@property (copy,nonatomic) NSString *title;
@property (strong,nonatomic) NSNumber *peopleCount;
@property (strong,nonatomic) NSNumber *time;
@property (copy,nonatomic) NSString *imgUrl;

@end
