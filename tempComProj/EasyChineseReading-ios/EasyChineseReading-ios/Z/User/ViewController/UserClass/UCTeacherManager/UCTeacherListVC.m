//
//  UCTeackerListVC.m
//  EasyChineseReading-ios
//
//  Created by 赵春阳 on 2017/10/11.
//  Copyright © 2017年 retech. All rights reserved.
//

#import "UCTeacherListVC.h"

#import "UCStudentListTableViewCell.h"

#import "UCTeacherManagerVC.h"
#import "UCTeacherInfoVC.h"

@interface UCTeacherListVC () <UITableViewDelegate, UITableViewDataSource>

@property (strong, nonatomic) NSMutableArray *arrTeachers; // 教师数组

@property (strong, nonatomic) UITableView *tableView;

@property (strong, nonatomic) EmptyView *emptyView;

@end

@implementation UCTeacherListVC

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self configNavigationBar];
    [self configTableView];
    [self configEmptyView];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - 配置界面

- (void)updateSystemLanguage
{
    self.title = LOCALIZATION(@"教师管理");
}

- (void)configEmptyView
{
    _emptyView = [EmptyView loadFromNibWithFrame:CGRectMake(0, 0, Screen_Width, self.view.height)];
    [_emptyView updateEmptyViewWithType:ENUM_EmptyResultTypeTeacher Image:nil desc:nil subDesc:nil];
    [self.view addSubview:_emptyView];
    _emptyView.hidden = _arrTeachers.count > 0;
}

- (void)configTableView
{
    _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, Screen_Width, Screen_Height - cHeaderHeight_64) style:UITableViewStylePlain];
    _tableView.delegate = self;
    _tableView.dataSource = self;
    
    _tableView.estimatedSectionHeaderHeight = 0;
    _tableView.estimatedSectionFooterHeight = 0;

    _tableView.estimatedRowHeight = 100;
    _tableView.rowHeight = UITableViewAutomaticDimension;
    
    _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    
    UIView *footer = [UIView new];
    footer.backgroundColor = [UIColor whiteColor];
    _tableView.tableFooterView = footer;
    
    [self.view addSubview:_tableView];
    
    [_tableView registerNib:[UINib nibWithNibName:NSStringFromClass([UCStudentListTableViewCell class]) bundle:nil] forCellReuseIdentifier:NSStringFromClass([UCStudentListTableViewCell class])];
}

- (void)configNavigationBar
{
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"icon_class_add_white"] style:UIBarButtonItemStylePlain target:self action:@selector(addTeacher)];
}

#pragma mark - UITableViewDataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.arrTeachers.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UCStudentListTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([UCStudentListTableViewCell class])];
    
    cell.index = indexPath.row;
    cell.data = _arrTeachers[indexPath.row];

    WeakSelf(self)
    cell.updateSelectedUser = ^(UserModel *user) {
        [weakself editTeacher:user];
    };
                                
    cell.deleteSelectedUser = ^(UserModel *user) {
        [weakself alertDeleteTeacher:user];
    };
    return cell;
}

#pragma mark - UITableViewDelegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    UCTeacherInfoVC *editVC = [UCTeacherInfoVC loadFromStoryBoard:@"UserClass"];
    editVC.teacher = _arrTeachers[indexPath.row];
//    editVC.canEdit = NO;
    
    [self.navigationController pushViewController:editVC animated:YES];
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section
{
    UIView *footer = [UIView new];
    footer.backgroundColor = [UIColor whiteColor];
    return footer;
}

#pragma mark - action

/** 创建教师 */
- (void)addTeacher
{
    UCTeacherManagerVC *teacherManager = [UCTeacherManagerVC loadFromStoryBoard:@"UserClass"];
    WeakSelf(self)
    teacherManager.addTeacherSuccess = ^{
        StrongSelf(self)
        self.arrTeachers = [[CacheDataSource sharedInstance] loadCacheWithCacheKey:CacheKey_TeacherList];
        self.emptyView.hidden = YES;
        [self.tableView reloadData];
    };
    [self.navigationController pushViewController:teacherManager animated:YES];
}

/** 修改教师 */
- (void)editTeacher:(UserModel *)teacher
{
    UCTeacherManagerVC *teacherManager = [UCTeacherManagerVC loadFromStoryBoard:@"UserClass"];
    teacherManager.teacher = teacher;
    teacherManager.isEdit = YES;
    WeakSelf(self)
    teacherManager.updateTeacherSuccess = ^(UserModel *newTeacher) {
        StrongSelf(self)
        [self.arrTeachers removeObject:teacher];
        [self.arrTeachers addObject:newTeacher];
        [[CacheDataSource sharedInstance] setCache:self.arrTeachers withCacheKey:CacheKey_TeacherList];
        [self.tableView reloadData];
    };
    [self.navigationController pushViewController:teacherManager animated:YES];
}

/** 提示确认删除教师 */
- (void)alertDeleteTeacher:(UserModel *)teacher
{
    static ZAlertView *alertView;
    if (alertView == nil) {
        NSString * str = [NSString stringWithFormat:@"%@ %@?", LOCALIZATION(@"确定要删除教师"), teacher.name];
        alertView = [[ZAlertView alloc] initWithTitle:str message:nil delegate:self cancelButtonTitle:LOCALIZATION(@"取消") otherButtonTitles:LOCALIZATION(@"确定"), nil];
        WeakSelf(self)
        alertView.whenDidSelectCancelButton = ^{
            alertView = nil;
        };
        alertView.whenDidSelectOtherButton = ^{
            alertView = nil;
            [weakself deleteWithTeacher:teacher];
        };
        [alertView show];
    }
}

/** 删除教师 */
- (void)deleteWithTeacher:(UserModel *)teacher
{
    [self showWaitTips];
    WeakSelf(self)
    [[ClassRequest sharedInstance] deleteTeacherWithTeacherId:teacher.userId completion:^(id object, ErrorModel *error) {
        StrongSelf(self)
        [self dismissTips];
        if (error) {
            [self presentFailureTips:error.message];
        }
        else {
            NSInteger index = [_arrTeachers indexOfObject:teacher];
            [self.arrTeachers removeObject:teacher];
            [[CacheDataSource sharedInstance] setCache:_arrTeachers withCacheKey:CacheKey_TeacherList];
            
            [self.tableView deleteRowsAtIndexPaths:@[[NSIndexPath indexPathForRow:index inSection:0]] withRowAnimation:UITableViewRowAnimationAutomatic];
        }
    }];
}

#pragma mark - 属性

- (NSArray *)arrTeachers
{
    if (_arrTeachers == nil) {
        _arrTeachers = [[CacheDataSource sharedInstance] loadCacheWithCacheKey:CacheKey_TeacherList];
    }
    return _arrTeachers;
}

@end
