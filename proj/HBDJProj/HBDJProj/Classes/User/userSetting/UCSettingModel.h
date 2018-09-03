//
//  UCSettingModel.h
//  HBDJProj
//
//  Created by Peanut Lee on 2018/4/18.
//  Copyright © 2018年 Lee. All rights reserved.
//

#import "LGBaseModel.h"

@interface UCSettingModel : LGBaseModel

@property (copy,nonatomic) NSString *itemName;
/** 1: 右侧展示按钮 ; 0: 右侧展示文字 */
@property (assign,nonatomic) NSInteger contentType;
/** 0: 系统推送 1: 非WIFI网络提醒 */
@property (assign,nonatomic) NSInteger subType;
@property (copy,nonatomic) NSString *content;

/** 用户是否开启了通知权限 */
@property (assign,nonatomic) BOOL granted;

@end
