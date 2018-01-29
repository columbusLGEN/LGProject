//
//  ErrorModel.m
//  EasyChineseReading-ios
//
//  Created by 赵春阳 on 17/9/4.
//  Copyright © 2017年 lee. All rights reserved.
//

#import "ErrorModel.h"

@implementation ErrorModel

- (void)setMessage:(NSString *)message
{
    _message = message;
    if (_code <= -1000) {
        _message = @"网络连接失败";
    }
}

@end
