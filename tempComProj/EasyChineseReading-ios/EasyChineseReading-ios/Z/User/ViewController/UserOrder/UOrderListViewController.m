//
//  UOrderListViewController.m
//  EasyChineseReading-ios
//
//  Created by 赵春阳 on 17/9/2.
//  Copyright © 2017年 lee. All rights reserved.
//

#import "UOrderListViewController.h"

#import "UserOrderTableViewCell.h"
#import "UserOrderHeaderView.h"
//#import "UserOrderFooterView.h"
#import "UserOrderHeaderCollecionCell.h"
#import "UserOrderFooterTableViewCell.h"

#import "UOrderDetailVC.h"
#import "ECRBookFormViewController.h"
#import "ECRBookInfoViewController.h"
#import "ECRDownloadFirstReadSecond.h"

#import "ECRShoppingCarModel.h"

static CGFloat const kFooterHeight = 110.f;
static CGFloat const kCellSpace = 0;

@interface UOrderListViewController ()<
UITableViewDelegate, UITableViewDataSource,
UICollectionViewDelegate, UICollectionViewDataSource,
UICollectionViewDelegateFlowLayout,
UserOrderFooterTableViewCellDelegate,
UserOrderTableViewCellDelegate>

@property (strong, nonatomic) UITableView *tableView;
@property (strong, nonatomic) UICollectionView *collectionView;
@property (strong, nonatomic) UICollectionViewFlowLayout *layout; 

@property (assign, nonatomic) NSInteger currentPage;       // 当前页
@property (assign, nonatomic) NSInteger selectedIndex;     // 选中的订单

@property (strong, nonatomic) EmptyView *emptyView;        // 没有数据

@property (assign, nonatomic) ENUM_ZOrderState orderState; // 订单状态

@property (strong, nonatomic) NSMutableArray *arrData;     // 数据
@property (strong, nonatomic) NSArray *arrHandles;         // 操作

@property (assign, nonatomic) BOOL notLoadFooter;

@end

@implementation UOrderListViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    self.view.backgroundColor = [UIColor whiteColor];
    
    _orderState = ENUM_ZOrderStateAll;
    [self configCollectionView];
    [self configTableView];
    [self configMJRefresh];
    [self.view addSubview:self.emptyView];
    [self showWaitTips];
    [self getFirstPageOrderData];
    
    WeakSelf(self)
    // 更新订单信息
    [self fk_observeNotifcation:kNotificationUpdateOrderInfo usingBlock:^(NSNotification *note) {
        [weakself getFirstPageOrderData];
    }];
    // 删除订单
    [self fk_observeNotifcation:kNotificationDeleteOrderInfo usingBlock:^(NSNotification *note) {
        [weakself getFirstPageOrderData];
    }];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - 配置界面

- (void)configCollectionView
{
    _collectionView = [[UICollectionView alloc] initWithFrame:CGRectMake(0, 0, Screen_Width, kFooterHeight) collectionViewLayout:self.layout];
    _collectionView.delegate = self;
    _collectionView.dataSource = self;
    _collectionView.scrollEnabled = NO;
    _collectionView.showsVerticalScrollIndicator = NO;
    _collectionView.showsHorizontalScrollIndicator = NO;
    _collectionView.backgroundColor = [UIColor whiteColor];

    [_collectionView registerNib:[UINib nibWithNibName:NSStringFromClass([UserOrderHeaderCollecionCell class]) bundle:nil] forCellWithReuseIdentifier:NSStringFromClass([UserOrderHeaderCollecionCell class])];

    [self.view addSubview:_collectionView];
}

- (void)configTableView
{
    _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, kFooterHeight, Screen_Width, Screen_Height - cHeaderHeight_44 - cHeaderHeight_64 - kFooterHeight) style:UITableViewStyleGrouped];
    _tableView.delegate = self;
    _tableView.dataSource = self;
    _tableView.backgroundColor = [UIColor whiteColor];
    _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    _tableView.showsVerticalScrollIndicator = NO;
    _tableView.estimatedRowHeight = 44;
    _tableView.rowHeight = UITableViewAutomaticDimension;
    
    [_tableView registerNib:[UINib nibWithNibName:NSStringFromClass([UserOrderTableViewCell class]) bundle:nil] forCellReuseIdentifier:NSStringFromClass([UserOrderTableViewCell class])];
    [_tableView registerNib:[UINib nibWithNibName:NSStringFromClass([UserOrderFooterTableViewCell class]) bundle:nil] forCellReuseIdentifier:NSStringFromClass([UserOrderFooterTableViewCell class])];
    
    [self.view addSubview:_tableView];
}

- (void)configMJRefresh
{
    WeakSelf(self)
    _tableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        [weakself getFirstPageOrderData];
    }];
    _tableView.mj_footer = [MJRefreshBackNormalFooter footerWithRefreshingBlock:^{
        [weakself getOrdersDataWithPage:_currentPage];
    }];
}

#pragma mark - 获取数据

/** 获取第一页订单数据 */
- (void)getFirstPageOrderData
{
    _currentPage = 0;
    [_collectionView reloadData];
    [self showWaitTips];
    WeakSelf(self)
    [[OrderRequest sharedInstance] getOrderListWithPage:_currentPage
                                            orderStatus:_orderState
                                              orderType:[NSString stringWithFormat:@"%ld", ENUM_PayPurposeBuy]
                                                 length:[NSString stringWithFormat:@"%ld", cListNumber_10]
                                             completion:^(id object, ErrorModel *error) {
                                                 StrongSelf(self)
                                                 [self.tableView.mj_header endRefreshing];
                                                 [self dismissTips];
                                                 if (error) {
                                                     [self presentFailureTips:error.message];
                                                 }
                                                 else {
                                                     NSMutableArray *array = [OrderModel mj_objectArrayWithKeyValuesArray:object];
                                                     NSMutableArray *arrDel = [NSMutableArray arrayWithCapacity:0];
                                                     // 防止崩溃, 如果没有书, 删除该订单
                                                     for (OrderModel *order in array) {
                                                         if (order.books.count == 0) {
                                                             [arrDel addObject:order];
                                                         }
                                                     }
                                                     [array removeObjectsInArray:arrDel];
                                                     self.arrData = array;
                                                     if (self.arrData.count > 0) {
                                                         self.currentPage += 1;
                                                     }
                                                     self.emptyView.hidden = self.arrData.count > 0;
                                                     [self.tableView scrollsToTop];
                                                     [self.tableView reloadData];
                                                 }
                                             }];
}

/**
 加载更多数据

 @param page 页数
 */
- (void)getOrdersDataWithPage:(NSInteger)page
{
    WeakSelf(self)
    [[OrderRequest sharedInstance] getOrderListWithPage:page
                                            orderStatus:_orderState
                                              orderType:[NSString stringWithFormat:@"%ld", ENUM_PayPurposeBuy]
                                                 length:[NSString stringWithFormat:@"%ld", cListNumber_10]
                                             completion:^(id object, ErrorModel *error) {
                                                 StrongSelf(self)
                                                 [self.tableView.mj_footer endRefreshing];
                                                 if (error) {
                                                     [self presentFailureTips:error.message];
                                                 }
                                                 else {
                                                     NSMutableArray *array = [OrderModel mj_objectArrayWithKeyValuesArray:object];
                                                     NSMutableArray *arrDel = [NSMutableArray arrayWithCapacity:0];
                                                     // 防止崩溃, 如果没有书,删除该订单
                                                     for (OrderModel *order in array) {
                                                         if (order.books.count == 0) {
                                                             [arrDel addObject:order];
                                                         }
                                                     }
                                                     [array removeObjectsInArray:arrDel];
                                                     if (array.count > 0) {
                                                         self.currentPage += 1;
                                                         self.emptyView.hidden = YES;
                                                         [self.arrData addObjectsFromArray:array];
                                                         [self.tableView reloadData];
                                                     }
                                                 }
                                             }];
}

#pragma mark - UICollectionDataSource

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return self.arrHandles.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    UserOrderHeaderCollecionCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:NSStringFromClass([UserOrderHeaderCollecionCell class]) forIndexPath:indexPath];
    cell.orderState = _orderState;
    cell.data = _arrHandles[indexPath.row];
    return cell;
}

#pragma mark - UICollectionDelegate

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    NSDictionary *dic = _arrHandles[indexPath.row];
    NSNumber *orderState = dic[@"orderState"];
    _orderState = orderState.integerValue;
    [self getFirstPageOrderData];
}

#pragma mark - UITableViewDataSource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return _arrData.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    OrderModel *order = _arrData[section];
    return order.showAllBook ? order.books.count + 1 : 2;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    OrderModel *order = _arrData[indexPath.section];
    if ((order.showAllBook && indexPath.row == order.books.count) || (!order.showAllBook && 1 == indexPath.row)) {
        UserOrderFooterTableViewCell *footer = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([UserOrderFooterTableViewCell class])];
        footer.delegate = self;
        footer.data = order;
        return footer;
    }
    else {
        UserOrderTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([UserOrderTableViewCell class])];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.delegate = self;
        cell.index = indexPath.row;
        cell.data = order;
        return cell;
    }
}

#pragma mark - UITableViewDelegate

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    OrderModel *order = _arrData[section];
    UIView *header = [[UIView alloc] initWithFrame:CGRectMake(0, 0, Screen_Width, cHeaderHeight_54)];
    UserOrderHeaderView *headerView = [UserOrderHeaderView loadFromNibWithFrame:header.bounds];
    headerView.data = order;
    [header addSubview:headerView];
    return header;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return cHeaderHeight_54;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return 1.f;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [self.tableView deselectRowAtIndexPath:indexPath animated:YES];
    UOrderDetailVC *detail = [[UOrderDetailVC alloc] init];
    detail.order = _arrData[indexPath.section];
    _selectedIndex = indexPath.section;
    [self.navigationController pushViewController:detail animated:YES];
}

#pragma mark - UOrderFooterTableViewCellDelegate
#pragma mark 删除订单
- (void)deleteOrderWithOrder:(OrderModel *)order
{
    ZAlertView *alertDelete = [[ZAlertView alloc] initWithTitle:LOCALIZATION(@"确认删除?") message:nil delegate:self cancelButtonTitle:LOCALIZATION(@"取消") otherButtonTitles:LOCALIZATION(@"确定"), nil];
    WeakSelf(self)
    alertDelete.whenDidSelectOtherButton = ^{
        [[OrderRequest sharedInstance] deleteOrderWithOrderId:order.orderId completion:^(id object, ErrorModel *error) {
            StrongSelf(self)
            if (error) {
                [self presentFailureTips:error.message];
            }
            else {
                NSInteger index = [self.arrData indexOfObject:order];
                NSIndexSet *set = [NSIndexSet indexSetWithIndex:index];
                NSMutableArray *array = [NSMutableArray arrayWithArray:self.arrData];
                [array removeObjectAtIndex:index];
                self.arrData = array;
                [self.tableView deleteSections:set withRowAnimation:UITableViewRowAnimationNone];
            }
        }];
    };
    [alertDelete show];
}

#pragma mark 取消订单
- (void)cancelOrderWithOrder:(OrderModel *)order
{
    _selectedIndex = [_arrData indexOfObject:order];
    WeakSelf(self)
    [[OrderRequest sharedInstance] cancelOrderWithOrderId:order.orderId completion:^(id object, ErrorModel *error) {
        StrongSelf(self)
        if (error) {
            [self presentFailureTips:error.message];
        }
        else {
            order.orderStatus = ENUM_ZOrderStateCancel;
            NSInteger index = [self.arrData indexOfObject:order];
            NSIndexSet *set = [NSIndexSet indexSetWithIndex:index];
            [self.tableView reloadSections:set withRowAnimation:UITableViewRowAnimationNone];
        }
    }];
}

#pragma mark 支付订单

/**
 检查订单中的书籍是否已经购买过

 @param order 订单详情
 */
- (void)payOrderWithOrder:(OrderModel *)order
{
    WeakSelf(self)
    [[OrderRequest sharedInstance] checkoutPaymentWithOrderId:order.orderId completion:^(id object, ErrorModel *error) {
        if (error)
            [weakself presentFailureTips:error.message];
        else
            [weakself payOrder:order];
    }];
}

/**
 支付订单

 @param order 订单详情
 */
- (void)payOrder:(OrderModel *)order
{
    if (order.books.count > 0) {
        CGFloat price = 0;
        NSMutableArray *array = [NSMutableArray array];
        for (NSInteger i = 0; i < order.books.count; i ++) {
            BookModel *book = [BookModel mj_objectWithKeyValues:order.books[i]];
            NSDictionary *dic = [book createDictionayFromModelProperties];
            ECRShoppingCarModel *shopModel = [ECRShoppingCarModel mj_objectWithKeyValues:dic];
            price += book.price;
            [array addObject:shopModel];
        }
        _selectedIndex = [_arrData indexOfObject:order];
        ECRBookFormViewController *dFormDetail = [[ECRBookFormViewController alloc] init];
        dFormDetail.viewControllerPushWay = ECRBaseControllerPushWayPush;
        dFormDetail.tickedArray = array;
        dFormDetail.tickedPrice = price;
        dFormDetail.orderId = order.orderId;
        [self.navigationController pushViewController:dFormDetail animated:YES];
    }
}

#pragma mark 评价订单
- (void)evaluateWithOrder:(OrderModel *)order
{
    UOrderDetailVC *detail = [[UOrderDetailVC alloc] init];
    detail.order = order;
    _selectedIndex = [_arrData indexOfObject:order];
    [self.navigationController pushViewController:detail animated:YES];
}

#pragma mark 加载更多↓ - 展示订单全部书籍
- (void)showAllBooksWithOrder:(OrderModel *)order
{
    NSInteger index = [_arrData indexOfObject:order];
    order.showAllBook = YES;
    NSIndexSet *set = [NSIndexSet indexSetWithIndex:index];
    [_tableView reloadSections:set withRowAnimation:UITableViewRowAnimationFade];
}

#pragma mark - UserOrderTableViewCellDelegate
#pragma mark 进入详情
- (void)toBookDetailWithBook:(BookModel *)book
{
    UIStoryboard *board = [UIStoryboard storyboardWithName:@"BookInfo" bundle:nil];
    ECRBookInfoViewController *bivc = [board instantiateViewControllerWithIdentifier:@"ECRBookInfoViewController"];
    bivc.viewControllerPushWay = ECRBaseControllerPushWayPush;
    bivc.bookId = book.bookId;
    [self.navigationController pushViewController:bivc animated:YES];
}
#pragma mark 立即阅读
- (void)readBookWithBook:(BookModel *)book
{
    WeakSelf(self)
    [ECRDownloadFirstReadSecond downloadFirstReadSecondWithvc:self book:book success:^{
        
    } failure:^(NSError *error) {
        [weakself presentFailureTips:error.domain];
    }];
}

#pragma mark - 属性

- (NSArray *)arrHandles
{
    if (_arrHandles == nil) {
        _arrHandles = @[@{@"handle": LOCALIZATION(@"全部"),  @"icon": @"icon_order_all_unselect"        , @"selected": @"icon_order_all"       , @"orderState": @(ENUM_ZOrderStateAll)},
                        @{@"handle": LOCALIZATION(@"待付款"), @"icon": @"icon_order_obligation_unselect", @"selected": @"icon_order_obligation", @"orderState": @(ENUM_ZOrderStateObligation)},
                        @{@"handle": LOCALIZATION(@"待评价"), @"icon": @"icon_order_score_unselect"     , @"selected": @"icon_order_score"     , @"orderState": @(ENUM_ZOrderStateScore)},
                        @{@"handle": LOCALIZATION(@"已完成"), @"icon": @"icon_order_done_unselect"      , @"selected": @"icon_order_done"      , @"orderState": @(ENUM_ZOrderStateDone)},
                        @{@"handle": LOCALIZATION(@"已取消"), @"icon": @"icon_order_cancel_unselect"    , @"selected": @"icon_order_cancel"    , @"orderState": @(ENUM_ZOrderStateCancel)}
                        ];
    }
    return _arrHandles;
}

- (EmptyView *)emptyView
{
    if (_emptyView == nil) {
        _emptyView = [EmptyView loadFromNibWithFrame:CGRectMake(0, kFooterHeight, Screen_Width, Screen_Height - kFooterHeight - cHeaderHeight_44)];
        [_emptyView updateEmptyViewWithType:ENUM_EmptyResultTypeUnknow Image:nil desc:LOCALIZATION(@"没有相关订单") subDesc:nil];
    }
    return _emptyView;
}
- (UICollectionViewFlowLayout *)layout
{
    if (_layout == nil) {
        _layout = [[UICollectionViewFlowLayout alloc] init];
        
        _layout.minimumLineSpacing      = kCellSpace;
        _layout.minimumInteritemSpacing = kCellSpace;
        _layout.sectionInset            = UIEdgeInsetsMake(kCellSpace, kCellSpace, kCellSpace, kCellSpace);
        _layout.itemSize                = CGSizeMake((Screen_Width - kCellSpace*(self.arrHandles.count + 1))/self.arrHandles.count, kFooterHeight);
    }
    return _layout;
}

@end
