//
//  OLTestBackLookModel.h
//  HBDJProj
//
//  Created by Peanut Lee on 2018/8/10.
//  Copyright © 2018年 Lee. All rights reserved.
//

#import <Foundation/Foundation.h>

@class OLExamSingleModel,OLTestBackLookDetailModel;

@interface OLTestBackLookModel : NSObject

@property (strong,nonatomic) NSArray<OLExamSingleModel *> *subjects;
@property (strong,nonatomic) OLTestBackLookDetailModel *detail;

@end
