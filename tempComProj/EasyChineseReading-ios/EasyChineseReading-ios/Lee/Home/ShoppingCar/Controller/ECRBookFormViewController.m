//
//  ECRBookFormViewController.m
//  EasyChineseReading-ios
//
//  Created by Peanut Lee on 2017/9/27.
//  Copyright © 2017年 retech. All rights reserved.
//

// 测试余额,便于修改, 测试后删除
#define yue_test 50

#import "ECRBookFormViewController.h"
#import "ECRPaymentPreviousView.h"
#import "ECRBookFormTopView.h"
#import "ECRPpvPirceView.h"
#import "ECRPpvScoreView.h"
#import "ECRTopupFieldView.h"
#import "ECRFullMinusRollView.h"
#import "ECRFullminusTableViewCell.h"
#import "ECRFullminusModel.h"
#import "ECRShoppingCarModel.h"
//#import "ECRFullminusRowModel.h"
#import "ECRRowObject.h"
#import "ECRPayDoneController.h"
#import "UVirtualCurrencyRechargeVC.h"
#import "OrderModel.h"
#import "ECRRgButton.h"
#import "ECRVirScoreRateModel.h"
#import "ECRDiscountsOperator.h"
#import "ECRFullminusTableViewCell_iPhone.h"
#import "UserOrderVC.h"

static NSString *btBtnTitle = @"返回购物车";
static NSString *pyBtnTitle = @"支付";
static NSString *fullminusCell = @"ECRFullminusTableViewCell";
static NSString *fullminusCell_iPhone = @"ECRFullminusTableViewCell_iPhone";

@interface ECRBookFormViewController ()<
UITableViewDataSource,
UITableViewDelegate
//ECRFullminusTableViewCellDelegate
>

@property (weak,nonatomic) UIColor *bbBtnBorderColor;//
//@property (strong,nonatomic) UIScrollView *scrollView;//
@property (strong,nonatomic) UIButton *backTosc;//
@property (strong,nonatomic) UIButton *pay;//

@property (strong,nonatomic) ECRBookFormTopView *btv;//
@property (strong,nonatomic) ECRPaymentPreviousView *ppv;//

//1. 可用的满减卷 — 以供用户选择满减
@property (strong,nonatomic) NSDictionary *avaJuan;
//2. 所有满减卷 — 用来展示给用户哪些能使用，哪些不能
@property (strong,nonatomic) NSMutableArray<ECRFullminusModel *> *allJuan;//


/** ipad 模型数组 */
@property (strong,nonatomic) NSArray *coupons;
///** iPhone 模型数组 */
//@property (strong,nonatomic) NSArray *<#objc#>;
@property (assign,nonatomic) CGFloat oriPrice;// 总价原价

/** 用户选择使用的满减卷模型 */
@property (strong,nonatomic) NSMutableArray<ECRFullminusModel *> *usedJuan;

/** 最终需要支付的虚拟币价格 */
@property (assign,nonatomic) CGFloat finalPrice;

@property (strong,nonatomic) ECRVirScoreRateModel *rateModel;//
/** 最终抵扣积分 */
@property (assign,nonatomic) NSInteger usedScore;
/** 最高可抵扣积分 */
@property (assign,nonatomic) NSInteger avaScore;
/** 可抵扣的虚拟币数量 */
@property (assign,nonatomic) NSInteger avaPrice;

/** 是否选中积分,1 = 选中, 0 = 未选中 */
@property (assign,nonatomic) BOOL scoreIsSelected;

@end

@implementation ECRBookFormViewController

- (void)requestAllJuan{
    /// 请求满减卷
    [[ECRDataHandler sharedDataHandler] fullminusListWithSuccess:^(id object) {
//        self.allJuan = object;
//        NSArray *arr_object = object;
//        if (arr_object.count == 0) {
//            NSLog(@"arr_object.count == 0 -- ");
//        }
        if (object == nil) {
            // 显示 kongview
            
        }else{
            // 过滤当前可用的满减卷
            NSMutableDictionary *dictM = [NSMutableDictionary dictionaryWithCapacity:10];
            [object enumerateObjectsUsingBlock:^(ECRFullminusModel * _Nonnull juan, NSUInteger idx_juan, BOOL * _Nonnull stop_juan) {
                juan.abtPrice = 0;
                
                [self.tickedArray enumerateObjectsUsingBlock:^(ECRShoppingCarModel * _Nonnull carModel, NSUInteger idx_carModel, BOOL * _Nonnull stop_carModel) {
                    if (carModel.fullminusType == juan.fullminusType.integerValue) {
                        juan.abtPrice += carModel.price;
                        //                    NSLog(@"type%ld -- _abtPrice: %f -- 书籍价格: %f",juan.fullminusType.integerValue,juan.abtPrice,carModel.price);
                        if (juan.abtPrice >= juan.fullMoney.floatValue) {
                            dictM[[NSString stringWithFormat:@"%ld",juan.fullminusType.integerValue]] = juan;
                        }
                    }
                    
                }];
            }];
            
            self.avaJuan = dictM.copy;// 必须先设置 avaJuan
            self.allJuan = [NSMutableArray arrayWithArray:object];
        }
        
    } failure:^(NSString *msg) {
        
    } commenFailure:^(NSError *error) {
        
    }];
}

- (void)setAllJuan:(NSMutableArray<ECRFullminusModel *> *)allJuan{
    _allJuan = allJuan;
    if (allJuan.count) {
        @try{
            [self.ppv setValue:@(YES) forKeyPath:@"rrfView.hidden"];
        }@catch(NSException *exception){
            NSLog(@"exception: %@",exception);
        }
    }
    
    // MARK: 全部 满减juan
    // 设置allJuan 中 juan 的isAva
    [self.allJuan enumerateObjectsUsingBlock:^(ECRFullminusModel * _Nonnull juan, NSUInteger idx_juan, BOOL * _Nonnull stop_juan) {
//        NSLog(@"订单明细juan.type -- %ld",juan.fullminusType.integerValue);
        juan.isAva = NO;// 默认为 NO，只有当 avaJuan中有该类型的juan时，才将isAva设置为YES
        [self.avaJuan.allKeys enumerateObjectsUsingBlock:^(id  _Nonnull key, NSUInteger idx_key, BOOL * _Nonnull stop_key) {
            ECRFullminusModel *avaJuan = _avaJuan[key];
            if (avaJuan.fullminusType == juan.fullminusType) {
                juan.isAva = YES;
            }
//            NSLog(@"排序前juan.ava -- %ld",juan.isAva);
        }];
    }];
    
    // MARK: 将可用的优惠券排到最前面
    NSInteger n = self.allJuan.count;
    NSInteger i, j;
    ECRFullminusModel *tempModel;
    for (j = 0; j < n - 1; j++)
        for (i = 0; i < n - 1 - j; i++){
            ECRFullminusModel *model_i = self.allJuan[i];
            ECRFullminusModel *model_i_next = self.allJuan[i+1];
            if(model_i.isAva < model_i_next.isAva){// 如果
                tempModel = model_i;
                [self.allJuan replaceObjectAtIndex:i withObject:model_i_next];
                [self.allJuan replaceObjectAtIndex:(i + 1) withObject:tempModel];
            }
        }
    
    // ipad 转成一行 两列的形式
    if ([ECRMultiObject userInterfaceIdiomIsPad]) {
        NSArray *arr = [[ECRMultiObject sharedInstance] singleLineDoubleModelWithOriginArr:self.allJuan];
        self.coupons = arr;
    }
    
    
    [[NSOperationQueue mainQueue] addOperationWithBlock:^{
        [self.ppv.fullMinusView.tableView reloadData];
    }];
}
- (void)setTickedArray:(NSArray<ECRShoppingCarModel *> *)tickedArray{
    _tickedArray = tickedArray;
    // MARK: 全部商品
    
}
- (void)setTickedPrice:(CGFloat)tickedPrice{
    _tickedPrice = tickedPrice;
    // MARK: 商品总价
    self.btv.priceTotal = [NSString stringWithFormat:@"%.2f",tickedPrice];
    
    // 获取积分 抵扣比例
    [ECRDataHandler selectCoinrateSuccess:^(id object) {
//        NSLog(@"ECRVirScoreRateModel -- %@",object);
        NSArray *arr = object;
        if (arr == nil) {
            
        }else{
            ECRVirScoreRateModel *model = [ECRVirScoreRateModel mj_objectWithKeyValues:arr[0]];
//            NSLog(@"model.integralrate -- %@",model.integralrate);
//            NSLog(@"model.integralpercent.integerValue -- %@",model.integralpercent);
            self.rateModel = model;
            // MARK: 计算可抵扣积分
            
            _avaScore = [ECRDiscountsOperator avaScoreWithTickedPrice:tickedPrice rateModel:model];
            
            self.ppv.scoreCoun.avaScore = _avaScore;
            self.ppv.scoreCoun.integralrate = model.integralrate.integerValue;
        }
    } failure:^(NSString *msg) {
        
    } commenFailure:^(NSError *error) {
        
    }];
}

- (void)backClick:(UIButton *)sender{
    // 返回购物车
    [self baseViewControllerDismiss];
}

// MARK: 点击支付(或充值并购买)
- (void)payClick:(UIButton *)sender{
    
    if (!self.scoreIsSelected) {
        _avaScore = 0;
        _avaPrice = 0;
    }
//    NSLog(@"------- -- %ld",UserRequest.sharedInstance.user.score);
    if ([self yueEnough]) {
        /// final支付
        /// 余额充足,直接支付
        NSMutableArray *bookIds = [NSMutableArray new];
        [self.tickedArray enumerateObjectsUsingBlock:^(ECRShoppingCarModel * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            [bookIds addObject:@(obj.bookId)];
        }];
        CGFloat finalPrice = self.tickedPrice;
        
        [ECRDataHandler yuePayWithBookIds:bookIds.copy juanIds:[self juanIds] totalMoney:self.oriPrice finalTotalMoney:finalPrice score:_avaScore orderId:self.orderId success:^(id object) {

            [UserRequest sharedInstance].user.virtualCurrency -= finalPrice;
            UserRequest.sharedInstance.user.score -= _avaScore;
            [[UserRequest sharedInstance] saveCache];
            [[NSOperationQueue mainQueue] addOperationWithBlock:^{
                [self presentSuccessTips:LOCALIZATION(@"支付成功")];
            }];
            [self fk_postNotification:kNotificationUpdateOrderInfo object:object];
            // 延时执行 退出,让用户看到支付成功
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                UserOrderVC *order = [UserOrderVC new];
                order.isLeaseOrder = NO;
                [self.navigationController pushViewController:order animated:YES];
            });
            // MARK: 购买成功，刷新书架
            [[NSNotificationCenter defaultCenter] postNotificationName:kNotificationBookrackLoadNewData object:nil];
            
        } failure:^(NSString *msg) {
            [self presentSuccessTips:msg];
        } commenFailure:^(NSError *error) {

        }];
    }else{
        /// 充值
        UVirtualCurrencyRechargeVC *recharge = [UVirtualCurrencyRechargeVC loadFromStoryBoard:@"User"];
        recharge.payPurpose = ENUM_PayPurposeBuy;
        recharge.scoreRate = _rateModel;
        /// 数据
        OrderModel *order = [OrderModel new];
        order.orderId = self.orderId;
        order.books = self.tickedArray;/// 所有要买的书籍
        order.totalmoney = self.oriPrice;/// 商品总价(未减之前)
        order.fullMinusCost = [self juanIds];/// 使用的满减卷ids
        order.finalTotalMoney = self.tickedPrice;/// 减完之后 所需支付的金额
        NSMutableArray *arrm = [NSMutableArray arrayWithCapacity:10];
        for (NSInteger i = 0; i < self.usedJuan.count; i++) {
            ECRFullminusModel *model = self.usedJuan[i];
            [arrm addObject:[NSString stringWithFormat:@"%@",model.seqid]];
        }
        order.score = _avaScore;
        recharge.order = order;
        [self.navigationController pushViewController:recharge animated:YES];
    }

}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setupUI];
    [self requestAllJuan];
}


#pragma mark - UITableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if ([ECRMultiObject userInterfaceIdiomIsPad]) {
        return self.coupons.count;
    }else{
        return self.allJuan.count;
    }
    
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    if ([ECRMultiObject userInterfaceIdiomIsPad]) {
        ECRFullminusTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:fullminusCell];
        ECRRowObject *model = self.coupons[indexPath.row];
        //    cell.delegate = self;
        cell.inx = indexPath;
        cell.rowModel = model;
        return cell;
    }else{
        ECRFullminusTableViewCell_iPhone *cell = [tableView dequeueReusableCellWithIdentifier:fullminusCell_iPhone];
        ECRFullminusModel *model = self.allJuan[indexPath.row];
        cell.model = model;
        return cell;
    }
}
#pragma mark - UITableViewDelegate
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if ([ECRMultiObject userInterfaceIdiomIsPad]) {
        ECRFullminusTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:fullminusCell];
        return cell.cellHeight;
    }else{
        ECRFullminusTableViewCell_iPhone *cell = [tableView dequeueReusableCellWithIdentifier:fullminusCell_iPhone];
        return cell.cellHeight;
    }
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    if (![ECRMultiObject userInterfaceIdiomIsPad]) {
        ECRFullminusModel *model = self.allJuan[indexPath.row];
        [self selectedJuan:model isSelect:YES];
    }
}
- (void)textDependsLauguage{
    self.title = [LGPChangeLanguage localizedStringForKey:@"订单明细"];
    btBtnTitle = [LGPChangeLanguage localizedStringForKey:@"返回购物车"];
//    self.tickedPrice = 0;
    if ([self yueEnough]) {
        // 余额充足显示 支付
        pyBtnTitle = [LGPChangeLanguage localizedStringForKey:@"支付"];
    }else{
        // 余额不足显示 充值并购买
        pyBtnTitle = [LGPChangeLanguage localizedStringForKey:@"充值并购买"];
    }
}

- (void)setupUI{
    [self textDependsLauguage];
    _oriPrice = 0;
    _avaScore = 0;
    _scoreIsSelected = NO;
    [self.view addSubview:self.backTosc];
    [self.view addSubview:self.pay];
    
    [self.view addSubview:self.btv];
    [self.view addSubview:self.ppv];
    
    [self.btv mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.view.mas_top);
        make.left.equalTo(self.view.mas_left);
        make.bottom.equalTo(self.ppv.mas_top);
        make.right.equalTo(self.view.mas_right);
        make.height.equalTo(@50);
        make.width.equalTo(@(Screen_Width));
    }];

    [self.ppv mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.equalTo(@(Screen_Width));
        make.left.equalTo(self.view.mas_left);
        make.right.equalTo(self.view.mas_right);
        make.bottom.equalTo(self.backTosc.mas_top);
    }];
    CGFloat heightBB = 50;
    [self.backTosc mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.ppv.mas_bottom);
        make.left.equalTo(self.view.mas_left);
        make.bottom.equalTo(self.view.mas_bottom);
        make.height.equalTo(@(heightBB));
        make.width.equalTo(@(Screen_Width / 2));
    }];
    [self.pay mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.view.mas_right);
        make.width.equalTo(@(Screen_Width / 2 + 1));
        make.top.equalTo(self.backTosc.mas_top);
        make.bottom.equalTo(self.backTosc.mas_bottom);
    }];
    
    self.ppv.fullMinusView.tableView.dataSource = self;
    self.ppv.fullMinusView.tableView.delegate = self;
    
    /// 注册cell
    if ([ECRMultiObject userInterfaceIdiomIsPad]) {
        [self.ppv.fullMinusView.tableView registerNib:[UINib nibWithNibName:fullminusCell bundle:nil] forCellReuseIdentifier:fullminusCell];
    }else{
        [self.ppv.fullMinusView.tableView registerNib:[UINib nibWithNibName:fullminusCell_iPhone bundle:nil] forCellReuseIdentifier:fullminusCell_iPhone];
    }
    
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(juanClickNotification:) name:ECRFullminusJuanViewClickNotification object:nil];
    
    // 用户余额
    self.ppv.priceView.priceYu = [NSString stringWithFormat:@"%.2f",[ECRMultiObject userYue]];
    /// 用户积分
    self.ppv.scoreCoun.priceYu = [ECRMultiObject userScore];
    
    [self.ppv.scoreCoun.userScore.btn addTarget:self action:@selector(useScore:) forControlEvents:UIControlEventTouchUpInside];
    
    // MARK: 判断是否可用 积分进行抵扣
    if ([ECRMultiObject userScore] < 10) {
        self.ppv.scoreCoun.userCanCLick = NO;
        
    }else{
        self.ppv.scoreCoun.userCanCLick = YES;
        
    }
}
- (void)useScore:(UIButton *)sender{
    if (sender.selected) {
        /// 选中 使用积分
        _scoreIsSelected = YES;
    }else{
        /// 取消选中 使用积分
        _scoreIsSelected = NO;
    }
    // MARK: 计算总价
    [ECRDiscountsOperator calPriceWithOriPirce:self.oriPrice usedJuan:self.usedJuan rateModel:self.rateModel useScore:_scoreIsSelected completion:^(CGFloat finalPrice, NSInteger avaScore, NSInteger avaPrice) {
        _tickedPrice = finalPrice;
        _avaScore = avaScore;
        _avaPrice = avaPrice;
        self.btv.priceTotal = [NSString stringWithFormat:@"%.2f",finalPrice];
//        NSLog(@"finalPrice -- %f",finalPrice);
    } dontUseScoreBlock:^{
        _avaScore = [ECRDiscountsOperator avaScoreWithTickedPrice:_tickedPrice rateModel:self.rateModel];
        // 可使用积分
    }];
    self.ppv.scoreCoun.avaScore = _avaScore;
    self.ppv.scoreCoun.integralrate = self.rateModel.integralrate.integerValue;
//    NSLog(@"_avaPrice -- %ld",_avaPrice);
//    NSLog(@"avaScore -- %ld",_avaScore);
}
// MARK: 可用满减卷点击事件 -- 通知
- (void)juanClickNotification:(NSNotification *)notification{
    NSDictionary *userInfo = notification.userInfo;
    BOOL isSelect = YES;
    ECRFullminusModel *model = userInfo[@"model"];
    [self selectedJuan:model isSelect:isSelect];
}
// MARK: 选中满减卷
- (void)selectedJuan:(ECRFullminusModel *)model isSelect:(BOOL)isSelect{
    for (NSInteger i = 0; i < self.allJuan.count; i++) {
        ECRFullminusModel *modelInArray = self.allJuan[i];
        if (modelInArray == model) {
            if (modelInArray.isSelected) {
                modelInArray.isSelected = NO;
                isSelect = NO;
                [self.usedJuan removeObject:modelInArray];
            }else{
                modelInArray.isSelected = YES;
                isSelect = YES;
                [self.usedJuan addObject:modelInArray];
            }
        }else{
            if (modelInArray.fullminusType.integerValue == model.fullminusType.integerValue) {
                modelInArray.isSelected = NO;
                //                    isSelect = NO;
                [self.usedJuan removeObject:modelInArray];
            }
        }
    }
    
    /// 计算总价
    [ECRDiscountsOperator calPriceWithOriPirce:self.oriPrice usedJuan:self.usedJuan rateModel:self.rateModel useScore:_scoreIsSelected completion:^(CGFloat finalPrice, NSInteger avaScore, NSInteger avaPrice) {
        _tickedPrice = finalPrice;
        _avaScore = avaScore;
        _avaPrice = avaPrice;
        
        self.btv.priceTotal = [NSString stringWithFormat:@"%.2f",finalPrice];
        //        NSLog(@"finalPrice -- %f",finalPrice);
    } dontUseScoreBlock:^{
        _avaScore = [ECRDiscountsOperator avaScoreWithTickedPrice:_tickedPrice rateModel:self.rateModel];
    }];
    // 可使用积分
    self.ppv.scoreCoun.avaScore = _avaScore;
    self.ppv.scoreCoun.integralrate = self.rateModel.integralrate.integerValue;
    //    NSLog(@"_avaPrice -- %ld",_avaPrice);
    //    NSLog(@"avaScore -- %ld",_avaScore);
    
    [self.ppv.fullMinusView.tableView reloadData];
}

- (ECRBookFormTopView *)btv{
    if (_btv == nil) {
        _btv = [[ECRBookFormTopView alloc] init];
    }
    return _btv;
}
- (ECRPaymentPreviousView *)ppv{
    if (_ppv == nil) {
        _ppv = [[ECRPaymentPreviousView alloc] init];
        
    }
    return _ppv;
}
- (UIButton *)backTosc{
    if (_backTosc == nil) {
        _backTosc = [[UIButton alloc] init];
        _backTosc.layer.borderWidth = 1;
        _backTosc.layer.borderColor = self.bbBtnBorderColor.CGColor;
        [_backTosc setTitle:btBtnTitle forState:UIControlStateNormal];
        [_backTosc setTitleColor:[UIColor cm_mainColor] forState:UIControlStateNormal];
        [_backTosc.titleLabel setFont:[UIFont systemFontOfSize:14]];
        [_backTosc setBackgroundColor:[UIColor whiteColor]];
        [_backTosc addTarget:self action:@selector(backClick:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _backTosc;
}
- (UIButton *)pay{
    if (_pay == nil) {
        _pay = [[UIButton alloc] init];
        _pay.layer.borderWidth = 1;
        _pay.layer.borderColor = self.bbBtnBorderColor.CGColor;
        [_pay setTitle:pyBtnTitle forState:UIControlStateNormal];
        [_pay setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [_pay.titleLabel setFont:[UIFont systemFontOfSize:14]];
        [_pay setBackgroundColor:[UIColor cm_mainColor]];
        [_pay addTarget:self action:@selector(payClick:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _pay;
}
- (UIColor *)bbBtnBorderColor{
    if (_bbBtnBorderColor == nil) {
        _bbBtnBorderColor = [UIColor cm_lineColor_D9D7D7_1];
    }
    return _bbBtnBorderColor;
}

- (CGFloat)oriPrice{
    if (_oriPrice == 0) {
        _oriPrice = 0;
        for (NSInteger i = 0; i < self.tickedArray.count; ++i) {
            ECRShoppingCarModel *model = self.tickedArray[i];
            model.isTick = YES;
            _oriPrice += model.price;
        }
    }
    return _oriPrice;
}
- (NSMutableArray<ECRFullminusModel *> *)usedJuan{
    if (_usedJuan == nil) {
        _usedJuan = [NSMutableArray new];
    }
    return _usedJuan;
}

- (void)dealloc{
    for (NSInteger i = 0; i < self.allJuan.count; i++) {
        ECRFullminusModel *modelInArray = self.allJuan[i];
        if (modelInArray.isAva) {
            modelInArray.isSelected = NO;
        }
    }
}

- (BOOL)yueEnough{
    return [ECRMultiObject userYue] >= self.tickedPrice;
}

- (NSArray *)juanIds{
    NSMutableArray *fullMinusCost = [NSMutableArray new];
    [self.usedJuan enumerateObjectsUsingBlock:^(ECRFullminusModel * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        [fullMinusCost addObject:obj.seqid];
    }];
    return fullMinusCost.copy;
}

@end




