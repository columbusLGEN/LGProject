//
//  DJDataSyncer.h
//  HBDJProj
//
//  Created by Peanut Lee on 2018/9/13.
//  Copyright © 2018年 Lee. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface DJDataSyncer : NSObject

/** 首页 所有的微党课模型 */
@property (strong,nonatomic) NSArray *home_lessons;
/** 首页 所有的党建要闻模型 */
@property (strong,nonatomic) NSArray *home_news;

/** 发现 所有的问答 */
@property (strong,nonatomic) NSArray *dicovery_QA;
/** 发现 所有的支部动态 */
@property (strong,nonatomic) NSArray *dicovery_branch;
/** 发现 所有的党员舞台 */
@property (strong,nonatomic) NSArray *dicovery_PYQ;

@end
