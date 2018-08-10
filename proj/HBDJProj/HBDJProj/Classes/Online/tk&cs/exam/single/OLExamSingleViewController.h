//
//  OLExamSingleViewController.h
//  HBDJProj
//
//  Created by Peanut Lee on 2018/5/7.
//  Copyright © 2018年 Lee. All rights reserved.
//
/// 该控制器 显示一道题

#import "LGBaseTableViewController.h"
#import "OLExamSingleFooterView.h"
@class OLExamSingleModel;

@interface OLExamSingleViewController : LGBaseTableViewController
@property (strong,nonatomic) OLExamSingleModel *model;
@property (assign,nonatomic) BOOL backLook;

@end
