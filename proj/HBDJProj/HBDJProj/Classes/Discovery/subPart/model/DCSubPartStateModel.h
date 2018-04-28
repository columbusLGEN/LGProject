//
//  DCSubPartStateModel.h
//  HBDJProj
//
//  Created by Peanut Lee on 2018/4/27.
//  Copyright © 2018年 Lee. All rights reserved.
//

#import "LGBaseModel.h"

@interface DCSubPartStateModel : LGBaseModel

@property (assign,nonatomic) NSInteger imgCount;

@property (assign,nonatomic) CGFloat cellHeight;

/// -----------------------

@property (copy,nonatomic) NSString *title;

@end
