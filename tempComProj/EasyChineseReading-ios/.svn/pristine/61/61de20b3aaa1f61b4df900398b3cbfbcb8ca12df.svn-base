//
//  UserIntegralVC.m
//  EasyChineseReading-ios
//
//  Created by 赵春阳 on 17/9/4.
//  Copyright © 2017年 lee. All rights reserved.
//

#import "UserIntegralVC.h"

#import "UserIntegralTableViewCell.h"
#import "EmptyView.h"

@interface UserIntegralVC () <UITableViewDelegate, UITableViewDataSource>

@property (weak, nonatomic) IBOutlet UIView  *viewVerLine;
@property (weak, nonatomic) IBOutlet UILabel *lblDescribe;
@property (weak, nonatomic) IBOutlet UILabel *lblIntegral;
@property (weak, nonatomic) IBOutlet UIView  *viewLine;
@property (weak, nonatomic) IBOutlet UITableView *tableView;

/** 空白提示界面 */
@property (strong, nonatomic) EmptyView *emptyView;

/* 积分列表 */
@property (strong, nonatomic) NSMutableArray *arrIntegrals;

/** 当前页数 */
@property (assign, nonatomic) NSInteger currentPage;

@end

@implementation UserIntegralVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self configView];
    [self configEmptyView];
    [self showWaitTips];
    [self getFirstPageDataSource];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:NO animated:YES];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - 配置界面

- (void)updateSystemLanguage
{
    self.title = LOCALIZATION(@"积分");
    _lblDescribe.text = [NSString stringWithFormat:@"%@", LOCALIZATION(@"积分累计")];
    _lblIntegral.text = [NSString stringWithFormat:@"%ld", [UserRequest sharedInstance].user.score];
    [_tableView reloadData];
}

- (void)configEmptyView
{
    _emptyView = [EmptyView loadFromNibWithFrame:CGRectMake(0, cHeaderHeight_54, Screen_Width, Screen_Height - cHeaderHeight_54)];
    [_emptyView updateEmptyViewWithType:ENUM_EmptyResultTypeData Image:nil desc:LOCALIZATION(@"没有获得过积分") subDesc:nil];
    [self.view addSubview:_emptyView];
}

- (void)configView
{
    _viewVerLine.backgroundColor = [UIColor cm_mainColor];
    _viewLine.backgroundColor    = [UIColor cm_lineColor_D9D7D7_1];
    
    _lblIntegral.textColor       = [UIColor cm_mainColor];
    _lblDescribe.textColor       = [UIColor cm_blackColor_333333_1];
    
    _lblDescribe.font = [UIFont systemFontOfSize:cFontSize_16];
    _lblIntegral.font = [UIFont systemFontOfSize:26.f];
    
    [self.tableView registerNib:[UINib nibWithNibName:NSStringFromClass([UserIntegralTableViewCell class]) bundle:nil] forCellReuseIdentifier:NSStringFromClass([UserIntegralTableViewCell class])];
    
    // tableView 自适应高度
    _tableView.rowHeight = UITableViewAutomaticDimension;
    _tableView.estimatedRowHeight = 100;
    _tableView.sectionHeaderHeight = cHeaderHeight_44;
    _tableView.backgroundColor = [UIColor whiteColor];
    
    WeakSelf(self)
    _tableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        [weakself getFirstPageDataSource];
    }];
    
    _tableView.mj_footer = [MJRefreshBackNormalFooter footerWithRefreshingBlock:^{
        [weakself getDataSourceWithPage:_currentPage];
    }];
}

#pragma mark -
#pragma mark 获取数据

- (void)getFirstPageDataSource
{
    _currentPage = 0;
    WeakSelf(self)
    [[UserRequest sharedInstance] getIntegralListWithPage:[NSString stringWithFormat:@"%ld", _currentPage] completion:^(id object, ErrorModel *error) {
        StrongSelf(self)
        [self.tableView.mj_header endRefreshing];
        [self dismissTips];
        if (error) {
            [self presentSuccessTips:error.message];
        }
        else {
            self.arrIntegrals = [IntegralModel mj_objectArrayWithKeyValuesArray:object];
            if (self.arrIntegrals.count > 0)
                self.currentPage += 1;
            
            self.emptyView.hidden = self.arrIntegrals.count > 0;
            [self.tableView reloadData];
        }
    }];
}

- (void)getDataSourceWithPage:(NSInteger)page
{
    WeakSelf(self)
    [[UserRequest sharedInstance] getIntegralListWithPage:[NSString stringWithFormat:@"%ld", page] completion:^(id object, ErrorModel *error) {
        StrongSelf(self)
        [self.tableView.mj_footer endRefreshing];
        if (error) {
            [self presentSuccessTips:error.message];
        }
        else {
            NSMutableArray *array = [IntegralModel mj_objectArrayWithKeyValuesArray:object];
            if (array.count > 0) {
                self.currentPage += 1;
                self.emptyView.hidden = YES;
                
                [self.arrIntegrals addObjectsFromArray:array];
                [self.tableView reloadData];
            }
        }
    }];
}

#pragma mark - UITableViewDataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.arrIntegrals.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UserIntegralTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([UserIntegralTableViewCell class])];
    cell.data = _arrIntegrals[indexPath.row];
    return cell;
}

#pragma mark - UITableViewDelegate

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    UIView *header = [UIView new];
    header.backgroundColor = [UIColor whiteColor];
    
    UIView *verLine = [UIView new];
    verLine.backgroundColor = [UIColor cm_mainColor];
    [header addSubview:verLine];
    [verLine mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(header.mas_centerY);
        make.left.equalTo(header.mas_left).offset(12);
        make.size.mas_equalTo(CGSizeMake(3, 14));
    }];
    
    UILabel *lblDesc = [UILabel new];
    lblDesc.textColor = [UIColor cm_blackColor_333333_1];
    lblDesc.font = [UIFont systemFontOfSize:16.f];
    lblDesc.text = LOCALIZATION(@"积分明细");
    [header addSubview:lblDesc];
    [lblDesc mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(verLine.mas_centerY);
        make.left.equalTo(verLine.mas_right).offset(10);
    }];
    
    return header;
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section
{
    UIView *footer = [UIView new];
    footer.backgroundColor = [UIColor whiteColor];
    return footer;
}

#pragma mark -

- (NSMutableArray *)arrIntegrals
{
    if (_arrIntegrals == nil) {
        _arrIntegrals = [NSMutableArray array];
    }
    return _arrIntegrals;
}

@end
