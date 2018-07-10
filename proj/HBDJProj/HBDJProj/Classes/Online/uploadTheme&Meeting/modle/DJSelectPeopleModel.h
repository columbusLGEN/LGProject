//
//  DJSelectPeopleModel.h
//  HBDJProj
//
//  Created by Peanut Lee on 2018/7/5.
//  Copyright © 2018年 Lee. All rights reserved.
//

#import "LGBaseModel.h"

typedef NS_ENUM(NSUInteger, DJMemeberAttendType) {
    DJMemeberAttendTypeDefault,/// 默认，管理员还未做任何操作
    DJMemeberAttendTypePresent,/// 出席
    DJMemeberAttendTypeAbsent/// 缺席
};

@interface DJSelectPeopleModel : LGBaseModel

@property (strong,nonatomic) NSString *name;

/** 党员出席状态，
 DJMemeberAttendTypeDefault：未知
 DJMemeberAttendTypePresent：出席
 DJMemeberAttendTypeAbsent：缺席
 */
@property (assign,nonatomic) DJMemeberAttendType attend;

@property (assign,nonatomic) BOOL select_present;
@property (assign,nonatomic) BOOL select_absent;
@property (assign,nonatomic) BOOL select_host;


@end
