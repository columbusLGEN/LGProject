//
//  UCImpowerTeacherViewController.m
//  EasyChineseReading-ios
//
//  Created by 赵春阳 on 2017/10/12.
//  Copyright © 2017年 retech. All rights reserved.
//

#import "UCImpowerTeacherVC.h"

#import "UCImpowerTeacherTableViewCell.h"

@interface UCImpowerTeacherVC () <UITableViewDelegate, UITableViewDataSource>

@end

@implementation UCImpowerTeacherVC

- (void)viewDidLoad {
    [super viewDidLoad];
    [self configTableView];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(updateWithNotification:) name:kNotificationRemoveSelectedTeacher_2 object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(removeAllStudents)       name:kNotificationRemoveAllTeachers_2     object:nil];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

#pragma mark - 配置界面

- (void)configTableView
{
    _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, Screen_Width, self.view.height) style:UITableViewStylePlain];
    _tableView.delegate = self;
    _tableView.dataSource = self;
    _tableView.estimatedRowHeight = 100;
    _tableView.rowHeight = UITableViewAutomaticDimension;
    _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;

    UIView *footer = [UIView new];
    footer.backgroundColor = [UIColor whiteColor];
    _tableView.tableFooterView = footer;
    
    [_tableView registerNib:[UINib nibWithNibName:NSStringFromClass([UCImpowerTeacherTableViewCell class]) bundle:nil] forCellReuseIdentifier:NSStringFromClass([UCImpowerTeacherTableViewCell class])];
    
    [self.view addSubview:_tableView];
}

#pragma mark - UITableViewDataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.arrDataSource.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UCImpowerTeacherTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([UCImpowerTeacherTableViewCell class])];
    
    cell.data = self.arrDataSource[indexPath.row];
    cell.lblNumber.text = [NSString stringWithFormat:@"%02ld", indexPath.row + 1];

    return cell;
}

#pragma mark - UITableViewDelegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    UCImpowerTeacherTableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
    UserModel *teacher = _arrDataSource[indexPath.row];
    teacher.isSelected = !teacher.isSelected;
    cell.isSelected = teacher.isSelected;
    if (teacher.isSelected)
        [self.arrSelectedTeacher addObject:_arrDataSource[indexPath.row]];
    else
        [self.arrSelectedTeacher removeObject:_arrDataSource[indexPath.row]];

    self.reloadTeacherBlock(_arrSelectedTeacher);
}

#pragma mark - 通知方法

/** 删除选中的教师 */
- (void)updateWithNotification:(NSNotification *)notification
{
    if ([_arrSelectedTeacher containsObject:notification.object]) 
        [_arrSelectedTeacher removeObject:notification.object];
    [self.tableView reloadData];
}

/** 删除全部选中的教师 */
- (void)removeAllStudents
{
    [_arrSelectedTeacher removeAllObjects];
    [self.tableView reloadData];
}

#pragma mark - 属性

- (NSMutableArray *)arrSelectedTeacher
{
    if (_arrSelectedTeacher == nil) {
        _arrSelectedTeacher = [NSMutableArray array];
    }
    return _arrSelectedTeacher;
}

@end
