//
//  UserLeaseSelectedVC.m
//  EasyChineseReading-ios
//
//  Created by 赵春阳 on 2017/11/24.
//  Copyright © 2017年 retech. All rights reserved.
//

#import "UserLeaseSelectedVC.h"

#import "UIVCRSelectPriceCollectionViewCell.h"
#import "UIVCRHeaderRV.h"
#import "UIVCRFooterRV.h"

#import "UserOrderVC.h"
#import "UVirtualCurrencyRechargeVC.h"

static CGFloat const kSpace = 10.f;
static CGFloat const kFooterHeight = 150.f;

#define kSelectedCell NSStringFromClass([UIVCRSelectPriceCollectionViewCell class])
#define kHeaderView   NSStringFromClass([UIVCRHeaderRV class])
#define kFooterView   NSStringFromClass([UIVCRFooterRV class])

@interface UserLeaseSelectedVC () <UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout, UIVCRFooterRVDelegate>

@property (strong, nonatomic) IBOutlet UICollectionView *collectionView;
@property (strong, nonatomic) UICollectionViewFlowLayout *layout;

@property (strong, nonatomic) NSArray *arrPayPrice;    // 充值数额
@property (assign, nonatomic) NSInteger selectedNumb;  // 选择支付数额

@property (strong, nonatomic) PayPriceModel *payPrice; // 支付价格

@end

@implementation UserLeaseSelectedVC

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = LOCALIZATION(@"包月套餐");
    
    [self configRechargeView];
    [self getPayPrice];
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

#pragma mark - 配置 虚拟币充值界面

- (void)configRechargeView
{
    self.collectionView.collectionViewLayout = self.layout;
    
    [_collectionView registerNib:[UINib nibWithNibName:kSelectedCell bundle:nil] forCellWithReuseIdentifier:kSelectedCell];
    [_collectionView registerNib:[UINib nibWithNibName:kHeaderView bundle:nil] forSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:kHeaderView];
    [_collectionView registerNib:[UINib nibWithNibName:kFooterView bundle:nil] forSupplementaryViewOfKind:UICollectionElementKindSectionFooter withReuseIdentifier:kFooterView];
}

#pragma mark - 获取数据

// 支付价格
- (void)getPayPrice
{
    [self showWaitTips];
    WeakSelf(self)
    [[OrderRequest sharedInstance] getPayPriceWithPayPurpose:_payPurpose serialId:_serial.serialId price:0 completion:^(id object, ErrorModel *error) {
        StrongSelf(self)
        [self dismissTips];
        if (error) {
            [self presentFailureTips:error.message];
        }
        else {
            self.arrPayPrice = [PayPriceModel mj_objectArrayWithKeyValuesArray:object];
            [self.collectionView reloadData];
        }
    }];
}

#pragma mark - UICollectionViewDataSource

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return self.arrPayPrice.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    UIVCRSelectPriceCollectionViewCell *priceCell = [collectionView dequeueReusableCellWithReuseIdentifier:kSelectedCell forIndexPath:indexPath];
    priceCell.isSelected = indexPath.row == _selectedNumb;
    priceCell.payPurpose = _payPurpose;
    priceCell.isSelectedPriceView = YES;
    priceCell.data = _arrPayPrice[indexPath.row];
    return priceCell;
}

#pragma mark UICollectionViewDelegate

- (UICollectionReusableView *)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath
{
    if (kind == UICollectionElementKindSectionHeader) {
        UIVCRHeaderRV *headerView = [collectionView dequeueReusableSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:kHeaderView forIndexPath:indexPath];
        headerView.lblDescribe.text = LOCALIZATION(@"请选择租阅套餐");
        return headerView;
    }
    else {
        UIVCRFooterRV *footerView = [collectionView dequeueReusableSupplementaryViewOfKind:UICollectionElementKindSectionFooter withReuseIdentifier:kFooterView forIndexPath:indexPath];
        footerView.delegate = self;
        if (!_payPrice)
            _payPrice = _arrPayPrice.firstObject;
        
        footerView.lblDescribe.hidden = YES;
        return footerView;
    }
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    _selectedNumb = indexPath.row;
    _payPrice = [_arrPayPrice objectAtIndex:indexPath.row];
    [self.collectionView reloadData];
}

#pragma mark - UIVCRFooterRVDelegate

- (void)payWithMoney
{
    if ([UserRequest sharedInstance].user.virtualCurrency >= _payPrice.price) { // 虚拟币充足
        [self showWaitTips];
        WeakSelf(self)
        [[OrderRequest sharedInstance] addSerialOrderWithType:_serial.endTime.length > 0 ? ENUM_PayPurposeContinue : ENUM_PayPurposeLease
                                                      payType:ENUM_PayTypeVirtualCurrency
                                                     serialId:_serial.serialId
                                                   totalmoney:_payPrice.price
                                              finalTotalMoney:_payPrice.price
                                                           id:_payPrice.id
                                                rechargeMoney:0
                                                         name:_serial.serialName
                                                      readDay:_payPrice.day
                                                    domorfore:0
                                                   completion:^(id object, ErrorModel *error) {
                                                       StrongSelf(self)
                                                       if (error) {
                                                           [self dismissTips];
                                                           [self presentFailureTips:error.message];
                                                       }
                                                       else {
                                                           NSDictionary *dic = [object mj_JSONObject];
                                                           [self getResultWithOrderId:dic[@"orderId"]];
                                                       }
                                                   }];
    }
    else {
        [self toRecharge];
    }
}

#pragma mark - handle
/** 去充值支付 */
- (void)toRecharge
{
    UVirtualCurrencyRechargeVC *rechargeVC = [UVirtualCurrencyRechargeVC loadFromStoryBoard:@"User"];
    rechargeVC.payPurpose            = _serial.endTime.length > 0 ? ENUM_PayPurposeContinue : ENUM_PayPurposeLease;
    rechargeVC.order.serialId        = _serial.serialId;
    rechargeVC.order.name            = _serial.serialName;
    rechargeVC.order.totalmoney      = _payPrice.price;
    rechargeVC.order.finalTotalMoney = _payPrice.price;
    rechargeVC.order.rechargeMoney   = _payPrice.price - [UserRequest sharedInstance].user.virtualCurrency;
    rechargeVC.order.priceId         = _payPrice.id;
    rechargeVC.order.readDay         = _payPrice.day;
    [self.navigationController pushViewController:rechargeVC animated:YES];
}

/** 在服务器获取订单信息, 避免本地与服务器数据不同步, 数据出错 */
- (void)getResultWithOrderId:(NSString *)orderId
{
    WeakSelf(self)
    [[OrderRequest sharedInstance] getOrderResultWithOrderId:orderId
                                                        type:_serial.endTime.length > 0 ? ENUM_PayPurposeContinue : ENUM_PayPurposeLease
                                                  completion:^(id object, ErrorModel *error) {
                                                      StrongSelf(self)
                                                      [self dismissTips];
                                                       if (error) {
                                                          [self presentFailureTips:error.message];
                                                      }
                                                      else {
                                                          [self getUserInfo];
                                                          [self presentSuccessTips:LOCALIZATION(@"支付成功")];
                                                          [self fk_postNotification:kNotificationUpdateSerialInfo object:_serial];

                                                          dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.5f * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                                                              UserOrderVC *order = [UserOrderVC new];
                                                              order.isLeaseOrder = YES;
                                                              [self.navigationController pushViewController:order animated:YES];
                                                          });
                                                      }
                                                  }];
}

- (void)getUserInfo
{
    WeakSelf(self)
    [[UserRequest sharedInstance] getUserInfoWithCompletion:^(id object, ErrorModel *error) {
        if (error) 
            [weakself presentFailureTips:error.message];
    }];
}

#pragma mark - 属性

- (UICollectionViewFlowLayout *)layout
{
    if (!_layout) {
        _layout = [[UICollectionViewFlowLayout alloc] init];
        _layout.minimumLineSpacing      = kSpace;
        _layout.minimumInteritemSpacing = kSpace;
        _layout.scrollDirection = UICollectionViewScrollDirectionVertical;
        _layout.sectionInset    = UIEdgeInsetsMake(0, kSpace, kSpace, kSpace);
        _layout.headerReferenceSize = CGSizeMake(Screen_Width, 56);
        _layout.footerReferenceSize = CGSizeMake(Screen_Width, kFooterHeight);
        _layout.itemSize            = CGSizeMake((Screen_Width - kSpace*3)/2, 70);
    }
    return _layout;
}

- (UICollectionView *)collectionView
{
    if (!_collectionView) {
        _collectionView = [[UICollectionView alloc] initWithFrame:self.view.frame collectionViewLayout:self.layout];
        _collectionView.backgroundColor = [UIColor whiteColor];
        _collectionView.delegate = self;
        _collectionView.dataSource = self;
        _collectionView.scrollEnabled = NO;
        [self.view addSubview:_collectionView];
    }
    return _collectionView;
}

- (NSArray *)arrPayPrice
{
    if (_arrPayPrice == nil) {
        _arrPayPrice = [NSArray array];
    }
    return _arrPayPrice;
}

@end
