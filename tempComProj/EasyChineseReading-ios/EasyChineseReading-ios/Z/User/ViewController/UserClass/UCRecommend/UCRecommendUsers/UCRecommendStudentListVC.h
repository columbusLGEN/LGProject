//
//  UCRecommendStudentListVC.h
//  EasyChineseReading-ios
//
//  Created by 赵春阳 on 2017/9/15.
//  Copyright © 2017年 lee. All rights reserved.
//

#import "ECRBaseViewController.h"

@interface UCRecommendStudentListVC : ECRBaseViewController

@property (strong, nonatomic) UITableView *tableView;

@property (assign, nonatomic) NSInteger classId; // 班级 id

@property (strong, nonatomic) NSArray *arrDataSource;   // 数据
@property (strong, nonatomic) NSMutableArray *arrSelectedStudent;

@property (copy, nonatomic) void (^reloadBlock)(void);

@end
