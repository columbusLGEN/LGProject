//
//  EDJSearchTagModel.h
//  HBDJProj
//
//  Created by Peanut Lee on 2018/4/25.
//  Copyright © 2018年 Lee. All rights reserved.
//

#import "LGBaseModel.h"

@interface EDJSearchTagModel : LGBaseModel
@property (strong,nonatomic) NSString *name;
@property (assign,nonatomic) NSInteger oriIndex;
/** YES: 是历史搜索记录 */
@property (assign,nonatomic) BOOL isHis;

@end
