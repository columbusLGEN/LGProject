//
//  EDJHomeImageLoopModel.h
//  HBDJProj
//
//  Created by Peanut Lee on 2018/5/25.
//  Copyright © 2018年 Lee. All rights reserved.
//

#import "LGBaseModel.h"

@interface EDJHomeImageLoopModel : LGBaseModel
/** 图片地址 */
@property (strong,nonatomic) NSString *classimg;
/** 分类id */
@property (assign,nonatomic) NSInteger classid;

@end
