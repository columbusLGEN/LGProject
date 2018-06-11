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
EDJMicroLessionAlbumModel,
EDJDigitalModel;

@interface EDJHomeModel : LGBaseModel

/** 图片轮播 */
@property (strong,nonatomic) NSArray<EDJHomeImageLoopModel *> *imageLoops;
/** 微党课 */
@property (strong,nonatomic) NSArray<EDJMicroLessionAlbumModel *> *microLessons;
/** 党建要闻 */
@property (strong,nonatomic) NSArray<EDJMicroBuildModel *> *pointNews;
/** 数字阅读 */
@property (strong,nonatomic) NSArray<EDJDigitalModel *> *digitals;

/** 党建要闻的classid，用于请求党建要闻列表数据 */
@property (assign,nonatomic) NSInteger newsClassId;

@end
