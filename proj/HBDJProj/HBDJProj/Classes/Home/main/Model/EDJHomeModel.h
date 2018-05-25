//
//  EDJHomeModel.h
//  HBDJProj
//
//  Created by Peanut Lee on 2018/5/25.
//  Copyright © 2018年 Lee. All rights reserved.
//

#import "LGBaseModel.h"
@class EDJHomeImageLoopModel,
EDJMicroBuildModel,
EDJMicroPartyLessionSubModel,
EDJDigitalModel;

@interface EDJHomeModel : LGBaseModel

/** 图片轮播 */
@property (strong,nonatomic) NSArray<EDJHomeImageLoopModel *> *imageLoops;
/** 微党课 */
@property (strong,nonatomic) NSArray<EDJMicroPartyLessionSubModel *> *microLessons;
/** 党建要闻 */
@property (strong,nonatomic) NSArray<EDJMicroBuildModel *> *pointNews;
/** 数字阅读 */
@property (strong,nonatomic) NSArray<EDJDigitalModel *> *digitals;

@end
