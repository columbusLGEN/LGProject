//
//  HPSearchRequest.h
//  HBDJProj
//
//  Created by Peanut Lee on 2018/6/2.
//  Copyright © 2018年 Lee. All rights reserved.
//

#import "LGBaseRequest.h"

@interface HPSearchRequest : LGBaseRequest

- (id)initWithContent:(NSString *)contetnt type:(NSInteger)type offset:(NSString *)offset length:(NSString *)length success:(LGRequestSuccess)success failure:(LGRequestFailure)failure networkFailure:(NetworkFailure)networkFailure;

@end
