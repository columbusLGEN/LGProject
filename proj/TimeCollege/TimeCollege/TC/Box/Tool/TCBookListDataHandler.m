//
//  TCBookListDataHandler.m
//  TimeCollege
//
//  Created by Peanut Lee on 2019/5/9.
//  Copyright © 2019 lee. All rights reserved.
//

#import "TCBookListDataHandler.h"

@implementation TCBookListDataHandler

- (void)requestDataWithType:(TCBookListRequestType)type addParam:(id)addParam success:(bldhSuccess)success failure:(bldhFailure)failure;{
    NSString *port;
    switch (type) {
        case TCBookListRequestTypeSearch_bookrack:{
            port = @"";
        }
            
            break;
        case TCBookListRequestTypeSearch_school:{
            port = @"";
        }
            
            break;
        case TCBookListRequestTypeDigital:{
            port = @"";
        }
            
            break;
        case TCBookListRequestTypeEBook:{
            port = @"";
        }
            
            break;
        default:
            port = @"";
            break;
    }
    
    /// TODO: 发送网络请求
    if (success) success(@"模拟成功");
//    if (failure) failure(@"模拟失败");
    
}

@end
