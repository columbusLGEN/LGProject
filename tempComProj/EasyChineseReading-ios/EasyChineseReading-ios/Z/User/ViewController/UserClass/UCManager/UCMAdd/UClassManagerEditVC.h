//
//  UCMAddVC.h
//  EasyChineseReading-ios
//
//  Created by 赵春阳 on 17/9/2.
//  Copyright © 2017年 lee. All rights reserved.
//

#import "ECRBaseViewController.h"

@interface UClassManagerEditVC : ECRBaseTableViewController

@property (assign, nonatomic) ENUM_UpdateType classType;   // 类型 0展示 1创建 2修改班级
@property (strong, nonatomic) ClassModel *classInfo; // 班级信息

@property (copy, nonatomic) void (^updateClassSuccess)(ClassModel *); // 修改班级成功

@end
