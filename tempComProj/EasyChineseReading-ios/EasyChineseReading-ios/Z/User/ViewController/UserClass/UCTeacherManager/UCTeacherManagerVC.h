//
//  UCTeacherMangerVC.h
//  EasyChineseReading-ios
//
//  Created by 赵春阳 on 2017/10/11.
//  Copyright © 2017年 retech. All rights reserved.
//

#import "ECRBaseViewController.h"

@interface UCTeacherManagerVC : ECRBaseTableViewController

@property (strong, nonatomic) UserModel *teacher;
/** YES 修改教师界面 NO 创建教师 */
@property (assign, nonatomic) BOOL isEdit;

@property (copy, nonatomic) void (^updateTeacherSuccess)(UserModel *teacher); // 修改教师成功
@property (copy, nonatomic) void (^addTeacherSuccess)(void); // 创建教师成功

@end
