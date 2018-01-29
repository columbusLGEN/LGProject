//
//  PaySuccessViewController.m
//  EasyChineseReading-ios
//
//  Created by 赵春阳 on 2017/11/7.
//  Copyright © 2017年 retech. All rights reserved.
//

#import "PaySuccessViewController.h"

#import "UserOrderVC.h"
#import "AppDelegate.h"

static CGFloat const kButtonWidth = 140.f;

@interface PaySuccessViewController ()

@property (strong, nonatomic) UIImageView *imgSuccess;

@property (strong, nonatomic) UILabel *lblDescPayType;  // 支付类别描述
@property (strong, nonatomic) UILabel *lblDescPayPrice; // 支付金额描述
@property (strong, nonatomic) UILabel *lblPayType;      // 支付类别 (全平台包月, 系列包月, 充值, 购买)
@property (strong, nonatomic) UILabel *lblPayPrice;     // 支付金额
@property (strong, nonatomic) UILabel *lblDescribe;     // 注意

@property (strong, nonatomic) UIButton *btnOrderList;   // 到订单列表
@property (strong, nonatomic) UIButton *btnHome;        // 返回首页

@end

@implementation PaySuccessViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = LOCALIZATION(@"支付成功");
    [self configSuccessView];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

#pragma mark - 配置界面

- (void)createNavLeftBackItem
{
    UIButton *backButton = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 44, 44)];
    UIBarButtonItem *back = [[UIBarButtonItem alloc] initWithCustomView:backButton];
    self.navigationItem.leftBarButtonItems = @[back];
    self.navigationController.interactivePopGestureRecognizer.delegate = (id)self;// 解决自定义导航栏按钮导致系统的左滑pop 失效
}

- (void)configSuccessView
{
    _imgSuccess = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"img_success"]];
    [self.view addSubview:_imgSuccess];
    WeakSelf(self)
    [_imgSuccess mas_makeConstraints:^(MASConstraintMaker *make) {
        StrongSelf(self)
        make.centerX.equalTo(self.view.mas_centerX);
        make.bottom.equalTo(self.view.mas_centerY).offset(-90 - 45);
    }];
    
    _lblDescPayType = [UILabel new];
    _lblDescPayType.font = [UIFont systemFontOfSize:cFontSize_16];
    _lblDescPayType.textColor = [UIColor cm_blackColor_666666_1];
    _lblDescPayType.text = [NSString stringWithFormat:@"%@: ", LOCALIZATION(@"支付类型")];
    [self.view addSubview:_lblDescPayType];
    
    [_lblDescPayType mas_makeConstraints:^(MASConstraintMaker *make) {
        StrongSelf(self)
        make.right.equalTo(self.view.mas_centerX);
        make.bottom.equalTo(self.view.mas_centerY).offset(-90);
    }];

    _lblPayType = [UILabel new];
    _lblPayType.font = [UIFont systemFontOfSize:cFontSize_16];
    _lblPayType.textColor = [UIColor cm_orangeColor_FF5910_1];

    [self.view addSubview:_lblPayType];

    [_lblPayType mas_makeConstraints:^(MASConstraintMaker *make) {
        StrongSelf(self)
        make.left.equalTo(self.view.mas_centerX).offset(3);
        make.bottom.equalTo(self.view.mas_centerY).offset(-90);
    }];
    
    _lblDescPayType = [UILabel new];
    _lblDescPayType.font = [UIFont systemFontOfSize:cFontSize_16];
    _lblDescPayType.textColor = [UIColor cm_blackColor_666666_1];
    _lblDescPayType.text = [NSString stringWithFormat:@"%@: ", LOCALIZATION(@"支付金额")];
    [self.view addSubview:_lblDescPayType];

    [_lblDescPayType mas_makeConstraints:^(MASConstraintMaker *make) {
        StrongSelf(self)
        make.right.equalTo(self.view.mas_centerX);
        make.bottom.equalTo(self.view.mas_centerY).offset(-50);
    }];

    _lblPayPrice = [UILabel new];
    _lblPayPrice.font = [UIFont systemFontOfSize:cFontSize_16];
    _lblPayPrice.textColor = [UIColor cm_orangeColor_FF5910_1];
    [self.view addSubview:_lblPayPrice];

    [_lblPayPrice mas_makeConstraints:^(MASConstraintMaker *make) {
        StrongSelf(self)
        make.left.equalTo(self.view.mas_centerX).offset(3);
        make.bottom.equalTo(self.view.mas_centerY).offset(-50);
    }];

    switch (_order.orderType) {
        case ENUM_PayPurposeAllLease:
            _lblPayType.text = LOCALIZATION(@"全平台包月");
            _lblPayPrice.text = [NSString stringWithFormat:@"%@ %.2f", @"¥", _order.rechargeMoney];
            break;
        case ENUM_PayPurposeLease:
        case ENUM_PayPurposeContinue:
            _lblPayType.text = LOCALIZATION(@"系列包月");
            _lblPayPrice.text = [NSString stringWithFormat:@"%@ %.2f", @"¥", _order.rechargeMoney];
            break;
        case ENUM_PayPurposeBuy:
            _lblPayType.text = LOCALIZATION(@"购买图书");
            _lblPayPrice.text = [NSString stringWithFormat:@"%@ %.2f", @"¥", _order.rechargeMoney];
            break;
        case ENUM_PayPurposeRecharge:
            _lblPayType.text = LOCALIZATION(@"虚拟币充值");
            _lblPayPrice.text = [NSString stringWithFormat:@"%@ %.2f", @"¥", _order.rechargeMoney];
            break;
        default:
            break;
    }
    
    _btnOrderList = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, kButtonWidth, cButtonHeight_40)];
    [_btnOrderList setTitle:LOCALIZATION(@"查看订单") forState:UIControlStateNormal];
    [_btnOrderList setTitleColor:[UIColor cm_mainColor] forState:UIControlStateNormal];
    [_btnOrderList addTarget:self action:@selector(toOrderList) forControlEvents:UIControlEventTouchUpInside];
    _btnOrderList.backgroundColor     = [UIColor whiteColor];
    _btnOrderList.layer.cornerRadius  = cButtonHeight_40/2;
    _btnOrderList.layer.masksToBounds = YES;
    _btnOrderList.layer.borderColor   = [UIColor cm_mainColor].CGColor;
    _btnOrderList.layer.borderWidth   = 1.f;
    _btnOrderList.titleLabel.font     = [UIFont systemFontOfSize:cFontSize_14];
    [self.view addSubview:_btnOrderList];
    _btnOrderList.hidden = _order.orderType != ENUM_PayPurposeBuy && _order.orderType != ENUM_PayPurposeLease;
    
    [_btnOrderList mas_makeConstraints:^(MASConstraintMaker *make) {
        StrongSelf(self)
        make.top.equalTo(self.view.mas_centerY);
        make.right.equalTo(self.view.mas_centerX).offset(-22);
        make.size.mas_equalTo(CGSizeMake(kButtonWidth, cButtonHeight_40));
    }];
    
    _btnHome = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, kButtonWidth, cButtonHeight_40)];
    [_btnHome setTitle:LOCALIZATION(@"返回首页") forState:UIControlStateNormal];
    [_btnHome setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [_btnHome addTarget:self action:@selector(toHome) forControlEvents:UIControlEventTouchUpInside];
    _btnHome.backgroundColor = [UIColor cm_mainColor];
    _btnHome.titleLabel.font = [UIFont systemFontOfSize:cFontSize_14];
    _btnHome.layer.cornerRadius = cButtonHeight_40/2;
    _btnHome.layer.masksToBounds = YES;
    [self.view addSubview:_btnHome];
    
    [_btnHome mas_makeConstraints:^(MASConstraintMaker *make) {
        StrongSelf(self)
        make.top.equalTo(self.view.mas_centerY);
        make.centerX.equalTo(self.view.mas_centerX).offset(_order.orderType == ENUM_PayPurposeBuy ? (kButtonWidth + 22)/2 : 0);
        make.size.mas_equalTo(CGSizeMake(_order.orderType == ENUM_PayPurposeBuy ? kButtonWidth : Screen_Width - 86*2, cButtonHeight_40));
    }];
    
    _lblDescribe = [UILabel new];
    _lblDescribe.textColor = [UIColor cm_blackColor_666666_1];
    _lblDescribe.font = [UIFont systemFontOfSize:cFontSize_12];
    _lblDescribe.textAlignment = NSTextAlignmentCenter;
    _lblDescribe.numberOfLines = 0;
    _lblDescribe.text = LOCALIZATION(@"注意: Easy Chinese Reading 平台及销售商不会已订单异常, 系统升级为由要求您点击任何网址链接进行退款操作.");
    [self.view addSubview:_lblDescribe];
    
    [_lblDescribe mas_makeConstraints:^(MASConstraintMaker *make) {
        StrongSelf(self)
        make.top.equalTo(_btnHome.mas_bottom).offset(45);
        make.left.greaterThanOrEqualTo(self.view.mas_left).offset(25);
        make.centerX.equalTo(self.view.mas_centerX);
    }];
}

#pragma mark -

/** 到订单列表 */
- (void)toOrderList
{
    UserOrderVC *order = [UserOrderVC new];
    order.isLeaseOrder = _order.orderType == ENUM_PayPurposeLease;
    [self.navigationController pushViewController:order animated:YES];
}

/** 返回首页 */
- (void)toHome
{
    [self fk_postNotification:kNotificationSelectHome];
    [self.navigationController popToRootViewControllerAnimated:YES];
}

@end
