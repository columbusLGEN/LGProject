//
//  OLTestBackLookDetailModel.h
//  HBDJProj
//
//  Created by Peanut Lee on 2018/9/10.
//  Copyright © 2018年 Lee. All rights reserved.
//

#import "LGBaseModel.h"

@interface OLTestBackLookDetailModel : LGBaseModel

/** 正确数 */
@property (assign,nonatomic) NSInteger isrightnum;
/** 总题数 */
@property (assign,nonatomic) NSInteger subCount;
/** 花费时间 单位：秒 */
@property (assign,nonatomic) NSInteger timeused;
/** ??? */
@property (assign,nonatomic) NSInteger score;

@end
