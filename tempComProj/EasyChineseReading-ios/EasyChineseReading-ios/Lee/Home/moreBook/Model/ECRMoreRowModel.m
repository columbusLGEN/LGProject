//
//  ECRMoreRowModel.m
//  EasyChineseReading-ios
//
//  Created by Peanut Lee on 2017/10/20.
//  Copyright © 2017年 retech. All rights reserved.
//

#import "ECRMoreRowModel.h"
#import "ECRClassSortModel.h"

@implementation ECRMoreRowModel

- (void)setClassArray:(NSMutableArray<ECRClassSortModel *> *)classArray{
    _classArray = classArray;
    ECRClassSortModel *csModel = [[ECRClassSortModel alloc] init];
    csModel.name = @"全部";
    csModel.en_name = @"All";
    csModel.id = -1;
    csModel.parentId = -1;
    
    ECRClassSortModel *first;
    if (classArray.count) {
        first = [classArray firstObject];
    }
    csModel.type = first.type;
    csModel.lg_isSelected = YES;
    [classArray insertObject:csModel atIndex:0];
}


+ (NSDictionary *)mj_objectClassInArray{
    return @{@"classArray":@"ECRClassSortModel"};
}

@end
