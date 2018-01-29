//
//  UCSManagerAddVC.h
//  EasyChineseReading-ios
//
//  Created by 赵春阳 on 17/9/2.
//  Copyright © 2017年 lee. All rights reserved.
//

#import "ECRBaseViewController.h"

@interface UCStudentManagerVC : ECRBaseTableViewController

@property (strong, nonatomic) UserModel *student;
@property (assign, nonatomic) BOOL isEdit;

@property (copy, nonatomic) void (^updateTStudentSuccess)(UserModel *); // 修改学生成功

@end
 
