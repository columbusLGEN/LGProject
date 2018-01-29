//
//  UCMangagerVC.m
//  EasyChineseReading-ios
//
//  Created by 赵春阳 on 17/9/2.
//  Copyright © 2017年 lee. All rights reserved.
//

#import "UClassManagerVC.h"

#import "UClassManagerTableViewCell.h"

#import "UClassManagerEditVC.h"
#import "UCReadDetailVC.h"

#define kClassCell NSStringFromClass([UClassManagerTableViewCell class])

@interface UClassManagerVC () <UITableViewDelegate, UITableViewDataSource>

@property (strong, nonatomic) UITableView *tableView;
@property (strong, nonatomic) NSMutableArray *arrDataSource;

@property (strong, nonatomic) EmptyView *emptyView;

@end

@implementation UClassManagerVC

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = LOCALIZATION(@"班级管理");
    [self configManageView];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

#pragma mark - 配置界面

- (void)configManageView
{
    // 获取数据
    self.arrDataSource = self.data;
    // 配置界面
    [self configNavigationItem];
    [self configHeaderView];
    [self configTableView];
    [self configEmptyView];
    [self addNotification];
}

- (void)configEmptyView
{
    _emptyView = [EmptyView loadFromNibWithFrame:CGRectMake(0, cHeaderHeight_44, Screen_Width, self.view.height - cHeaderHeight_44)];
    [_emptyView updateEmptyViewWithType:ENUM_EmptyResultTypeClass Image:nil desc:nil subDesc:nil];
    [self.view addSubview:_emptyView];
    _emptyView.hidden = _arrDataSource.count > 0;
}

- (void)configTableView
{
    _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, cHeaderHeight_44, Screen_Width, self.view.height - cHeaderHeight_44) style:UITableViewStylePlain];
    _tableView.delegate = self;
    _tableView.dataSource = self;
    _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    _tableView.rowHeight = cHeaderHeight_44;
    [_tableView registerNib:[UINib nibWithNibName:kClassCell bundle:nil] forCellReuseIdentifier:kClassCell];
    
    UIView *view = [[UIView alloc] init];
    view.backgroundColor = [UIColor whiteColor];
    _tableView.tableFooterView = view;
    
    [self.view addSubview:_tableView];
}

- (void)configHeaderView
{
    UIView *headerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, Screen_Width, cHeaderHeight_44)];
    headerView.backgroundColor = [UIColor colorWithHexString:@"F6F6F6"];
    [self.view addSubview:headerView];
    WeakSelf(self)
    [headerView mas_makeConstraints:^(MASConstraintMaker *make) {
        StrongSelf(self)
        make.left.equalTo(self.view.mas_left);
        make.top.equalTo(self.view.mas_top);
        make.right.equalTo(self.view.mas_right);
        make.height.mas_equalTo(cHeaderHeight_44);
    }];
    
    UILabel *lblName = [UILabel new];
    lblName.text = LOCALIZATION(@"班级名称");
    [headerView addSubview:lblName];
    [lblName mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(headerView.mas_left).offset(20);
        make.centerY.equalTo(headerView.mas_centerY);
    }];
    
    UILabel *lblNumber = [UILabel new];
    lblNumber.text = LOCALIZATION(@"班级人数");
    [headerView addSubview:lblNumber];
    [lblNumber mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(headerView.mas_centerX);
        make.centerY.equalTo(headerView.mas_centerY);
    }];
    
    UILabel *lblAction = [UILabel new];
    lblAction.text = LOCALIZATION(@"操作");
    [headerView addSubview:lblAction];
    [lblAction mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(headerView.mas_right).offset(20);
        make.centerY.equalTo(headerView.mas_centerY);
        make.size.mas_offset(CGSizeMake(100, 20));
    }];
    
    lblName.textColor = lblNumber.textColor = lblAction.textColor = [UIColor cm_blackColor_333333_1];
    lblName.font = lblNumber.font = lblAction.font = [UIFont systemFontOfSize:cFontSize_16];
}

- (void)configNavigationItem
{
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"icon_class_add_white"] style:UIBarButtonItemStylePlain target:self action:@selector(addClass)];
}

/** 添加通知 */
- (void)addNotification
{
    WeakSelf(self)
    [self fk_observeNotifcation:kNotificationUpdateClasses usingBlock:^(NSNotification *note) {
        StrongSelf(self)
        self.arrDataSource = [[CacheDataSource sharedInstance] loadCacheWithCacheKey:CacheKey_ClassesList];
        self.emptyView.hidden = YES;
        [self.tableView reloadData];
    }];
}

#pragma mark - UITableViewDataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.arrDataSource.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UClassManagerTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:kClassCell];
    
    cell.index = indexPath.row;
    cell.data = _arrDataSource[indexPath.row];
    WeakSelf(self)
    cell.deleteClass = ^(ClassModel *classInfo) {
        [weakself deleteClassWithClass:classInfo];
    };
    cell.updateClass = ^(ClassModel *classInfo) {
        [weakself updateClassWithClass:classInfo];
    };
    
    return cell;
}

#pragma mark - UITableViewDelegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    UClassManagerEditVC *updateClassVC = [UClassManagerEditVC loadFromStoryBoard:@"UserClass"];
    updateClassVC.classInfo = _arrDataSource[indexPath.row];
    updateClassVC.classType = ENUM_UpdateTypeNo;
    [self.navigationController pushViewController:updateClassVC animated:YES];
}

#pragma mark - action
/** 更新班级 */
- (void)updateClassWithClass:(ClassModel *)classInfo
{
    UClassManagerEditVC *updateClassVC = [UClassManagerEditVC loadFromStoryBoard:@"UserClass"];
    updateClassVC.classInfo = classInfo;
    updateClassVC.classType = ENUM_UpdateTypeUp;
    WeakSelf(self)
    updateClassVC.updateClassSuccess = ^(ClassModel *newClassInfo) {
        StrongSelf(self)
        [self.arrDataSource removeObject:classInfo];
        [self.arrDataSource addObject:newClassInfo];
        [[CacheDataSource sharedInstance] setCache:self.arrDataSource withCacheKey:CacheKey_ClassesList];
        [[NSNotificationCenter defaultCenter] fk_postNotification:kNotificationUpdateClasses];
        [self.tableView reloadData];
    };
    
    [self.navigationController pushViewController:updateClassVC animated:YES];
}

/** 删除班级 */
- (void)deleteClassWithClass:(ClassModel *)classInfo
{
    ZAlertView *alert = [[ZAlertView alloc] initWithTitle:LOCALIZATION(@"确认删除?") message:nil delegate:self cancelButtonTitle:LOCALIZATION(@"取消") otherButtonTitles:LOCALIZATION(@"确定"), nil];
    
    WeakSelf(self)
    alert.whenDidSelectOtherButton = ^{
        StrongSelf(self)
        [self showWaitTips];
        WeakSelf(self)
        [[ClassRequest sharedInstance] deleteClassWithClassId:classInfo.classId completion:^(id object, ErrorModel *error) {
            StrongSelf(self)
            [self dismissTips];
            if (error) {
                [self presentFailureTips:error.message];
            }
            else {
                NSInteger index = [self.arrDataSource indexOfObject:classInfo];
                [self.arrDataSource removeObject:classInfo];
                if (self.arrDataSource.count == 0)
                    self.emptyView.hidden = NO;
                
                [self.tableView deleteRowsAtIndexPaths:@[[NSIndexPath indexPathForRow:index inSection:0]] withRowAnimation:UITableViewRowAnimationAutomatic];
                [[CacheDataSource sharedInstance] setCache:self.arrDataSource withCacheKey:CacheKey_ClassesList];
                [[NSNotificationCenter defaultCenter] fk_postNotification:kNotificationUpdateClasses];
            }
        }];
    };
    [alert show];
}

/** 添加班级 */
- (void)addClass
{
    NSArray *arrTeachers = [[CacheDataSource sharedInstance] loadCacheWithCacheKey:CacheKey_TeacherList];
    if (arrTeachers.count > 0) {
        UClassManagerEditVC *addClassVC = [UClassManagerEditVC loadFromStoryBoard:@"UserClass"];
        addClassVC.classType = ENUM_UpdateTypeAdd;
        [self.navigationController pushViewController:addClassVC animated:YES];
    }
    else {
        [self presentFailureTips:LOCALIZATION(@"创建班级之前请先创建教师账号")];
    }
}

#pragma mark - 属性

- (NSMutableArray *)arrDataSource
{
    if (_arrDataSource == nil) {
        _arrDataSource = [[CacheDataSource sharedInstance] loadCacheWithCacheKey:CacheKey_ClassesList];
    }
    return _arrDataSource;
}

@end
