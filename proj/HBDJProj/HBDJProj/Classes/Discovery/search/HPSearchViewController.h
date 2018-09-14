//
//  HPSearchViewController.h
//  HBDJProj
//
//  Created by Peanut Lee on 2018/6/1.
//  Copyright © 2018年 Lee. All rights reserved.
//

/// 旧版--首页搜索控制器 --- 变更为发现也搜索控制器

#import "LGSegmentViewController.h"
@class DJDataSyncer;

@interface HPSearchViewController : LGSegmentViewController
@property (assign,nonatomic) BOOL voice;
@property (strong,nonatomic) DJDataSyncer *dataSyncer;

@end
