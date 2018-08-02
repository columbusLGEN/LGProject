//
//  EDJMicroPartyLessionSonModel.m
//  HBDJProj
//
//  Created by Peanut Lee on 2018/4/24.
//  Copyright © 2018年 Lee. All rights reserved.
//

#import "DJDataBaseModel.h"

@implementation DJDataBaseModel

- (NSInteger)praisecount{
    if (_praisecount < 0) {
        _praisecount = 0;
    }
    return _praisecount;
}
- (NSInteger)collectioncount{
    if (_collectioncount < 0) {
        _collectioncount = 0;
    }
    return _collectioncount;
}
- (NSInteger)playcount{
    if (_playcount < 0) {
        _playcount = 0;
    }
    return _playcount;
}

- (NSString *)createdDate{
    if (!_createdDate) {
        _createdDate = [_createdtime timestampToMin];
        
    }
    return _createdDate;
}

@end
