//
//  ULeaseVC.m
//  EasyChineseReading-ios
//
//  Created by 赵春阳 on 17/9/1.
//  Copyright © 2017年 lee. All rights reserved.
//

#import "UserLeaseVC.h"

#import "UserLeaseTableViewCell.h"
#import "UserLeaseTicketsTableViewCell.h"
#import "UserLeaseMoreTableViewCell.h"

#import "UVirtualCurrencyRechargeVC.h"
#import "UserLeaseSelectedVC.h"
#import "UserLeaseDetailVC.h"

@interface UserLeaseVC () <UITableViewDelegate, UITableViewDataSource, UserLeaseTableViewCellDelegate>

@property (weak, nonatomic) IBOutlet UIView *viewHeader;

@property (weak, nonatomic) IBOutlet UIImageView *imgBackground;
@property (weak, nonatomic) IBOutlet UIImageView *imgHeader;

@property (weak, nonatomic) IBOutlet UILabel *lblDescLeft;
@property (weak, nonatomic) IBOutlet UILabel *lblRange;
@property (weak, nonatomic) IBOutlet UILabel *lblEndTime;

@property (weak, nonatomic) IBOutlet UIButton *btnPay;

@property (weak, nonatomic) IBOutlet UITableView *tableView;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *lblDescCenterYConstraint;

@property (strong, nonatomic) NSMutableArray *arrLeases;   // 系列列表
@property (strong, nonatomic) NSMutableArray *arrTicket;   // 卡券兑换 集合

@property (strong, nonatomic) EmptyView *emptyLease;                  // 没有系列
@property (strong, nonatomic) EmptyView *emptyTicket;                 // 没有兑换书集
@property (strong, nonatomic) UVirtualCurrencyRechargeVC *rechargeVC; // 全平台包月

@property (assign, nonatomic) NSInteger currentLeasePage;    // 当前系列页
@property (assign, nonatomic) NSInteger currentTicketPage;   // 当前卡券兑换的书集页
@property (assign, nonatomic) NSInteger selectedIndexLease;  // 选中的系列
@property (assign, nonatomic) NSInteger selectedIndexTicket; // 选中的专题(兑换)

@property (assign, nonatomic) BOOL isLoadMoreLeases; // 点击加载更多系列
@property (assign, nonatomic) BOOL isLoadMoreTicket; // 点击加载更多兑换的书集
@property (assign, nonatomic) BOOL noMoreLeases;     // 没有更多的系列
@property (assign, nonatomic) BOOL noMoreTicket;     // 没有更多的专题

@end

@implementation UserLeaseVC

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self configLeaseView];

    [self showWaitTips];
    [self getFirstLeaseData];
    [self getFirstTicketBooksData];
    
    WeakSelf(self)
    [self fk_observeNotifcation:kNotificationUpdateSerialInfo usingBlock:^(NSNotification *note) {
        StrongSelf(self)
        if (self.arrLeases.count > 0) {
            [_arrLeases removeObjectAtIndex:_selectedIndexLease];
        }
        [_arrLeases insertObject:note.object atIndex:_selectedIndexLease];
        [_tableView reloadData];
    }];
}

#pragma mark - 配置界面

- (void)updateSystemLanguage
{
    [_btnPay setTitle:[UserRequest sharedInstance].user.allbooks ? LOCALIZATION(@"续期") : LOCALIZATION(@"购买") forState:UIControlStateNormal];
    _lblDescLeft.text  = LOCALIZATION(@"VIP租阅");
    _lblRange.text     = [NSString stringWithFormat:@"-%@",LOCALIZATION(@"全平台资源")];
    _lblEndTime.hidden = [[UserRequest sharedInstance].user.endtime empty] || ![UserRequest sharedInstance].user.endtime;
    _lblDescCenterYConstraint.constant = _lblEndTime.hidden ? 10 : 0;
    _lblEndTime.text  = [NSString stringWithFormat:@"%@ %@", LOCALIZATION(@"到期"), [UserRequest sharedInstance].user.endtime];
    [_tableView reloadData];
}

- (void)configLeaseView
{
    _imgBackground.image = [UIImage imageNamed:@"img_background_lease"];
    _imgHeader.image = [UIImage imageNamed:@"img_lease_header"];
    _lblRange.textColor    = [UIColor cm_blackColor_666666_1];
    _lblDescLeft.textColor = [UIColor cm_blackColor_666666_1];
    _lblEndTime.textColor  = [UIColor cm_orangeColor_BB7435_1];
    
    _lblDescLeft.font = [UIFont systemFontOfSize:cFontSize_16];
    _lblRange.font    = [UIFont systemFontOfSize:cFontSize_14];
    _lblEndTime.font  = [UIFont systemFontOfSize:cFontSize_14];
    
    _btnPay.layer.masksToBounds = YES;
    _btnPay.layer.cornerRadius = _btnPay.height/2;
    _btnPay.layer.borderWidth = 1.f;
    _btnPay.layer.borderColor = [UIColor cm_orangeColor_BB7435_1].CGColor;
    
    [_btnPay setTintColor:[UIColor cm_orangeColor_BB7435_1]];
    
    [_tableView registerNib:[UINib nibWithNibName:NSStringFromClass([UserLeaseTableViewCell class])        bundle:nil] forCellReuseIdentifier:NSStringFromClass([UserLeaseTableViewCell class])];
    [_tableView registerNib:[UINib nibWithNibName:NSStringFromClass([UserLeaseTicketsTableViewCell class]) bundle:nil] forCellReuseIdentifier:NSStringFromClass([UserLeaseTicketsTableViewCell class])];
    [_tableView registerNib:[UINib nibWithNibName:NSStringFromClass([UserLeaseMoreTableViewCell class])    bundle:nil] forCellReuseIdentifier:NSStringFromClass([UserLeaseMoreTableViewCell class])];
    
    _tableView.estimatedRowHeight = 100;
    _tableView.rowHeight = UITableViewAutomaticDimension;
}

#pragma mark 获取数据

/** 第一页系列列表数据 */
- (void)getFirstLeaseData
{
    _currentLeasePage = 0;
    [self showWaitTips];
    WeakSelf(self)
    [[OrderRequest sharedInstance] getOrderListWithPage:_currentLeasePage
                                            orderStatus:ENUM_ZOrderStateDone
                                              orderType:[NSString stringWithFormat:@"%ld", ENUM_PayPurposeLease]
                                                 length:[NSString stringWithFormat:@"%ld", cListNumber_10]
                                             completion:^(id object, ErrorModel *error) {
                                                 StrongSelf(self)
                                                 [self dismissTips];
                                                 if (error) {
                                                     [self presentFailureTips:error.message];
                                                 }
                                                 else {
                                                     self.isLoadMoreLeases = NO;
                                                     self.noMoreLeases = NO;
                                                     self.arrLeases = [SerialModel mj_objectArrayWithKeyValuesArray:object];
                                                     if (self.arrLeases.count > 0) {
                                                         self.currentLeasePage += 1;
                                                     }
                                                     [self.tableView reloadData];
                                                 }
                                             }];
}

/** 获取更多系列列表数据 */
- (void)getLeaseDataWithPage
{
    [self showWaitTips];
    WeakSelf(self)
    [[OrderRequest sharedInstance] getOrderListWithPage:_currentLeasePage
                                            orderStatus:ENUM_ZOrderStateDone
                                              orderType:[NSString stringWithFormat:@"%ld", ENUM_PayPurposeLease]
                                                 length:[NSString stringWithFormat:@"%ld", cListNumber_10]
                                             completion:^(id object, ErrorModel *error) {
                                                 StrongSelf(self)
                                                 [self dismissTips];
                                                 if (error) {
                                                     [self presentFailureTips:error.message];
                                                 }
                                                 else {
                                                     NSArray *array = [SerialModel mj_objectArrayWithKeyValuesArray:object];
                                                     self.isLoadMoreLeases = YES;
                                                     if (array.count > 0) {
                                                         [self.arrLeases addObjectsFromArray:array];
                                                         self.currentLeasePage += 1;
                                                     }
                                                     else {
                                                         self.noMoreLeases = YES;
                                                     }
                                                     [self.tableView reloadData];
                                                 }
                                             }];
}

/** 兑换券兑换的书集列表 */
- (void)getFirstTicketBooksData
{
    _currentTicketPage = 0;
    [self showWaitTips];
    WeakSelf(self)
    [[OrderRequest sharedInstance] getTicketesWithPage:_currentTicketPage length:cListNumber_10 completion:^(id object, ErrorModel *error) {
        StrongSelf(self)
        [self dismissTips];
        if (error) {
            [self presentFailureTips:error.message];
        }
        else {
            self.isLoadMoreTicket = NO;
            self.noMoreTicket = NO;
            self.arrTicket = [TicketBookModel mj_objectArrayWithKeyValuesArray:object];
            if (self.arrTicket.count > 0) {
                self.currentTicketPage += 1;
            }
            [self.tableView reloadData];
        }
    }];
}

/** 兑换券兑换的书集列表 */
- (void)getTicketBooksDataWithPage
{
    [self showWaitTips];
    WeakSelf(self)
    [[OrderRequest sharedInstance] getTicketesWithPage:_currentTicketPage length:cListNumber_10 completion:^(id object, ErrorModel *error) {
        StrongSelf(self)
        [self dismissTips];
        if (error) {
            [self presentFailureTips:error.message];
        }
        else {
            NSArray *array = [NSDictionary mj_objectArrayWithKeyValuesArray:object];
            self.isLoadMoreTicket = YES;
            if (array.count > 0) {
                [self.arrTicket addObjectsFromArray:array];
                self.currentTicketPage += 1;
            }
            else {
                self.noMoreTicket = YES;
            }
            [self.tableView reloadData];
        }
    }];
}

#pragma mark - UITableViewDataSource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 2;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    NSInteger leaseNum  = _isLoadMoreLeases ? _arrLeases.count : (_arrLeases.count >= 3 ? 3 : _arrLeases.count);
    NSInteger ticketNum = _isLoadMoreTicket ? _arrTicket.count : (_arrTicket.count >= 3 ? 3 : _arrTicket.count);
    if (0 == section) {
        if (_arrLeases.count > 0)
            return _noMoreLeases ? leaseNum : leaseNum + 1;
        else
            return 0;
    }
    else {
        if (_arrTicket.count > 0)
            return _noMoreTicket ? ticketNum : ticketNum + 1;
        else
            return 0;
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UserLeaseMoreTableViewCell *moreCell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([UserLeaseMoreTableViewCell class])];
    if (0 == indexPath.section) {
        if (_isLoadMoreLeases && indexPath.row == _arrLeases.count) {
            return moreCell;
        }
        else if (!_isLoadMoreLeases && _arrLeases.count >= 3 && indexPath.row == 3) {
            return moreCell;
        }
        else if (!_isLoadMoreLeases && _arrLeases.count < 3 && indexPath.row == _arrLeases.count) {
            return moreCell;
        }
        else {
            UserLeaseTableViewCell *leaseCell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([UserLeaseTableViewCell class])];
            leaseCell.delegate = self;
            leaseCell.data = _arrLeases[indexPath.row];
            WeakSelf(self)
            leaseCell.toSerialBooksListView = ^{
                [weakself toSerialBooksListViewWithIndex:indexPath.row];
            };
            return leaseCell;
        }
    }
    else {
        if (_isLoadMoreTicket && indexPath.row == _arrTicket.count) {
            return moreCell;
        }
        else if (!_isLoadMoreTicket && _arrTicket.count >= 3 && indexPath.row == 3) {
            return moreCell;
        }
        else if (!_isLoadMoreTicket && _arrTicket.count < 3 && indexPath.row == _arrTicket.count) {
            return moreCell;
        }
        else {
            UserLeaseTicketsTableViewCell *ticketCell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([UserLeaseTicketsTableViewCell class])];
            ticketCell.data = _arrTicket[indexPath.row];
            WeakSelf(self)
            ticketCell.toTicketsBooksListView = ^{
                [weakself toTicketBooksListViewWithIndex:indexPath.row];
            };
            return ticketCell;
        }
    }
}

#pragma mark - UITableViewDelegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
    if (0 == indexPath.section) {
        if ([cell isKindOfClass:[UserLeaseMoreTableViewCell class]])
            [self getLeaseDataWithPage];
        else
            [self toSerialBooksListViewWithIndex:indexPath.row];
    }
    else {
        if ([cell isKindOfClass:[UserLeaseMoreTableViewCell class]])
            [self getTicketBooksDataWithPage];
        else
            [self toTicketBooksListViewWithIndex:indexPath.row];
    }
}

- (void)toSerialBooksListViewWithIndex:(NSInteger)index
{
    _selectedIndexLease = index;
    UserLeaseDetailVC *leaseDetailVC = [UserLeaseDetailVC new];
    leaseDetailVC.serial = _arrLeases[index];
    [self.navigationController pushViewController:leaseDetailVC animated:YES];
}

- (void)toTicketBooksListViewWithIndex:(NSInteger)index
{
    UserLeaseDetailVC *ticketDetailVC = [UserLeaseDetailVC new];
    ticketDetailVC.ticket = _arrTicket[index];
    [self.navigationController pushViewController:ticketDetailVC animated:YES];
}

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
    lblDesc.text = section == 0 ? LOCALIZATION(@"系列包月") : LOCALIZATION(@"专题包月");
    [header addSubview:lblDesc];
    [lblDesc mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(verLine.mas_centerY);
        make.left.equalTo(verLine.mas_right).offset(10);
    }];
    
    return header;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return cHeaderHeight_44;
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section
{
    UIView *footer = [UIView new];
    
    if (0 == section && _arrLeases.count == 0) {
        _emptyLease = [EmptyView loadFromNibWithFrame:CGRectMake(0, 0, 0, 120)];
        [_emptyLease updateEmptyViewWithType:ENUM_EmptyResultTypeData Image:nil desc:nil subDesc:nil];\
        [footer addSubview:_emptyLease];
        
        _emptyLease.hidden = _arrLeases.count > 0;
    }
    else if (1 == section && _arrTicket.count == 0) {
        // TODO: 为什么 width 是 0 !!!
        _emptyTicket = [EmptyView loadFromNibWithFrame:CGRectMake(0, 0, 0, 120)];
        [_emptyTicket updateEmptyViewWithType:ENUM_EmptyResultTypeData Image:nil desc:nil subDesc:nil];
        [footer addSubview:_emptyTicket];
        _emptyTicket.hidden = _arrTicket.count > 0;
    }
    footer.clipsToBounds = YES;
    return footer;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    if ((0 == section && _arrLeases.count == 0) || (1 == section && _arrTicket.count == 0)) {
        return 190;
    }
    return .5f;
}

#pragma mark - UserLeaseTableViewCellDelegate

- (void)continueLeaseWithSerial:(SerialModel *)serial
{
    UserLeaseSelectedVC *leaseSelectedVC = [UserLeaseSelectedVC new];
    leaseSelectedVC.payPurpose = ENUM_PayPurposeContinue;
    leaseSelectedVC.serial = serial;
    _selectedIndexLease = [_arrLeases indexOfObject:serial];
    [self.navigationController pushViewController:leaseSelectedVC animated:YES];
}

#pragma mark - action

/** 全平台租赁 */
- (IBAction)click_btnPay:(id)sender {
    _rechargeVC = [UVirtualCurrencyRechargeVC loadFromStoryBoard:@"User"];
    _rechargeVC.payPurpose = ENUM_PayPurposeAllLease;
    [self.navigationController pushViewController:_rechargeVC animated:YES];
}

#pragma mark - 属性

- (NSMutableArray *)arrLeases
{
    if (_arrLeases == nil) {
        _arrLeases = [NSMutableArray array];
    }
    return _arrLeases;
}

- (NSMutableArray *)arrTicket
{
    if (_arrTicket == nil) {
        _arrTicket = [NSMutableArray array];
    }
    return _arrTicket;
}

@end
