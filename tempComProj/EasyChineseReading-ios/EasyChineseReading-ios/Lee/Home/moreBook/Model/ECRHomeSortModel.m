//
//  ECRHomeSortModel.m
//  EasyChineseReading-ios
//
//  Created by lee on 2017/8/30.
//  Copyright © 2017年 lee. All rights reserved.
//

#import "ECRHomeSortModel.h"

@implementation ECRHomeSortModel

// 当模型的数组中包含模型时,用该方法返回 数组名 + 模型类名
+ (NSDictionary *)mj_objectClassInArray{
    return @{@"classModelArray":@"ECRClassSortModel"
             };
}

@end
