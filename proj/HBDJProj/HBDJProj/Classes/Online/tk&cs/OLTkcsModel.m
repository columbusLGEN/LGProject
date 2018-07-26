//
//  OLTkcsModel.m
//  HBDJProj
//
//  Created by Peanut Lee on 2018/5/4.
//  Copyright © 2018年 Lee. All rights reserved.
//

#import "OLTkcsModel.h"

@implementation OLTkcsModel

- (NSString *)statusDesc{
    if (!_statusDesc) {
        switch (_teststatus) {
            case OLTkcsModelStateTesting:
                _statusDesc = @"进行中";
                break;
            case OLTkcsModelStateDone:
                _statusDesc = @"已答题";
                break;
            case OLTkcsModelStateEnd:
                _statusDesc = @"已结束";
                break;
        }
    }
    return _statusDesc;
}

- (UIColor *)statusDescColor{
    if (!_statusDescColor) {
        switch (_teststatus) {
            case OLTkcsModelStateTesting:
                _statusDescColor = UIColor.EDJMainColor;
                break;
            case OLTkcsModelStateDone:
                _statusDescColor = UIColor.EDJGrayscale_11;
                break;
            case OLTkcsModelStateEnd:
                _statusDescColor = UIColor.EDJGrayscale_F3;
                break;
        }
    }
    return _statusDescColor;
}

@end
