//
//  ECRPayDoneController.m
//  EasyChineseReading-ios
//
//  Created by Peanut Lee on 2017/11/10.
//  Copyright © 2017年 retech. All rights reserved.
//

static CGFloat offsetx = -30;
static CGFloat fontb = 22;// big
static CGFloat fonts = 14;// small
static NSString *colorb = @"333333";

#import "ECRPayDoneController.h"
#import "ECRTopupFieldView.h"

@interface ECRPayDoneController ()
@property (strong,nonatomic) UILabel *price;//
@property (strong,nonatomic) UILabel *priceDup;// 
@property (strong,nonatomic) ECRTopupFieldView *payView;//

@end

@implementation ECRPayDoneController

- (void)setOrderId:(NSInteger)orderId{
    _orderId = orderId;
    // 如果 orderId 不为空,则需要调用 修改订单接口
    // 否则调用创建订单接口
    
}

- (void)setFinalPrice:(CGFloat)finalPrice{
    _finalPrice = finalPrice;
    [self textDependsLauguage];
}

- (void)textDependsLauguage{
    self.title = [LGPChangeLanguage localizedStringForKey:@"支付"];
    NSString *finalPrice = [NSString stringWithFormat:@"%.0f",_finalPrice];
    [self.price setText:[NSString stringWithFormat:@"￥%@",finalPrice]];
    NSString *virtualCoin = @"虚拟币";
    NSString *pdString = [NSString stringWithFormat:@"( %@%@ )",finalPrice,[LGPChangeLanguage localizedStringForKey:virtualCoin]];// 该方法截取到的位置不包括 index
    [self.priceDup setText:pdString];
    [self.priceDup sizeToFit];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self.view addSubview:self.price];
    [self.view addSubview:self.priceDup];
    [self.view addSubview:self.payView];
    
    [self.price mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.view.mas_centerX).offset(offsetx);
        make.top.equalTo(self.view.mas_top).offset(20);
    }];
    [self.priceDup mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.price.mas_centerY);
        make.left.equalTo(self.price.mas_right).offset(5);
    }];
    [self.payView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.price.mas_bottom).offset(50);
        make.left.equalTo(self.view.mas_left);
        make.bottom.equalTo(self.view.mas_bottom);
        make.right.equalTo(self.view.mas_right);
    }];
    

//    [self.payView.textField becomeFirstResponder];
    
}

- (UILabel *)price{
    if (_price == nil) {
        _price = [[UILabel alloc] init];
        [_price setTextColor:[UIColor colorWithHexString:colorb]];
        [_price setFont:[UIFont systemFontOfSize:fontb]];
    }
    return _price;
}
- (UILabel *)priceDup{
    if (_priceDup == nil) {
        _priceDup = [[UILabel alloc] init];
        [_priceDup setTextColor:[UIColor colorWithHexString:colorb]];
        [_priceDup setFont:[UIFont systemFontOfSize:fonts]];
    }
    return _priceDup;
}
- (ECRTopupFieldView *)payView{
    if (_payView == nil) {
        _payView = [[ECRTopupFieldView alloc] init];
        _payView.textFontSize = 14;
        _payView.buttonTitle = @"支付";
        _payView.textField.keyboardType = UIKeyboardTypePhonePad;
    }
    return _payView;
}


@end
