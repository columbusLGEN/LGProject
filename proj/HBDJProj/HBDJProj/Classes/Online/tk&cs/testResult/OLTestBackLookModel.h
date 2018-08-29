//
//  OLTestBackLookModel.h
//  HBDJProj
//
//  Created by Peanut Lee on 2018/8/10.
//  Copyright © 2018年 Lee. All rights reserved.
//

#import <Foundation/Foundation.h>

@class OLExamSingleModel;

@interface OLTestBackLookModel : NSObject

//"detail":{
//    "isrightnum":0,
//    "score":0,
//    "timeused":61
//}
/// detail 里的三个属性完全可以直接放在外面，多此一举
/// 备注，这里的三个值从上个页面拿，这里就不处理了

@property (strong,nonatomic) NSArray<OLExamSingleModel *> *subjects;
@property (strong,nonatomic) id detail;

@end
