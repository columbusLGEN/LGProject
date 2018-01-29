//
//  SpecialModel.h
//  EasyChineseReading-ios
//
//  Created by 赵春阳 on 17/9/4.
//  Copyright © 2017年 lee. All rights reserved.
//

#import "BaseModel.h"

@interface SpecialModel : BaseModel

/**
 专题接口
 */

/* 专题名 */
@property (strong, nonatomic) NSString *name;
/* 专题封面 */
@property (strong, nonatomic) NSString *specialPic;
/* 专题id */
@property (assign, nonatomic) NSInteger specialId;

/* 图书 */
@property (strong, nonatomic) NSMutableArray *books;

@end
