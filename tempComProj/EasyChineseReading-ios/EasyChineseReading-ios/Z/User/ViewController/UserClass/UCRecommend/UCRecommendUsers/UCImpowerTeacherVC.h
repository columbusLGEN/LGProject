//
//  UCImpowerTeacherViewController.h
//  EasyChineseReading-ios
//
//  Created by 赵春阳 on 2017/10/12.
//  Copyright © 2017年 retech. All rights reserved.
//

#import "ECRBaseViewController.h"

@interface UCImpowerTeacherVC : ECRBaseViewController

@property (strong, nonatomic) UITableView *tableView;

@property (strong, nonatomic) NSArray *arrDataSource;   // 数据
@property (strong, nonatomic) NSMutableArray *arrSelectedTeacher;

@property (copy, nonatomic) void (^reloadTeacherBlock)(NSArray *);

@end
