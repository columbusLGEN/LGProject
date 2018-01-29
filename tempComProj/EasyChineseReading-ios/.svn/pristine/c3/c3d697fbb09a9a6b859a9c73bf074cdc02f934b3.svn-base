//
//  UserVirtualCurrencyVC.m
//  EasyChineseReading-ios
//
//  Created by 赵春阳 on 17/9/4.
//  Copyright © 2017年 lee. All rights reserved.
//

#import "UserVirtualCurrencyVC.h"

#import "UserVirtualCurrencyTableViewCell.h"
#import "EmptyView.h"

#import "UVirtualCurrencyRechargeVC.h"

@interface UserVirtualCurrencyVC ()

@property (weak, nonatomic) IBOutlet UIView *viewHeader;

@property (weak, nonatomic) IBOutlet UIView *viewVerLine;
@property (weak, nonatomic) IBOutlet UIView *viewLine;
@property (weak, nonatomic) IBOutlet UIButton *btnRecharge;
@property (weak, nonatomic) IBOutlet UITableView *tableView;

@property (weak, nonatomic) IBOutlet UILabel *lblDescribe;
@property (weak, nonatomic) IBOutlet UILabel *lblVirtualCurrencyNumber;
@property (weak, nonatomic) IBOutlet UILabel *lblDescVCNum;

/* 充值记录 */
@property (strong, nonatomic) NSMutableArray *arrVirtualCurrency;
/** 空白提示界面 */
@property (strong, nonatomic) EmptyView *emptyView;
/** 当前页数 */
@property (assign, nonatomic) NSInteger currentPage;

@end

@implementation UserVirtualCurrencyVC

- (void)viewDidLoad {
    [super viewDidLoad];
    [self configView];
    [self configEmptyView];
    [self configMJRefresh];
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
}

#pragma mark 配置界面

- (void)updateSystemLanguage
{
    self.title = LOCALIZATION(@"虚拟币");
    _lblDescribe.text = [NSString stringWithFormat:@"%@", LOCALIZATION(@"虚拟币余额")];
    [_btnRecharge setTitle:LOCALIZATION(@"充值") forState:UIControlStateNormal];
    _lblVirtualCurrencyNumber.text = [NSString stringWithFormat:@"%.2f", [UserRequest sharedInstance].user.virtualCurrency];
    [_tableView reloadData];
}

- (void)configView
{
    self.view.backgroundColor = [UIColor whiteColor];
    
    _viewVerLine.backgroundColor = [UIColor cm_mainColor];
    _viewLine.backgroundColor    = [UIColor cm_lineColor_D9D7D7_1];
    
    _lblVirtualCurrencyNumber.textColor = [UIColor cm_mainColor];
    _lblDescribe.textColor              = [UIColor cm_blackColor_333333_1];
    _lblDescVCNum.textColor             = [UIColor cm_blackColor_666666_1];
    
    _lblVirtualCurrencyNumber.font = [UIFont boldSystemFontOfSize:30.f];
    _lblDescribe.font              = [UIFont systemFontOfSize:cFontSize_16];
    _lblDescVCNum.font             = [UIFont systemFontOfSize:cFontSize_16];
    
    _btnRecharge.backgroundColor = [UIColor cm_mainColor];
    _btnRecharge.layer.masksToBounds = YES;
    _btnRecharge.layer.cornerRadius = _btnRecharge.height/2;
    _btnRecharge.tintColor = [UIColor whiteColor];
    [_btnRecharge setTitle:LOCALIZATION(@"充值") forState:UIControlStateNormal];
    
    [self.tableView registerNib:[UINib nibWithNibName:NSStringFromClass([UserVirtualCurrencyTableViewCell class]) bundle:nil] forCellReuseIdentifier:NSStringFromClass([UserVirtualCurrencyTableViewCell class])];
    
    // tableView 自适应高度
    _tableView.rowHeight = UITableViewAutomaticDimension;
    _tableView.estimatedRowHeight = 100;
    _tableView.sectionHeaderHeight = cHeaderHeight_44;
    _tableView.backgroundColor = [UIColor whiteColor];
}

- (void)configEmptyView
{
    _emptyView = [EmptyView loadFromNibWithFrame:CGRectMake(0, _viewHeader.height, Screen_Width, Screen_Height - _viewHeader.height)];
    [_emptyView updateEmptyViewWithType:ENUM_EmptyResultTypeData Image:nil desc:LOCALIZATION(@"没有充值过虚拟币") subDesc:nil];
    [self.view addSubview:_emptyView];
}

- (void)configMJRefresh
{
    WeakSelf(self)
    _tableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        [weakself getFirstPageDataSource];
    }];
    _tableView.mj_footer = [MJRefreshBackNormalFooter footerWithRefreshingBlock:^{
        [weakself getDataSourceWithPage:_currentPage];
    }];
}

#pragma mark 获取数据

- (void)getFirstPageDataSource
{
    _currentPage = 0;
    WeakSelf(self)
    [[UserRequest sharedInstance] getVirtualCurrencyListWithPage:[NSString stringWithFormat:@"%ld", _currentPage] completion:^(id object, ErrorModel *error) {
        StrongSelf(self)
        [self.tableView.mj_header endRefreshing];
        [self dismissTips];
        if (error) {
            [self presentSuccessTips:error.message];
        }
        else {
            self.arrVirtualCurrency = [VirtualCurrencyModel mj_objectArrayWithKeyValuesArray:object];
            if (self.arrVirtualCurrency.count > 0) {
                self.currentPage += 1;
            }
            self.emptyView.hidden = self.arrVirtualCurrency.count > 0;
            [self.tableView reloadData];
        }
    }];
}

- (void)getDataSourceWithPage:(NSInteger)page
{
    WeakSelf(self)
    [[UserRequest sharedInstance] getVirtualCurrencyListWithPage:[NSString stringWithFormat:@"%ld", page] completion:^(id object, ErrorModel *error) {
        StrongSelf(self)
        [_tableView.mj_footer endRefreshing];
        if (error) {
            [self presentSuccessTips:error.message];
        }
        else {
            NSMutableArray *array = [VirtualCurrencyModel mj_objectArrayWithKeyValuesArray:object];
            if (array.count > 0) {
                self.currentPage += 1;
                self.emptyView.hidden = YES;
                [self.arrVirtualCurrency addObjectsFromArray:array];
                [self.tableView reloadData];
            }
        }
    }];
}

#pragma mark - UITableViewDataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return _arrVirtualCurrency.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UserVirtualCurrencyTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([UserVirtualCurrencyTableViewCell class])];
    cell.data = _arrVirtualCurrency[indexPath.row];
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
    lblDesc.text = LOCALIZATION(@"充值记录");
    [header addSubview:lblDesc];
    [lblDesc mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(verLine.mas_centerY);
        make.left.equalTo(verLine.mas_right).offset(10);
    }];
    
    return header;
}

#pragma mark - action

/** 虚拟币充值 */
- (IBAction)click_btnRecharge:(id)sender {
    UVirtualCurrencyRechargeVC *recharge = [UVirtualCurrencyRechargeVC loadFromStoryBoard:@"User"];
    recharge.payPurpose = ENUM_PayPurposeRecharge;
    [self.navigationController pushViewController:recharge animated:YES];
}

#pragma mark -

- (NSMutableArray *)arrVirtualCurrency
{
    if (_arrVirtualCurrency == nil) {
        _arrVirtualCurrency = [NSMutableArray array];
    }
    return _arrVirtualCurrency;
}

@end
