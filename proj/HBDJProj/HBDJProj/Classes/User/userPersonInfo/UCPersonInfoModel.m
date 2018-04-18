//
//  UCPersonInfoModel.m
//  HBDJProj
//
//  Created by Peanut Lee on 2018/4/12.
//  Copyright © 2018年 Lee. All rights reserved.
//

#import "UCPersonInfoModel.h"

@implementation UCPersonInfoModel

- (BOOL)canChangePwd{
    if ([_itemName isEqualToString:@"密码"]) {
        _canChangePwd = YES;
    }else{
        _canChangePwd = NO;
    }
    return _canChangePwd;
}

@end
