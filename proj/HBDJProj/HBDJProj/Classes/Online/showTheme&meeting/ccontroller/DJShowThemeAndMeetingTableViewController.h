//
//  DJShowThemeAndMeetingTableViewController.h
//  HBDJProj
//
//  Created by Peanut Lee on 2018/7/10.
//  Copyright © 2018年 Lee. All rights reserved.
//

/// 三会一课 & 主题党日 详情页面控制器

#import "LGBaseTableViewController.h"

@class DJThemeMeetingsModel;

@interface DJShowThemeAndMeetingTableViewController : LGBaseTableViewController
//@property (strong,nonatomic) DJThemeMeetingsModel *model;
/** 1:三会一课; 3:主题党日 */
@property (assign,nonatomic) NSInteger tmOrTd;

@end
