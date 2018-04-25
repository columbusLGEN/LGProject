//
//  EDJSearchTagHeaderModel.h
//  HBDJProj
//
//  Created by Peanut Lee on 2018/4/25.
//  Copyright © 2018年 Lee. All rights reserved.
//

#import "LGBaseModel.h"

@interface EDJSearchTagHeaderModel : LGBaseModel
@property (assign,nonatomic) BOOL isHot;/// 是否是热门标签
@property (copy,nonatomic) NSString *itemName;

@end
