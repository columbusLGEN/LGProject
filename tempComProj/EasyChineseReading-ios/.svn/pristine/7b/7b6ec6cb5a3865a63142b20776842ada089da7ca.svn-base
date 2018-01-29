//
//  UIVCRechargeVC.m
//  EasyChineseReading-ios
//
//  Created by 赵春阳 on 17/9/7.
//  Copyright © 2017年 lee. All rights reserved.
//

#import "UVirtualCurrencyRechargeVC.h"

#import <AlipaySDK/AlipaySDK.h>                // ali 支付
#import "ZAppStore.h"                          // 内购

#import "UIVCRPayTypeCollectionViewCell.h"     // 支付方式
#import "UIVCRSelectPriceCollectionViewCell.h" // 选择价格
#import "UVCRShowPriceCollectionViewCell.h"    // 支付价格
#import "UIVCRHeaderRV.h"
#import "UIVCRFooterRV.h"
#import "ECRLocationManager.h"
#import "PaySuccessViewController.h"

static CGFloat const kSpace = 10.f;                         // cell间隙
static CGFloat const kFooterHeight = 160.f;                 // 底部支付模块的高度
static CGFloat const kSelectedPriceCellHeight = 80.f;       // 选择价格的高度
static CGFloat const kSelectedPayTypeCellHeight = 60.f;     // 选择支付方式的高度
static NSInteger kMaxRequestNumber = 10;                    // 网络请求最大的循环次数
static NSString * const appScheme = @"EasyChineseReading";  // ali 支付识别标识

#define kHeaderView    NSStringFromClass([UIVCRHeaderRV class])
#define kFooterView    NSStringFromClass([UIVCRFooterRV class])
#define kPayTypeCell   NSStringFromClass([UIVCRPayTypeCollectionViewCell class])
#define kSelecteCell   NSStringFromClass([UIVCRSelectPriceCollectionViewCell class])
#define kShowPriceCell NSStringFromClass([UVCRShowPriceCollectionViewCell class])

@interface UVirtualCurrencyRechargeVC ()<UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout, UIVCRFooterRVDelegate>

@property (strong, nonatomic) UICollectionView *collectionView;
@property (strong, nonatomic) UICollectionViewFlowLayout *layout;

@property (strong, nonatomic) UIVCRFooterRV *footerView;        // 支付

@property (strong, nonatomic) NSMutableArray *arrPayType;       // 充值方式
@property (strong, nonatomic) NSMutableArray *arrPayPriceApple; // 苹果充值数额
@property (strong, nonatomic) NSMutableArray *arrPayPriceAli;   // 阿里充值数额

@property (assign, nonatomic) NSInteger selectedType;     // 选择支付类别
@property (assign, nonatomic) NSInteger selectedNumb;     // 选择支付数额
@property (assign, nonatomic) NSInteger requestNumber;    // 网络请求失败或需要重新请求的剩余请求的次数

@property (assign, nonatomic) CGFloat price;              // 选中的需支付的价格
@property (strong, nonatomic) PayPriceModel *priceModel;  // 选中需支付的价格

@property (assign, nonatomic) BOOL showSelectePayType;    // 展示选择方式
@property (assign, nonatomic) BOOL foreign;               // 国外

@end

@implementation UVirtualCurrencyRechargeVC

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = _payPurpose == ENUM_PayPurposeAllLease ? LOCALIZATION(@"支付") : LOCALIZATION(@"虚拟币充值");
    _selectedType = ENUM_PayTypeApplePay;
    _requestNumber = kMaxRequestNumber;
    _foreign = ![ECRLocationManager currentLocationIsChina];
    [self showWaitTips];
    [self getPayType];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:NO animated:YES];
}

#pragma mark - 获取支付类型
- (void)getPayType {
    self.arrPayType = [NSMutableArray array];
    WeakSelf(self)
    [[OrderRequest sharedInstance] getPayTypeCompletion:^(id object, ErrorModel *error) {
        StrongSelf(self)
        if (error) {
            [self presentFailureTips:error.message];
        }
        else {
            NSArray *array = [PayTypeModel mj_objectArrayWithKeyValuesArray:object];
            // 如果没有设置支付方式, 直接显示苹果支付
            if (!array || array.count == 0) {
                self.showSelectePayType = NO;
                [self getPayProportion];
            }
            else {
                for (NSInteger i = 0; i < array.count; i ++) {
                    PayTypeModel *payType = array[i];
                    if ([payType.isdisplay isEqualToString:@"1"])
                        [self.arrPayType addObject:payType];
                }
                // 没有更多的支付方式, 默认内购方式
                self.showSelectePayType = self.arrPayType.count > 1;
                [self getPayProportion];
            }
        }
    }];
}

#pragma mark 获取支付/积分比例
- (void)getPayProportion
{
    WeakSelf(self)
    [ECRDataHandler selectCoinrateSuccess:^(id object) {
        StrongSelf(self)
        NSArray *arr = object;
        if (arr != nil && arr.count > 0) {
            ECRVirScoreRateModel *model = [ECRVirScoreRateModel mj_objectWithKeyValues:arr[0]];
            self.scoreRate = model;
            [self getPayPrice];
        }
    } failure:^(NSString *msg) { } commenFailure:^(NSError *error) { }];
}

#pragma mark - 获取支付/充值价格列表
- (void)getPayPrice
{
    self.arrPayPriceAli   = [NSMutableArray array];
    self.arrPayPriceApple = [NSMutableArray array];
    WeakSelf(self)
    // 支付价格
    CGFloat rechargePrice = _order.rechargeMoney > 0 ? _order.rechargeMoney : (_order.totalmoney - [UserRequest sharedInstance].user.virtualCurrency);
    // 支付的类别
    ENUM_PayPurpose purpose = _payPurpose == ENUM_PayPurposeAllLease ? ENUM_PayPurposeAllLease : ENUM_PayPurposeRecharge;
    [[OrderRequest sharedInstance] getPayPriceWithPayPurpose:purpose serialId:0 price:rechargePrice completion:^(id object, ErrorModel *error) {
        StrongSelf(self)
        [self dismissTips];
        if (error) {
            [self presentFailureTips:error.message];
        }
        else {
            NSArray *array = [NSDictionary mj_objectArrayWithKeyValuesArray:object];
            if (array.count == 0) return;
            
            NSDictionary *dic = array.firstObject;
            if (!dic[@"alipay"]) return;
            if (!dic[@"applepay"]) return;
            
            _arrPayPriceAli   = [PayPriceModel mj_objectArrayWithKeyValuesArray:dic[@"alipay"]];
            _arrPayPriceApple = [PayPriceModel mj_objectArrayWithKeyValuesArray:dic[@"applepay"]];
            // 包月系列或者购买图书的情况下需要充值时，计算差价
            if (_payPurpose != ENUM_PayPurposeAllLease &&
                _payPurpose != ENUM_PayPurposeRecharge &&
                (_order.rechargeMoney > 0 || _order.totalmoney - [UserRequest sharedInstance].user.virtualCurrency > 0)) {
                // 如果没有传 rechargeMoney, 那么需要充值的虚拟币等于剩余需要支付的虚拟币减去拥有的虚拟币
                CGFloat customVirtualCoinSum = _order.finalTotalMoney - [UserRequest sharedInstance].user.virtualCurrency;
                BOOL hasRechargeMoney = _order.rechargeMoney > 0;
                PayPriceModel *price = [PayPriceModel new];
                price.id = 0;
                price.presenterSum = 0;
                price.virtualcoinSum = hasRechargeMoney ? _order.rechargeMoney : customVirtualCoinSum;
                // 计算国内外的不同差价
                if (_foreign)
                    price.foreignPrice = hasRechargeMoney ? _order.rechargeMoney*_scoreRate.foreignrate.floatValue : customVirtualCoinSum*_scoreRate.foreignrate.floatValue;
                else
                    price.domesticPrice = hasRechargeMoney ? _order.rechargeMoney*_scoreRate.domesticrate.floatValue : customVirtualCoinSum*_scoreRate.domesticrate.floatValue;
                // 判断差价是否与已有的充值价格重复
                BOOL hasSamePrice = NO;
                for (PayPriceModel *p in _arrPayPriceAli) { // 检查是否有与需要支付相等的价格
                    if ([[self floatToNumber:p.domesticPrice] isEqualToNumber:[self floatToNumber:price.domesticPrice]]) { // 有相等的价格
                        hasSamePrice = YES;
                        break;
                    }
                }
                // 如果没有与需要充值相等的价格, 且充值额度大于0.01(人民币)
                if (hasSamePrice == NO && (price.domesticPrice + 0.001 >= 0.01)) {
                    // 内购不能使用补差价的方式
                    [_arrPayPriceAli insertObject:price atIndex:0];
                }
            }
            [self.collectionView reloadData];
        }
    }];
}

#pragma mark - UICollectionViewDataSource

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
    return _payPurpose == ENUM_PayPurposeRecharge || _payPurpose == ENUM_PayPurposeAllLease ? 1 + _showSelectePayType : 2 + _showSelectePayType;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    // 显示选择支付方式
    if (_showSelectePayType) {
        if (_payPurpose == ENUM_PayPurposeRecharge || _payPurpose == ENUM_PayPurposeAllLease) {  // 没有顶部订单价格信息
            if (0 == section)
                return self.arrPayType.count;
            else
                return _selectedType == ENUM_PayTypeApplePay ? _arrPayPriceApple.count : _arrPayPriceAli.count;
        }
        // 有顶部价格订单信息
        else {
            if (0 == section)
                return 2;
            else if (1 == section)
                return self.arrPayType.count;
            else
                return _selectedType == ENUM_PayTypeApplePay ? _arrPayPriceApple.count : _arrPayPriceAli.count;
        }
    }
    // 不显示选择支付方式
    else {
        if ((_payPurpose == ENUM_PayPurposeRecharge || _payPurpose == ENUM_PayPurposeAllLease) && 0 == section)
            return _arrPayPriceApple.count;
        else
            return _selectedType == ENUM_PayTypeApplePay ? _arrPayPriceApple.count : _arrPayPriceAli.count;
    }
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    
    UVCRShowPriceCollectionViewCell *orderPriceCell = [collectionView dequeueReusableCellWithReuseIdentifier:kShowPriceCell forIndexPath:indexPath];
    UIVCRPayTypeCollectionViewCell *payTypeCell     = [collectionView dequeueReusableCellWithReuseIdentifier:kPayTypeCell forIndexPath:indexPath];
    UIVCRSelectPriceCollectionViewCell *priceCell   = [collectionView dequeueReusableCellWithReuseIdentifier:kSelecteCell forIndexPath:indexPath];
    orderPriceCell.index = indexPath.row;
    priceCell.foreign = _foreign;
    // 有选择支付方式
    if (_showSelectePayType) {
        // 充值或全平台(使用现金)
        if (_payPurpose == ENUM_PayPurposeRecharge || _payPurpose == ENUM_PayPurposeAllLease) {
            if (0 == indexPath.section) {
                payTypeCell.isSelected = indexPath.row == _selectedType - 1;
                payTypeCell.data = _arrPayType[indexPath.row];
                return payTypeCell;
            }
            else {
                priceCell.isSelected = indexPath.row == _selectedNumb;
                priceCell.payPurpose = _payPurpose;
                priceCell.data = _selectedType == ENUM_PayTypeApplePay ? _arrPayPriceApple[indexPath.row] : _arrPayPriceAli[indexPath.row];
                return priceCell;
            }
        }
        else {
            if (0 == indexPath.section) {
                orderPriceCell.data = _order;
                return orderPriceCell;
            }
            else if (1 == indexPath.section) {
                payTypeCell.isSelected = indexPath.row == _selectedType - 1;
                payTypeCell.data = _arrPayType[indexPath.row];
                return payTypeCell;
            }
            else {
                priceCell.isSelected = indexPath.row == _selectedNumb;
                priceCell.payPurpose = _payPurpose;
                priceCell.data = _selectedType == ENUM_PayTypeApplePay ? _arrPayPriceApple[indexPath.row] : _arrPayPriceAli[indexPath.row];
                return priceCell;
            }
        }
    }
    // 没有选择支付方式
    else {
        if ((_payPurpose == ENUM_PayPurposeRecharge || _payPurpose == ENUM_PayPurposeAllLease) && 0 == indexPath.section) {
            orderPriceCell.data = _order;
            return orderPriceCell;
        }
        else {
            priceCell.isSelected = indexPath.row == _selectedNumb;
            priceCell.payPurpose = _payPurpose;
            priceCell.data = _selectedType == ENUM_PayTypeApplePay ? _arrPayPriceApple[indexPath.row] : _arrPayPriceAli[indexPath.row];
            return priceCell;
        }
    }
}

#pragma mark UICollectionViewDelegate

- (UICollectionReusableView *)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath
{
    if (kind == UICollectionElementKindSectionHeader) {
        UIVCRHeaderRV *headerView = [collectionView dequeueReusableSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:kHeaderView forIndexPath:indexPath];
        if (_payPurpose == ENUM_PayPurposeRecharge || _payPurpose == ENUM_PayPurposeAllLease) {
            if (0 == indexPath.section && _showSelectePayType)
                headerView.lblDescribe.text = _payPurpose == ENUM_PayPurposeAllLease ? LOCALIZATION(@"请选择支付方式") : LOCALIZATION(@"请选择充值方式");
            else
                headerView.lblDescribe.text = _payPurpose == ENUM_PayPurposeAllLease ? LOCALIZATION(@"请选择租阅套餐") : LOCALIZATION(@"请选择充值金额");
        }
        else {
            if (0 == indexPath.section) {
                headerView.showPrice = YES;
                headerView.data = [NSString stringWithFormat:@"%.2f", _order.finalTotalMoney];
            }
            else if (1 == indexPath.section && _showSelectePayType)
                headerView.lblDescribe.text = _payPurpose == ENUM_PayPurposeAllLease ? LOCALIZATION(@"请选择支付方式") : LOCALIZATION(@"请选择充值方式");
            else
                headerView.lblDescribe.text = _payPurpose == ENUM_PayPurposeAllLease ? LOCALIZATION(@"请选择租阅套餐") : LOCALIZATION(@"请选择充值金额");
        }
        return headerView;
    }
    else {
        _footerView = [collectionView dequeueReusableSupplementaryViewOfKind:UICollectionElementKindSectionFooter withReuseIdentifier:kFooterView forIndexPath:indexPath];
        _footerView.delegate = self;
        _footerView.foreign = _foreign;
        _footerView.scoreRate = _scoreRate;
        if (_price == 0 && !_priceModel) {
            _priceModel = _selectedType == ENUM_PayTypeApplePay ? _arrPayPriceApple.firstObject : _arrPayPriceAli.firstObject;
            _price = !_foreign ? _priceModel.domesticPrice : _priceModel.foreignPrice;
        }
        _footerView.payPurpose = _payPurpose;
        _footerView.payNum = _price;
        return _footerView;
    }
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    CGFloat width  = 0;
    CGFloat height = 0;
    
    CGFloat widthPayType = Screen_Width - kSpace*2;
    CGFloat widthPrice = isPad ? (Screen_Width - kSpace*4)/3 : (Screen_Width - kSpace*2)/3;
    
    if (_showSelectePayType) {
        if (_payPurpose == ENUM_PayPurposeRecharge || _payPurpose == ENUM_PayPurposeAllLease) {
            width  = 1 == indexPath.section ? widthPrice : widthPayType;
            height = 1 == indexPath.section && _showSelectePayType ? kSelectedPriceCellHeight : kSelectedPayTypeCellHeight;
        }
        else {
            width  = 0 == indexPath.section ? widthPayType : widthPrice;
            height = 2 == indexPath.section && _showSelectePayType ? kSelectedPriceCellHeight : kSelectedPayTypeCellHeight;
        }
    }
    else {
        if (_payPurpose == ENUM_PayPurposeRecharge || _payPurpose == ENUM_PayPurposeAllLease) {
            width  = widthPrice;
            height = kSelectedPriceCellHeight;
        }
        else {
            width  = 1 == indexPath.section ? widthPrice : widthPayType;
            height = 1 == indexPath.section && _showSelectePayType ? kSelectedPriceCellHeight : kSelectedPayTypeCellHeight;
        }
    }
    return CGSizeMake(width, height);
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout referenceSizeForHeaderInSection:(NSInteger)section
{
    return CGSizeMake(Screen_Width, 56);
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout referenceSizeForFooterInSection:(NSInteger)section
{
    CGFloat height = 0;
    if (_showSelectePayType) {
        if (_payPurpose == ENUM_PayPurposeRecharge || _payPurpose == ENUM_PayPurposeAllLease)
            height = 1 == section ? kFooterHeight : .5f;
        else
            height = 2 == section ? kFooterHeight : .5f;
    }
    else {
        if (_payPurpose == ENUM_PayPurposeRecharge || _payPurpose == ENUM_PayPurposeAllLease)
            height = kFooterHeight;
        else
            height = 1 == section ? kFooterHeight : .5f;
    }
    return CGSizeMake(Screen_Width, height);
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    _selectedNumb = 0;
    if (_payPurpose == ENUM_PayPurposeRecharge || _payPurpose == ENUM_PayPurposeAllLease) {
        if (0 == indexPath.section && _showSelectePayType)
            _selectedType = indexPath.row + 1;
        else
            _selectedNumb = indexPath.row;
    }
    else {
        if (1 == indexPath.section && _showSelectePayType)
            _selectedType = indexPath.row + 1;
        else
            _selectedNumb = indexPath.row;
    }
    if (_selectedType == ENUM_PayTypeApplePay) {
        if (_arrPayPriceApple.count > 0) {
            _priceModel = [_arrPayPriceApple objectAtIndex:_selectedNumb];
            _price = !_foreign ? _priceModel.domesticPrice : _priceModel.foreignPrice;
        }
        else {
            _priceModel = nil;
            _price = 0;
        }
    }
    else {
        if (_arrPayPriceAli.count > 0) {
            _priceModel = [_arrPayPriceAli objectAtIndex:_selectedNumb];
            _price = !_foreign ? _priceModel.domesticPrice : _priceModel.foreignPrice;
        }
        else {
            _priceModel = nil;
            _price = 0;
        }
    }

    [self.collectionView reloadData];
}

#pragma mark - UIVCRFooterRVDelegate
// 点击立即支付
- (void)payWithMoney
{
    // 可以选择支付方式
    if (_showSelectePayType) {
        if (_selectedType == ENUM_PayTypeApplePay)
            [self appStoreHandle];
        else
            [self aliPayHandle];
    }
    else
        [self appStoreHandle];
}

#pragma mark - 创建购买/充值订单
- (void)createOrderWithOrder
{
    NSString *strFullMinusCost = @"";
    NSString *booksId = @"";
    if (_order.books.count > 0) {
        for (NSInteger i = 0; i < _order.books.count; i ++) {
            BookModel *book = _order.books[i];
            booksId = [booksId stringByAppendingString:[NSString stringWithFormat:@"%ld,", book.bookId]];
        }
        booksId = [booksId substringToIndex:booksId.length - 1];
    }
    for (NSInteger i = 0; i < _order.fullMinusCost.count; i ++) {
        // TODO: 满减券
    }
    WeakSelf(self)
    [[OrderRequest sharedInstance] addOrderWithType:_payPurpose
                                            payType:_selectedType
                                         totalmoney:_order.totalmoney
                                      fullMinusCost:strFullMinusCost
                                    finalTotalMoney:_order.finalTotalMoney
                                                 id:_priceModel.id
                                      rechargeMoney:_price
                                              score:_order.score
                                            booksId:booksId
                                          domorfore:_foreign
                                         completion:^(id object, ErrorModel *error) {
                                             StrongSelf(self)
                                             if (error) {
                                                 [self presentFailureTips:error.message];
                                             }
                                             else {
                                                 NSDictionary *dicOrder = [object mj_JSONObject];
                                                 self.order.orderId = dicOrder[@"orderId"];
                                                 [self aliPayWithOrderString:dicOrder[@"orderStr"]];
                                             }
                                         }];
}
#pragma mark - 创建包月订单
- (void)creatOrderWithSerial
{
    if (_payPurpose == ENUM_PayPurposeAllLease) {
        self.order.totalmoney      = _price/(_foreign ? _scoreRate.foreignrate.floatValue : _scoreRate.domesticrate.floatValue);
        self.order.finalTotalMoney = _price/(_foreign ? _scoreRate.foreignrate.floatValue : _scoreRate.domesticrate.floatValue);
        self.order.rechargeMoney   = _price;
    }
    WeakSelf(self)
    [[OrderRequest sharedInstance] addSerialOrderWithType:_payPurpose
                                                  payType:_selectedType
                                                 serialId:_order.serialId
                                               totalmoney:_order.totalmoney
                                          finalTotalMoney:_order.finalTotalMoney
                                                       id:_priceModel.id
                                            rechargeMoney:_price
                                                     name:_order.name
                                                  readDay:_payPurpose == ENUM_PayPurposeAllLease ? _priceModel.day : _order.readDay
                                                domorfore:_foreign
                                               completion:^(id object, ErrorModel *error) {
                                                   StrongSelf(self)
                                                   if (error) {
                                                       [self presentFailureTips:error.message];
                                                   }
                                                   else {
                                                       NSDictionary *dicOrder = [object mj_JSONObject];
                                                       self.order.orderId = dicOrder[@"orderId"];
                                                       [self aliPayWithOrderString:dicOrder[@"orderStr"]];
                                                   }
                                               }];
}
#pragma mark - 继续支付订单
- (void)updateOrder
{
    NSString *strFullMinusCost = @"";
    NSString *booksId = @"";
    if (_order.books.count > 0) {
        for (NSInteger i = 0; i < _order.books.count; i ++) {
            BookModel *book = _order.books[i];
            booksId = [booksId stringByAppendingString:[NSString stringWithFormat:@"%ld,", book.bookId]];
        }
        booksId = [booksId substringToIndex:booksId.length - 1];
    }
    WeakSelf(self)
    [[OrderRequest sharedInstance] updateOrderWithOrderId:_order.orderId
                                                 WithType:_payPurpose
                                                  payType:_selectedType
                                               totalmoney:_order.totalmoney
                                            fullMinusCost:strFullMinusCost
                                          finalTotalMoney:_order.finalTotalMoney
                                                       id:_priceModel.id
                                            rechargeMoney:_price
                                                    score:_order.score
                                                  booksId:booksId
                                                domorfore:_foreign
                                               completion:^(id object, ErrorModel *error) {
                                                   StrongSelf(self)
                                                   if (error) {
                                                       [self presentFailureTips:error.message];
                                                   }
                                                   else {
                                                       NSDictionary *dicOrder = [object mj_JSONObject];
                                                       self.order.orderId = dicOrder[@"orderId"];
                                                       [self aliPayWithOrderString:dicOrder[@"orderStr"]];
                                                   }
                                               }];
}

#pragma mark --------------- 支付选择项 ---------------

#pragma mark - appStore 内购

- (void)appStoreHandle
{
    [self presentFailureTips:LOCALIZATION(@"您的设备不支持内购")];
//    [ZAppStore buyProductsWithId:[NSString stringWithFormat:@"%@%@", appScheme, _priceModel.virtualcoinType] viewController:self];
}

#pragma mark - aliPay
#pragma mark 生成订单
- (void)aliPayHandle
{
    // 购买或充值
    if (_payPurpose == ENUM_PayPurposeBuy || _payPurpose == ENUM_PayPurposeRecharge) {
        // 没有订单号则创建新订单
        if ([_order.orderId notEmpty] && [_order.orderId isNot:@"0"])
            [self updateOrder];
        // 有订单号就继续支付该订单
        else
            [self createOrderWithOrder];
    }
    // 创建系列订单
    else
        [self creatOrderWithSerial];
}

/**
  使用alipay支付

 @param orderString 加密订单码
 */
- (void)aliPayWithOrderString:(NSString *)orderString
{
    if (!orderString) {
        [self presentFailureTips:LOCALIZATION(@"支付失败")];
        return;
    }
    // NOTE: 调用支付结果开始支付
    WeakSelf(self)
    [[AlipaySDK defaultService] payOrder:orderString fromScheme:appScheme callback:^(NSDictionary *resultDic) {
        StrongSelf(self)
        AliPayResultDicModel *aliPayResultDic = [AliPayResultDicModel mj_objectWithKeyValues:resultDic];
        AliPayResultModel    *aliPayresult    = [AliPayResultModel    mj_objectWithKeyValues:aliPayResultDic.result];
        AliPayResponseModel  *aliPayResponse  = [AliPayResponseModel  mj_objectWithKeyValues:aliPayresult.alipay_trade_app_pay_response];
        // 阿里返回的订单id
        NSString *orderId = aliPayResponse.out_trade_no;
        if ([orderId notEmpty]) {
            _order.orderId = orderId;
        }
        switch (aliPayResultDic.resultStatus) {
            case 9000: // 订单支付成功
            case 6004: // 支付结果未知（有可能已经支付成功），请查询商户订单列表中订单的支付状态
                [self getResultWithOrderId:orderId];
                break;
            case 8000: // 正在处理中，支付结果未知（有可能已经支付成功），请查询商户订单列表中订单的支付状态
                [self presentFailureTips:LOCALIZATION(@"正在处理中...")];
                [self getResultWithOrderId:orderId];
                break;
            case 4000: // 订单支付失败
            case 6001: // 用户中途取消
                [self presentFailureTips:LOCALIZATION(@"支付失败")];
                [self updateOrderStatus];
                break;
            case 5000: // 重复请求
                [self presentFailureTips:LOCALIZATION(@"重复请求")];
                break;
            case 6002: // 网络连接出错
                [self presentFailureTips:LOCALIZATION(@"网络连接失败")];
                break;
            default:   // 其它支付错误
                [self presentFailureTips:LOCALIZATION(@"未知错误")];
                break;
        }
    }];
}

#pragma mark 修改订单状态为未支付
- (void)updateOrderStatus
{
    if (_order.orderId.length == 0)
        return;

    WeakSelf(self)
    [[OrderRequest sharedInstance] updateOrderStatusWithOrderId:_order.orderId completion:^(id object, ErrorModel *error) {
        if (error)
            [weakself presentFailureTips:error.message];
    }];
}

#pragma mark - 在服务器获取订单信息, 避免本地与服务器数据不同步, 数据出错
- (void)getResultWithOrderId:(NSString *)orderId
{
    if (_requestNumber <= 0) {
        [self presentFailureTips:LOCALIZATION(@"支付结果未知, 请查询订单状态")];
        return;
    }
    _requestNumber -= 1;
    WeakSelf(self)
    [[OrderRequest sharedInstance] getOrderResultWithOrderId:orderId type:_payPurpose completion:^(id object, ErrorModel *error) {
        StrongSelf(self)
        if (error) {
            [self presentFailureTips:error.message];
            _requestNumber = kMaxRequestNumber;
        }
        else {
            NSArray *array = [OrderModel mj_objectArrayWithKeyValuesArray:object];
            OrderModel *order = array.firstObject;
            [self getUserInfo];
            switch (order.orderStatus) {
                case ENUM_ZOrderStateObligation: // 待付款
                    _requestNumber = kMaxRequestNumber;
                    _order.orderId = orderId;
                    [self presentFailureTips:LOCALIZATION(@"支付失败, 余额不足")];
                    break;
                case ENUM_ZOrderStateScore: // 待评价
                case ENUM_ZOrderStateDone: {// 完成
                    _requestNumber = kMaxRequestNumber;
                    [self paySuccessWithOrder:order];
                }
                    break;
                case ENUM_ZOrderStatePaying:// 支付中
                    [self getResultWithOrderId:orderId];
                    break;
                default:
                    _requestNumber = kMaxRequestNumber;
                    _order.orderId = orderId;
                    [self presentFailureTips:LOCALIZATION(@"未知错误")];
                    break;
            }
        }
    }];
}

#pragma mark - 获取用户信息
- (void)getUserInfo
{
    WeakSelf(self)
    [[UserRequest sharedInstance] getUserInfoWithCompletion:^(id object, ErrorModel *error) {
        if (error)
            [weakself presentFailureTips:error.message];
    }];
}

#pragma mark - 支付成功
- (void)paySuccessWithOrder:(OrderModel *)order
{
    [self fk_postNotification:kNotificationUpdateOrderInfo object:order];
    [[NSNotificationCenter defaultCenter] postNotificationName:kNotificationBookrackLoadNewData object:nil];
    PaySuccessViewController *success = [PaySuccessViewController new];
    success.order = order;
    [self.navigationController pushViewController:success animated:YES];
}

#pragma mark - 属性
- (UICollectionViewFlowLayout *)layout
{
    if (!_layout) {
        _layout = [[UICollectionViewFlowLayout alloc] init];
        _layout.minimumLineSpacing = isPad ? kSpace : 0;
        _layout.minimumInteritemSpacing = isPad ? kSpace : 0;
        _layout.scrollDirection = UICollectionViewScrollDirectionVertical;
        _layout.sectionInset = UIEdgeInsetsMake(0, kSpace, kSpace, kSpace);
    }
    return _layout;
}

- (UICollectionView *)collectionView
{
    if (!_collectionView) {
        _collectionView = [[UICollectionView alloc] initWithFrame:CGRectMake(0, 0, Screen_Width, self.view.height) collectionViewLayout:self.layout];
        _collectionView.backgroundColor = [UIColor whiteColor];
        _collectionView.delegate = self;
        _collectionView.dataSource = self;
        _collectionView.collectionViewLayout = self.layout;
        
        [_collectionView registerNib:[UINib nibWithNibName:kHeaderView bundle:nil] forSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:kHeaderView];
        [_collectionView registerNib:[UINib nibWithNibName:kFooterView bundle:nil] forSupplementaryViewOfKind:UICollectionElementKindSectionFooter withReuseIdentifier:kFooterView];
        [_collectionView registerNib:[UINib nibWithNibName:kPayTypeCell bundle:nil] forCellWithReuseIdentifier:kPayTypeCell];
        [_collectionView registerNib:[UINib nibWithNibName:kSelecteCell bundle:nil] forCellWithReuseIdentifier:kSelecteCell];
        [_collectionView registerNib:[UINib nibWithNibName:kShowPriceCell bundle:nil] forCellWithReuseIdentifier:kShowPriceCell];
        
        [self.view addSubview:_collectionView];
    }
    return _collectionView;
}

- (OrderModel *)order
{
    if (_order == nil) {
        _order = [OrderModel new];
    }
    return _order;
}

@end
