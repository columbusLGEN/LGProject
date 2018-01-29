//
//  UCRStudentsSelectedView.m
//  EasyChineseReading-ios
//
//  Created by 赵春阳 on 2017/9/15.
//  Copyright © 2017年 lee. All rights reserved.
//

#import "UCRStudentsSelectedView.h"

#import "UCRStudentSelectedTableViewCell.h"

@interface UCRStudentsSelectedView ()<UITableViewDelegate, UITableViewDataSource, UCRStudentSelectedTableViewCellDelegate>


@end

@implementation UCRStudentsSelectedView


#pragma mark - 初始化

- (instancetype)initWithFrame:(CGRect)frame withObjects:(NSMutableArray *)objects{
    
    return [self initWithFrame:frame withObjects:objects canReorder:NO];
}

- (instancetype)initWithFrame:(CGRect)frame withObjects:(NSMutableArray *)objects canReorder:(BOOL)reOrder{
    
    self = [super initWithFrame:frame];
    
    if (self) {
        
//        self.objects = [NSMutableArray arrayWithArray:objects];
        self.objects = objects;
        [self configStudentsSelectedView];
    }
    return self;
}

#pragma mark - 配置界面

- (void)configStudentsSelectedView
{
    self.backgroundColor = [UIColor whiteColor];
    _tableView = [[UITableView alloc] initWithFrame:self.bounds];
    _tableView.delegate = self;
    _tableView.dataSource = self;
    _tableView.bounces = NO;
    _tableView.showsHorizontalScrollIndicator = NO;
    _tableView.showsVerticalScrollIndicator = NO;
    _tableView.rowHeight = cHeaderHeight_54;
    _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    _tableView.backgroundColor = [UIColor whiteColor];
    [self addSubview:_tableView];
    
    UIView *footer = [UIView new];
    footer.backgroundColor = [UIColor whiteColor];
    _tableView.tableFooterView = footer;
    
    [_tableView registerNib:[UINib nibWithNibName:NSStringFromClass([UCRStudentSelectedTableViewCell class]) bundle:nil]
     forCellReuseIdentifier:NSStringFromClass([UCRStudentSelectedTableViewCell class])];
}

#pragma mark - UITableViewDataSource

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    UCRStudentSelectedTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([UCRStudentSelectedTableViewCell class]) forIndexPath:indexPath];
    
    cell.delegate = self;
    cell.data = [self.objects objectAtIndex:indexPath.row];
    
    return cell;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [self.objects count];
}

#pragma mark - UITableViewDelegate

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    UIView *header = [UIView new];
    header.backgroundColor = [UIColor cm_lineColor_D9D7D7_1];
    
    UIView *verLine = [UIView new];
    verLine.backgroundColor = [UIColor cm_mainColor];
    [header addSubview:verLine];
    [verLine mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(header.mas_centerY);
        make.left.equalTo(header.mas_left).offset(15);
        make.size.mas_equalTo(CGSizeMake(3, 14));
    }];
    
    UILabel *lblDesc = [UILabel new];
    lblDesc.textColor = [UIColor cm_blackColor_333333_1];
    lblDesc.font = [UIFont systemFontOfSize:cFontSize_14];
    lblDesc.text = LOCALIZATION(@"选中账号");
    [header addSubview:lblDesc];
    [lblDesc mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(verLine.mas_centerY);
        make.left.equalTo(verLine.mas_right).offset(10);
    }];
    
    UIButton *btnClear = [UIButton new];
    [btnClear setTitle:[NSString stringWithFormat:@" %@", LOCALIZATION(@"清空")] forState:UIControlStateNormal];
    [btnClear setTitleColor:[UIColor cm_blackColor_333333_1] forState:UIControlStateNormal];
    [btnClear setImage:[UIImage imageNamed:@"icon_trash"] forState:UIControlStateNormal];
    [btnClear addTarget:self action:@selector(removeAllSelectedStudents) forControlEvents:UIControlEventTouchUpInside];
    [header addSubview:btnClear];
    [btnClear mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(verLine.mas_centerY);
        make.right.equalTo(header.mas_right).offset(-25);
    }];
    
    return header;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return cHeaderHeight_44;
}

#pragma mark -

- (void)removeSelectedStudent:(id)student
{
    if (_userType == ENUM_UserTypeTeacher) {
        [[NSNotificationCenter defaultCenter] postNotificationName:kNotificationRemoveSelectedTeacher object:student];
    }
    else {
        [[NSNotificationCenter defaultCenter] postNotificationName:kNotificationRemoveSelectedStudent object:student];
    }
}

- (void)removeAllSelectedStudents
{
    if (_userType == ENUM_UserTypeTeacher) {
        [[NSNotificationCenter defaultCenter] postNotificationName:kNotificationRemoveAllTeachers object:nil];
    }
    else {
        [[NSNotificationCenter defaultCenter] postNotificationName:kNotificationRemoveAllStudents object:nil];
    }
}

@end
