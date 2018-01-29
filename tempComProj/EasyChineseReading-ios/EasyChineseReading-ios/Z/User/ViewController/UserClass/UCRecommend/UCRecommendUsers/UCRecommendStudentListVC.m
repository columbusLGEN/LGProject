//
//  UCRecommendStudentListVC.m
//  EasyChineseReading-ios
//
//  Created by 赵春阳 on 2017/9/15.
//  Copyright © 2017年 lee. All rights reserved.
//

#import "UCRecommendStudentListVC.h"

#import "UCRStudentListTableViewCell.h"

#import "UCRStudentSelectedHeaderView.h"

@interface UCRecommendStudentListVC () <UITableViewDelegate, UITableViewDataSource, UCRStudentSelectedHeaderViewDelegate>

@property (strong, nonatomic) UCRStudentSelectedHeaderView *headerView;
@property (assign, nonatomic) BOOL tapSelectedAll; // 点击全选改变全选状态

@end

@implementation UCRecommendStudentListVC

- (void)viewDidLoad {
    [super viewDidLoad];
    [self configTableView];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(updateWithNotification:) name:kNotificationRemoveSelectedStudent_2 object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(removeAllStudents)       name:kNotificationRemoveAllStudents_2     object:nil];
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
    
    [_tableView registerNib:[UINib nibWithNibName:NSStringFromClass([UCRStudentListTableViewCell class]) bundle:nil] forCellReuseIdentifier:NSStringFromClass([UCRStudentListTableViewCell class])];
    
    [self.view addSubview:_tableView];
}

/**
 获取班级id

 @param classId 班级id
 */
- (void)setClassId:(NSInteger)classId
{
    _classId = classId;
    if (self.arrDataSource.count == 0 && _classId != 0) {
        [self getStudents];
    }
}

/** 获取学生 */
- (void)getStudents
{
    WeakSelf(self)
    [[ClassRequest sharedInstance] getStudentsWithClassId:[NSString stringWithFormat:@"%ld", _classId]
                                               completion:^(id object, ErrorModel *error) {
                                                   StrongSelf(self)
                                                   if (error) {
                                                       [self presentFailureTips:error.message];
                                                   }
                                                   else {
                                                       self.arrDataSource = [UserModel mj_objectArrayWithKeyValuesArray:object];
                                                       if (self.arrDataSource.count > 0) {
                                                           [self.tableView reloadData];
                                                       }
                                                   }
                                               }];
}

#pragma mark - UITableViewDataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.arrDataSource.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UCRStudentListTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([UCRStudentListTableViewCell class])];
    
    cell.lblNumber.text = [NSString stringWithFormat:@"%02ld", indexPath.row + 1];
    cell.data = self.arrDataSource[indexPath.row];
    return cell;
}

#pragma mark - UITableViewDelete

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    _headerView = [UCRStudentSelectedHeaderView loadFromNib];
    _headerView.frame = CGRectMake(0, 0, Screen_Width, cHeaderHeight_44);
    _headerView.backgroundColor = [UIColor colorWithHexString:@"F6F6F6"];
    _headerView.delegate = self;
    _headerView.selectedAll = [self isSelectedAll];
    
    return _headerView;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return cHeaderHeight_44;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    UCRStudentListTableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
    UserModel *student = _arrDataSource[indexPath.row];
    student.isSelected = !student.isSelected;
    cell.isSelected = student.isSelected;
    
    if (student.isSelected)
        [self.arrSelectedStudent addObject:_arrDataSource[indexPath.row]];
    else
        [self.arrSelectedStudent removeObject:_arrDataSource[indexPath.row]];

    _headerView.selectedAll = [self isSelectedAll];
    
    self.reloadBlock();
}

#pragma mark - UCRStudentSelectedHeaderViewDelegate

/** 是否将改班级学生全部选择 */
- (BOOL)isSelectedAll
{
    NSSet *setArrDataSource = [NSSet setWithArray:_arrDataSource];
    NSSet *setArrSelected   = [NSSet setWithArray:_arrSelectedStudent];
    
    return _arrDataSource.count > 0 ? [setArrDataSource isSubsetOfSet:setArrSelected] : NO;
}

#pragma mark - UCRStudentSelectedHeaderViewDelegate

/** 点击全选 */
- (void)selectedAllUser
{
    // 已经全部都选择
    if ([self isSelectedAll]) {
        for (NSInteger i = 0; i < _arrDataSource.count; i ++) {
            BookModel *book = _arrDataSource[i];
            book.isSelected = NO;
            [_arrSelectedStudent removeObject:_arrDataSource[i]];
        }
    }
    else {
        // cell 全部选中
        for (NSInteger i = 0; i < _arrDataSource.count; i ++) {
            BookModel *book = _arrDataSource[i];
            book.isSelected = YES;
        }
        // 将本界面学生全部加入选中学生
        [_arrSelectedStudent addObjectsFromArray:_arrDataSource];
        // 清除重复学生
        NSSet *currentArrSet = [NSSet setWithArray:_arrSelectedStudent];
        [_arrSelectedStudent removeAllObjects];
        NSArray *array = [currentArrSet allObjects];
        // 没有重复学生的数组
        [_arrSelectedStudent addObjectsFromArray:array];
    }
    _headerView.selectedAll = [self isSelectedAll];
    
    self.reloadBlock();
    
    [self.tableView reloadData];
}

#pragma mark - 通知方法

/** 删除选中的学生 */
- (void)updateWithNotification:(NSNotification *)notification
{
    [self.tableView reloadData];
}

/** 删除全部选中的学生 */
- (void)removeAllStudents
{
    [self.tableView reloadData];
}


@end
