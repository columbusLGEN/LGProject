//
//  UOrderDetailVC.m
//  EasyChineseReading-ios
//
//  Created by 赵春阳 on 17/8/30.
//  Copyright © 2017年 lee. All rights reserved.
//

#import "UOrderDetailVC.h"

#import "UOrderDetailTableViewCell.h"

#import "ECRBookFormViewController.h"
#import "ECRBookInfoViewController.h"

static CGFloat const kBtnWidth  = 100;
static CGFloat const kBtnHeight = 44;

@interface UOrderDetailVC ()<UITableViewDelegate, UITableViewDataSource, UOrderDetailTableViewCellDelegate>

@property (strong, nonatomic) UITableView *tableView;
@property (strong, nonatomic) UIView *bottomView;

@property (strong, nonatomic) UIButton *btnPay;     // 立即支付
@property (strong, nonatomic) UIButton *btnRight;   // 右侧按键
@property (strong, nonatomic) UIButton *btnLeft;    // 左侧按键

@property (strong, nonatomic) NSMutableArray *arrUpdateBookScore; // 修改订单评分的图书列表及评分

@end

@implementation UOrderDetailVC

- (void)viewDidLoad {
    [super viewDidLoad];

    [self configOrderDetailView];
    [self getOrderDetailWithOrderId:_order.orderId];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - 获取数据

/**
 获取订单详情

 @param orderId 订单id
 */
- (void)getOrderDetailWithOrderId:(NSString *)orderId
{
    [self showWaitTips];
    [[OrderRequest sharedInstance] getOrderInfoWithOrderId:orderId completion:^(id object, ErrorModel *error) {
        [self dismissTips];
        if (error) {
            [self presentFailureTips:error.message];
        }
        else {
            NSArray *array = [OrderModel mj_objectArrayWithKeyValuesArray:object];
            _order = array.firstObject;
            [_tableView reloadData];
            _bottomView.hidden = _order.orderStatus != ENUM_ZOrderStateObligation && _order.orderStatus != ENUM_ZOrderStateScore && _order.orderStatus != ENUM_ZOrderStateCancel;
        }
    }];
}

#pragma mark - 配置界面

- (void)updateSystemLanguage
{
    self.title = LOCALIZATION(@"图书评价");
}

- (void)configOrderDetailView
{
    self.view.backgroundColor = [UIColor whiteColor];
    
    CGFloat tableViewH = [IPhoneVersion deviceVersion] == iphoneX ? self.view.height - cFooterHeight_83 - 20.f : self.view.height - cHeaderHeight_64 - 20.f;
    _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, Screen_Width, tableViewH) style:UITableViewStyleGrouped];
    _tableView.delegate = self;
    _tableView.dataSource = self;
    _tableView.showsVerticalScrollIndicator = NO;
    _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    _tableView.backgroundColor = [UIColor whiteColor];
    
    [_tableView registerNib:[UINib nibWithNibName:NSStringFromClass([UOrderDetailTableViewCell class]) bundle:nil]
     forCellReuseIdentifier:NSStringFromClass([UOrderDetailTableViewCell class])];
    
    // 自适应高度
    _tableView.rowHeight = UITableViewAutomaticDimension;
    _tableView.estimatedRowHeight = 100;
    _tableView.sectionHeaderHeight = 90.f;
    [self.view addSubview:_tableView];
    
    _arrUpdateBookScore = [NSMutableArray array];
    // 图书列表数据
    for (NSInteger i = 0; i < _order.books.count; i ++) {
        BookModel *book = [BookModel mj_objectWithKeyValues:_order.books[i]];
        
        NSDictionary *dic = @{@"userId"         : [NSString stringWithFormat:@"%ld", [UserRequest sharedInstance].user.userId],
                              @"orderDetailId"  : [NSString stringWithFormat:@"%ld", book.orderDetailId],
                              @"bookId"         : [NSString stringWithFormat:@"%ld", book.bookId],
                              @"score"          : [NSString stringWithFormat:@"%ld", book.userScore > 0 ?  book.userScore : 5]};
        [_arrUpdateBookScore addObject:dic];
    }
    // 不是已完成的订单都有可进行的订单操作
    if (_order.orderStatus != ENUM_ZOrderStateDone) {
        [self configBottomView];
    }
}

- (void)configBottomView
{
    _bottomView = [UIView new];
    CGFloat bottomY = [IPhoneVersion deviceVersion] == iphoneX ? self.view.height - cFooterHeight_83 - cHeaderHeight_88 : self.view.height - cHeaderHeight_64*2;
    CGFloat bottomH = [IPhoneVersion deviceVersion] == iphoneX ? cFooterHeight_83 : cHeaderHeight_64;
    _bottomView.frame = CGRectMake(0, bottomY, Screen_Width, bottomH);
    _bottomView.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:_bottomView];
    
    _btnPay = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, kBtnWidth, cHeaderHeight_44)];
    _btnPay.backgroundColor = [UIColor cm_mainColor];
    _btnPay.titleLabel.font = [UIFont systemFontOfSize:cFontSize_16];
    _btnPay.layer.cornerRadius = _btnPay.height/2;
    _btnPay.layer.masksToBounds = YES;
    [_btnPay setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [_btnPay setTitle:LOCALIZATION(@"立即支付") forState:UIControlStateNormal];
    [_btnPay addTarget:self action:@selector(checkOrder) forControlEvents:UIControlEventTouchUpInside];
    [_bottomView addSubview:_btnPay];
    
    _btnRight = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, kBtnWidth, cHeaderHeight_44)];
    _btnRight.backgroundColor = [UIColor whiteColor];
    _btnRight.titleLabel.font = [UIFont systemFontOfSize:cFontSize_16];
    [_btnRight setTitleColor:[UIColor cm_mainColor] forState:UIControlStateNormal];
    _btnRight.layer.borderColor = [UIColor cm_mainColor].CGColor;
    _btnRight.layer.borderWidth = 1.f;
    _btnRight.layer.cornerRadius = _btnRight.height/2;
    _btnRight.layer.masksToBounds = YES;
    [_btnRight setTitle:LOCALIZATION(@"删除") forState:UIControlStateNormal];
    [_btnRight addTarget:self action:@selector(click_btnRightHandle) forControlEvents:UIControlEventTouchUpInside];
    [_bottomView addSubview:_btnRight];
    
    _btnLeft = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, kBtnWidth, cHeaderHeight_44)];
    _btnLeft.backgroundColor = [UIColor whiteColor];
    _btnLeft.titleLabel.font = [UIFont systemFontOfSize:cFontSize_16];
    [_btnLeft setTitleColor:[UIColor cm_mainColor] forState:UIControlStateNormal];
    _btnLeft.layer.borderColor = [UIColor cm_mainColor].CGColor;
    _btnLeft.layer.borderWidth = 1.f;
    _btnLeft.layer.cornerRadius = _btnLeft.height/2;
    _btnLeft.layer.masksToBounds = YES;
    [_btnLeft setTitle:LOCALIZATION(@"取消订单") forState:UIControlStateNormal];
    [_btnLeft addTarget:self action:@selector(cancelOrder) forControlEvents:UIControlEventTouchUpInside];
    [_bottomView addSubview:_btnLeft];
    
    UIView *line = [UIView new];
    line.backgroundColor = [UIColor cm_lineColor_D9D7D7_1];
    [_bottomView addSubview:line];
    
    [_btnPay mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(_bottomView.mas_right).offset(-20);
        make.top.equalTo(_bottomView.mas_top).offset(10);
        make.size.mas_equalTo(CGSizeMake(kBtnWidth, kBtnHeight));
    }];
    
    [_btnRight mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(_bottomView.mas_right).offset(-20);
        make.top.equalTo(_bottomView.mas_top).offset(10);
        make.size.mas_equalTo(CGSizeMake(kBtnWidth, kBtnHeight));
    }];
    
    [_btnLeft mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(_btnPay.mas_left).offset(-20);
        make.top.equalTo(_bottomView.mas_top).offset(10);
        make.size.mas_equalTo(CGSizeMake(kBtnWidth, kBtnHeight));
    }];
    
    [line mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(_bottomView.mas_left);
        make.right.equalTo(_bottomView.mas_right);
        make.top.equalTo(_bottomView.mas_top);
        make.height.mas_equalTo(.5f);
    }];
    // 根据订单状态不同，可以做的操作均不相同
    if (_order.orderStatus == ENUM_ZOrderStateObligation) {
        _btnRight.hidden = YES;
    }
    else if (_order.orderStatus == ENUM_ZOrderStateScore) {
        [_btnRight setTitle:LOCALIZATION(@"评价") forState:UIControlStateNormal];
        _btnLeft.hidden = YES;
        _btnPay.hidden  = YES;
    }
    else {
        _btnLeft.hidden = YES;
        _btnPay.hidden  = YES;
    }
}

#pragma mark - UITableViewDataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return _order.books.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UOrderDetailTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([UOrderDetailTableViewCell class])];
    cell.delegate = self;
    
    BookModel *book = [BookModel mj_objectWithKeyValues:[_order.books objectAtIndex:indexPath.row]];
    cell.canScore = _order.orderStatus == ENUM_ZOrderStateScore;
    cell.data = book;
    return cell;
}

#pragma mark - UITableViewDelegate

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    UIView *headerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, Screen_Width, 70)];
    headerView.backgroundColor = [UIColor whiteColor];
    
    UIView *verLine = [UIView new];
    verLine.backgroundColor = [UIColor cm_mainColor];
    [headerView addSubview:verLine];
    
    [verLine mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(headerView.mas_top).offset(15);
        make.left.equalTo(headerView.mas_left).offset(12);
        make.size.mas_equalTo(CGSizeMake(3, 14));
    }];
    
    UILabel *lblDesc = [UILabel new];
    lblDesc.font = [UIFont systemFontOfSize:16.f];
    lblDesc.text = LOCALIZATION(@"订单详情");
    lblDesc.textColor = [UIColor cm_blackColor_333333_1];
    [headerView addSubview:lblDesc];
    [lblDesc mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(verLine.mas_right).offset(10);
        make.centerY.equalTo(verLine.mas_centerY);
    }];
    
    UILabel *lblOrderId = [UILabel new];
    lblOrderId.font = [UIFont systemFontOfSize:12.f];
    lblOrderId.text = [NSString stringWithFormat:@"%@: %@", LOCALIZATION(@"订单编号"), _order.orderId];
    [headerView addSubview:lblOrderId];
    [lblOrderId mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(verLine.mas_left);
        make.top.equalTo(verLine.mas_bottom).offset(10);
    }];
    
    UILabel *lblTime = [UILabel new];
    lblTime.font = [UIFont systemFontOfSize:12.f];
    lblTime.text = [NSString stringWithFormat:@"%@: %@", LOCALIZATION(@"下单时间"), _order.date];
    [headerView addSubview:lblTime];
    [lblTime mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.equalTo(lblOrderId.mas_leading);
        make.top.equalTo(lblOrderId.mas_bottom).offset(8);
    }];
    
    return headerView;
}

#pragma mark - UOrderDetailTableViewCellDelegate

- (void)updateScoreWithScore:(NSInteger)score book:(BookModel *)book
{
    [_arrUpdateBookScore enumerateObjectsUsingBlock:^(id _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        NSMutableDictionary *dic = [NSMutableDictionary dictionaryWithDictionary:obj];
        if ([dic[@"bookId"] isEqualToString:[NSString stringWithFormat:@"%ld", book.bookId]] && [dic[@"orderDetailId"] isEqualToString:[NSString stringWithFormat:@"%ld", book.orderDetailId]]) {
            dic[@"score"] = [NSString stringWithFormat:@"%ld", score];
            [_arrUpdateBookScore removeObject:obj];
            [_arrUpdateBookScore addObject:dic];
        }
    }];
}

#pragma mark - action

/** 点击右侧按键，根据状态不同，做不同的操作 */
- (void)click_btnRightHandle
{
    if (_order.orderStatus == ENUM_ZOrderStateScore) {
        [self saveEvalute];
    }
    else if (_order.orderStatus == ENUM_ZOrderStateCancel) {
        [self deleteOrder];
    }
}

/** 保存评论 */
- (void)saveEvalute
{
    [self showWaitTips];
    WeakSelf(self)
    [[OrderRequest sharedInstance] addOrderScoreWithOrderId:_order.orderId
                                                     scores:_arrUpdateBookScore
                                              commentFinish:[NSString stringWithFormat:@"1"]
                                                 completion:^(id object, ErrorModel *error) {
                                                     StrongSelf(self)
                                                     if (error) {
                                                         [self dismissTips];
                                                         [self presentFailureTips:error.message];
                                                     }
                                                     else {
                                                         _order.orderStatus = ENUM_ZOrderStateDone;
                                                         [self fk_postNotification:kNotificationUpdateOrderInfo object:_order];
                                                         [self.navigationController popViewControllerAnimated:YES];
                                                     }
    }];
}

/** 删除订单 */
- (void)deleteOrder
{
    ZAlertView *alertDelete = [[ZAlertView alloc] initWithTitle:LOCALIZATION(@"确认删除?") message:nil delegate:self cancelButtonTitle:LOCALIZATION(@"取消") otherButtonTitles:LOCALIZATION(@"确定"), nil];
    WeakSelf(self)
    alertDelete.whenDidSelectOtherButton = ^{
        StrongSelf(self)
        [self showWaitTips];
        WeakSelf(self)
        [[OrderRequest sharedInstance] deleteOrderWithOrderId:_order.orderId completion:^(id object, ErrorModel *error) {
            StrongSelf(self)
            [self dismissTips];
            if (error) {
                [self presentFailureTips:error.message];
            }
            else {
                [self.navigationController popViewControllerAnimated:YES];
                [self fk_postNotification:kNotificationDeleteOrderInfo object:_order];
            }
        }];
    };
    [alertDelete show];
}

/** 取消订单 */
- (void)cancelOrder
{
    [self showWaitTips];
    WeakSelf(self)
    [[OrderRequest sharedInstance] cancelOrderWithOrderId:_order.orderId completion:^(id object, ErrorModel *error) {
        StrongSelf(self)
        [self dismissTips];
        if (error) {
            [self presentFailureTips:error.message];
        }
        else {
            _order.orderStatus = ENUM_ZOrderStateCancel;
    
            _btnLeft.hidden = YES;
            _btnPay.hidden  = YES;
            _btnRight.hidden = NO;
            [_btnRight setTitle:LOCALIZATION(@"删除") forState:UIControlStateNormal];
            [self fk_postNotification:kNotificationUpdateOrderInfo object:_order];
            [self.navigationController popViewControllerAnimated:YES];
        }
    }];
}

#pragma mark - 支付订单
/** 检查支付订单请求中的图书是否已经购买过 */
- (void)checkOrder
{
    WeakSelf(self)
    [[OrderRequest sharedInstance] checkoutPaymentWithOrderId:_order.orderId completion:^(id object, ErrorModel *error) {
        if (error)
            [weakself presentFailureTips:error.message];
        else
            [weakself payOrder:_order];
    }];
}

/**
 支付订单

 @param order 订单详情
 */
- (void)payOrder:(OrderModel *)order
{
    if (_order.books.count > 0) {
        CGFloat price = 0;
        for (NSInteger i = 0; i < _order.books.count; i ++) {
            BookModel *book = [BookModel mj_objectWithKeyValues:_order.books[i]];
            price += book.price;
        }
        
        ECRBookFormViewController *dFormDetail = [[ECRBookFormViewController alloc] init];
        dFormDetail.viewControllerPushWay = ECRBaseControllerPushWayPush;
        NSArray *array = [BookModel mj_objectArrayWithKeyValuesArray:_order.books];
        dFormDetail.tickedArray = array;
        dFormDetail.tickedPrice = price;
        dFormDetail.orderId = _order.orderId;
        
        [self.navigationController pushViewController:dFormDetail animated:YES];
    }
}

#pragma mark - UOrderDetailTableViewCellDelegate

/**
 查看图书详情

 @param book 图书模型
 */
- (void)toBookDetailWithBook:(BookModel *)book
{
    UIStoryboard *board = [UIStoryboard storyboardWithName:@"BookInfo" bundle:nil];
    ECRBookInfoViewController *bivc = [board instantiateViewControllerWithIdentifier:@"ECRBookInfoViewController"];
    bivc.viewControllerPushWay = ECRBaseControllerPushWayPush;
    bivc.bookId = book.bookId;
    [self.navigationController pushViewController:bivc animated:YES];
}

@end
