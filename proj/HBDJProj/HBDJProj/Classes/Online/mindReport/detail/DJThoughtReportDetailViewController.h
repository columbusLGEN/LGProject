//
//  DJThoughtReportDetailViewController.h
//  HBDJProj
//
//  Created by Peanut Lee on 2018/7/24.
//  Copyright © 2018年 Lee. All rights reserved.
//

#import "LGBaseViewController.h"

@class DJThoutghtRepotListModel;

@interface DJThoughtReportDetailViewController : LGBaseViewController
@property (strong,nonatomic) DJThoutghtRepotListModel *model;
/** 2:思想汇报 4:述职述廉 */
@property (assign,nonatomic) NSInteger trOrSp;

@end
