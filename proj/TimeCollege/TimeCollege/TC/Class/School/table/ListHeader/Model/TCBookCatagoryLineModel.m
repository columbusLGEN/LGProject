//
//  TCBookCatagoryLineModel.m
//  TimeCollege
//
//  Created by Peanut Lee on 2019/5/14.
//  Copyright © 2019 lee. All rights reserved.
//

#import "TCBookCatagoryLineModel.h"
#import "TCQuadrateModel.h"

@implementation TCBookCatagoryLineModel

+ (NSDictionary *)mj_objectClassInArray{
    
    return @{@"bookCata":@"TCQuadrateModel"};
}

- (NSArray<TCQuadrateModel *> *)bookCata{
    if (!_lineAssign) {
        for (TCQuadrateModel *fenlei in _bookCata) {
            fenlei.lineModel = self;
        }
        _lineAssign = YES;
    }
    return _bookCata;
}

@end
