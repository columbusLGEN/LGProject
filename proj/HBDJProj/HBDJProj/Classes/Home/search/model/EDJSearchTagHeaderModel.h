//
//  EDJSearchTagHeaderModel.h
//  HBDJProj
//
//  Created by Peanut Lee on 2018/4/25.
//  Copyright © 2018年 Lee. All rights reserved.
//

#import "LGBaseModel.h"

@interface EDJSearchTagHeaderModel : LGBaseModel
/** 用于判断是否隐藏 header 右侧的删除按钮 */
@property (assign,nonatomic) BOOL isHot;
@property (copy,nonatomic) NSString *itemName;

@end
