//
//  ECRRowObject.m
//  EasyChineseReading-ios
//
//  Created by Peanut Lee on 2017/10/24.
//  Copyright © 2017年 retech. All rights reserved.
//

#import "ECRRowObject.h"

@implementation ECRRowObject

- (NSMutableArray *)modelArray{
    if (_modelArray == nil) {
        _modelArray = [NSMutableArray arrayWithCapacity:10];
    }
    return _modelArray;
}

@end
