//
//  LGResponseModel.h
//  HBDJProj
//
//  Created by Peanut Lee on 2018/5/30.
//  Copyright © 2018年 Lee. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface LGResponseModel : NSObject

/** en msg */
@property (strong,nonatomic) NSString *en_msg;
/** msg */
@property (strong,nonatomic) NSString *msg;
/** result,0:成功; 1: 失败 */
@property (assign,nonatomic) NSInteger result;
/** returnJson */
@property (strong,nonatomic) NSString *returnJson;

@end
