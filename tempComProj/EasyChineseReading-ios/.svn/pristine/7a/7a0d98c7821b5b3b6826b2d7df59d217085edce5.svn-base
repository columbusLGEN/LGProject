//
//  UCStudentListVC.m
//  EasyChineseReading-ios
//
//  Created by 赵春阳 on 2017/9/12.
//  Copyright © 2017年 lee. All rights reserved.
//

#import "UCStudentListVC.h"

#import "UCStudentListTableViewCell.h"

#import "UCStudentInfoVC.h"
#import "UCStudentManagerVC.h"

@interface UCStudentListVC () <UITableViewDelegate, UITableViewDataSource>

@end

@implementation UCStudentListVC

- (void)viewDidLoad {
    [super viewDidLoad];
    [self configStudentListView];
    [self configEmptyView];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - 配置界面

- (void)configStudentListView
{
    _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, Screen_Width, Screen_Height - cHeaderHeight_44 - cHeaderHeight_64) style:UITableViewStylePlain];
    _tableView.delegate = self;
    _tableView.dataSource = self;
    _tableView.estimatedRowHeight = 100;
    _tableView.rowHeight = UITableViewAutomaticDimension;
    _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    
    UIView *footer = [UIView new];
    footer.backgroundColor = [UIColor whiteColor];
    _tableView.tableFooterView = footer;
    
    [self.view addSubview:_tableView];
    
    [_tableView registerNib:[UINib nibWithNibName:NSStringFromClass([UCStudentListTableViewCell class]) bundle:nil] forCellReuseIdentifier:NSStringFromClass([UCStudentListTableViewCell class])];
    WeakSelf(self)
    [self fk_observeNotifcation:kNotificationCreateStudentInfo usingBlock:^(NSNotification *note) {
        StrongSelf(self)
        UserModel *user = note.object;
        if (user.classId == self.classId || self.classId == 0) {
            [self.arrDataSource insertObject:user atIndex:0];
            [self.tableView reloadData];
            self.emptyView.hidden = YES;
        }
    }];
    
    [self fk_observeNotifcation:kNotificationUpdateStudentInfo usingBlock:^(NSNotification *note) {
        StrongSelf(self)
        UserModel *user = note.object;
        if (self.classId == user.classId) {
            [self.arrDataSource addObject:user];
            [self.tableView reloadData];
            self.emptyView.hidden = self.arrDataSource.count > 0;
        }
    }];
}

- (void)configEmptyView
{
    _emptyView = [EmptyView loadFromNibWithFrame:CGRectMake(0, 0, self.view.width, self.view.height)];
    [_emptyView updateEmptyViewWithType:ENUM_EmptyResultTypeStudent Image:nil desc:nil subDesc:nil];
    [self.view addSubview:_emptyView];
}

#pragma mark - UITableViewDataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.arrDataSource.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UCStudentListTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([UCStudentListTableViewCell class])];
    cell.data = _arrDataSource[indexPath.row];
    cell.index = indexPath.row;
    
    WeakSelf(self)
    cell.updateSelectedUser = ^(UserModel *user) {
        [weakself editStudentWithStudent:user];
    };
    
    cell.deleteSelectedUser = ^(UserModel *user) {
        [weakself alertDeleteStudentWithStudent:user];
    };
    
    return cell;
}

#pragma mark - UITableViewDelegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    UCStudentInfoVC *studentVC = [UCStudentInfoVC loadFromStoryBoard:@"UserClass"];
    studentVC.student = _arrDataSource[indexPath.row];
    [self.navigationController pushViewController:studentVC animated:YES];
}
 
#pragma mark - action
/** 修改学生信息 */
- (void)editStudentWithStudent:(UserModel *)student
{
    UCStudentManagerVC *edit = [UCStudentManagerVC loadFromStoryBoard:@"UserClass"];
    edit.isEdit = YES;
    edit.student = student;
    WeakSelf(self)
    edit.updateTStudentSuccess = ^(UserModel *newStudent) {
        StrongSelf(self)
        [self.arrDataSource removeObject:student];
        // 如果修改后的班级还是当前班级, 直接加入当前列表
        if (student.classId == newStudent.classId) {
            [self.arrDataSource insertObject:newStudent atIndex:0];
        }
        else {
            [self fk_postNotification:kNotificationUpdateStudentInfo object:newStudent];
        }
        [self.tableView reloadData];
    };
    [self.navigationController pushViewController:edit animated:YES];
}
/** 提示删除学生 */
- (void)alertDeleteStudentWithStudent:(UserModel *)student
{
    static ZAlertView *alertView;
    if (alertView == nil) {
        NSString * str = [NSString stringWithFormat:@"%@ %@?", LOCALIZATION(@"确定要删除学生"), student.name];
        alertView = [[ZAlertView alloc] initWithTitle:str message:nil delegate:self cancelButtonTitle:LOCALIZATION(@"取消") otherButtonTitles:LOCALIZATION(@"确定"),nil];
        alertView.whenDidSelectCancelButton = ^{
            alertView = nil;
        };
        WeakSelf(self)
        alertView.whenDidSelectOtherButton = ^{
            alertView = nil;
            [weakself deleteWithStudent:student];
        };
        [alertView show];
    }
}
/** 删除学生 */
- (void)deleteWithStudent:(UserModel *)student
{
    [self showWaitTips];
    WeakSelf(self)
    [[ClassRequest sharedInstance] deleteStudentWithStudentId:student.userId Completion:^(id object, ErrorModel *error) {
        StrongSelf(self)
        [self dismissTips];
        if (error) {
            [self presentFailureTips:error.message];
        }
        else {
            NSInteger index = [self.arrDataSource indexOfObject:student];
            [self.arrDataSource removeObject:student];
            [self.tableView deleteRowsAtIndexPaths:@[[NSIndexPath indexPathForRow:index inSection:0]] withRowAnimation:UITableViewRowAnimationAutomatic];
            self.emptyView.hidden = self.arrDataSource.count > 0;
        }
    }];
}

@end
