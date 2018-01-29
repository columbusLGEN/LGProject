//
//  UClassMessageDetailVC.m
//  EasyChineseReading-ios
//
//  Created by 赵春阳 on 2017/11/1.
//  Copyright © 2017年 retech. All rights reserved.
//

#import "UClassMessageDetailVC.h"

#import "UCRecommendDetailStudentTableViewCell.h"
#import "UCRecommendDetailDescribeTableViewCell.h"
#import "UCRecommendDescTableViewCell.h"

#import "ECRBookInfoViewController.h"

#define kDescCell       NSStringFromClass([UCRecommendDescTableViewCell class])
#define kStudentCell    NSStringFromClass([UCRecommendDetailStudentTableViewCell class])
#define kDescribeCell   NSStringFromClass([UCRecommendDetailDescribeTableViewCell class])

@interface UClassMessageDetailVC () <UITableViewDelegate, UITableViewDataSource>

@property (strong, nonatomic) UITableView *tableView;
@property (strong, nonatomic) NSArray *arrUsers; // 用户数组

@end

@implementation UClassMessageDetailVC

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self configRecommendDetailView];
}

#pragma mark - 配置界面

- (void)updateSystemLanguage
{
    self.title = LOCALIZATION(@"站内信");
}

- (void)configRecommendDetailView
{
    _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, Screen_Width, Screen_Height - cHeaderHeight_64) style:UITableViewStylePlain];
    _tableView.delegate = self;
    _tableView.dataSource = self;
    _tableView.rowHeight = UITableViewAutomaticDimension;
    _tableView.estimatedRowHeight = 100;
    _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    
    UIView *footer = [UIView new];
    footer.backgroundColor = [UIColor whiteColor];
    _tableView.tableFooterView = footer;
    
    [self.view addSubview:_tableView];
    
    [_tableView registerNib:[UINib nibWithNibName:kDescribeCell bundle:nil] forCellReuseIdentifier:kDescribeCell];
    [_tableView registerNib:[UINib nibWithNibName:kStudentCell  bundle:nil] forCellReuseIdentifier:kStudentCell];
    [_tableView registerNib:[UINib nibWithNibName:kDescCell     bundle:nil] forCellReuseIdentifier:kDescCell];
}

#pragma mark - UITableViewDataSource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 3;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (0 == section || 1 == section)
        return 1;
    else
        return _message.student.count + 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (0 == indexPath.section) {
        UCRecommendDetailDescribeTableViewCell *descCell = [tableView dequeueReusableCellWithIdentifier:kDescribeCell];
        descCell.isMessage = YES;
        descCell.data = _message;
        return descCell;
    }
    else if (1 == indexPath.section) {
        UCRecommendDescTableViewCell *descCell = [tableView dequeueReusableCellWithIdentifier:kDescCell];
        return descCell;
    }
    else {
        UCRecommendDetailStudentTableViewCell *userCell = [tableView dequeueReusableCellWithIdentifier:kStudentCell];
        userCell.lblNumber.text = [NSString stringWithFormat:@"%02ld", indexPath.row];
        userCell.data = indexPath.row == 0 ? @"header" : [UserModel mj_objectWithKeyValues:_message.student[indexPath.row - 1]];
        return userCell;
    }
}

@end
