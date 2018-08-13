//
//  DJThreemeetListViewController.h
//  HBDJProj
//
//  Created by Peanut Lee on 2018/7/20.
//  Copyright © 2018年 Lee. All rights reserved.
//

#import "LGBaseTableViewController.h"

/** 三会一课数据列表类型 */
typedef NS_ENUM(NSUInteger, DJSessionType) {
    /** 全部 */
    DJSessionTypeAll,
    /** 支部党员大会 */
    DJSessionTypeZBDYMeeting,
    /** 党支部委员会 */
    DJSessionTypeDZBWYMeeting,
    /** 党小组会 */
    DJSessionTypeDXZMeeting,
    /** 党课 */
    DJSessionTypeDLesson
};

@interface DJThreemeetListViewController : LGBaseTableViewController
/** 三会一课数据列表类型 */
@property (assign,nonatomic) DJSessionType sessionType;

- (void)upload_reloadData;

@end
