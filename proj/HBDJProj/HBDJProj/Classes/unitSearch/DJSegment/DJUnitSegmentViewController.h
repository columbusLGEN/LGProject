//
//  DJUnitSegmentViewController.h
//  HBDJProj
//
//  Created by Peanut Lee on 2018/7/26.
//  Copyright © 2018年 Lee. All rights reserved.
//

#import "LGBaseViewController.h"

static NSString * const segmentConfigKey_title = @"segmentConfigKey_title";
static NSString * const segmentConfigKey_childvc = @"segmentConfigKey_childvc";
static NSString * const segmentConfigKey_childvcInstansilType = @"segmentConfigKey_childvcInstansilType";

/** 子控制器初始化方式 */
typedef NS_ENUM(NSUInteger, DJUnitSegmentChildvcInstansilType) {
    /** 代码初始化 */
    DJUnitSegmentChildvcInstansilTypeCode,
    /** IB初始化 */
    DJUnitSegmentChildvcInstansilTypeIB
};

@interface DJUnitSegmentViewController : LGBaseViewController
@property (strong,nonatomic) NSArray<NSDictionary *> *segmentConfigs;

@end
