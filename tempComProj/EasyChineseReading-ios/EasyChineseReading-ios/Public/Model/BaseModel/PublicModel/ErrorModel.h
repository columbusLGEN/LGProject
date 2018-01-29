//
//  ErrorModel.h
//  EasyChineseReading-ios
//
//  Created by 赵春阳 on 17/9/4.
//  Copyright © 2017年 lee. All rights reserved.
//

#import "BaseModel.h"

@interface ErrorModel : BaseModel

/**
 错误
 */

@property (assign, nonatomic) NSInteger code;       // 错误码
@property (strong, nonatomic) NSString *message;    // 错误信息

@end
