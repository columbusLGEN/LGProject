//
//  ZApplePay.m
//  EasyChineseReading-ios
//
//  Created by 赵春阳 on 2017/11/27.
//  Copyright © 2017年 retech. All rights reserved.
//

#import "ZApplePay.h"

#import <PassKit/PassKit.h>                                 //用户绑定的银行卡信息
#import <PassKit/PKPaymentAuthorizationViewController.h>    //Apple pay的展示控件
#import <AddressBook/AddressBook.h>                         //用户联系信息相关

@implementation ZApplePay
//
//- (void)applePayHandle
//{
//    // 是否支持ApplePay
//    if ([PKPaymentAuthorizationViewController canMakePayments]) {
//        if (![PKPaymentAuthorizationViewController class]) {
//            //PKPaymentAuthorizationViewController需iOS8.0以上支持
//            [self presentFailureTips:LOCALIZATION(@"操作系统不支持ApplePay，请升级至9.0以上版本，且iPhone6以上设备才支持")];
//            return;
//        }
//        //检查当前设备是否可以支付
//        if (![PKPaymentAuthorizationViewController canMakePayments]) {
//            //支付需iOS9.0以上支持
//            [self presentFailureTips:LOCALIZATION(@"操作系统不支持ApplePay，请升级至9.0以上版本，且iPhone6以上设备才支持")];
//            return;
//        }
//        //检查用户是否可进行某种卡的支付，是否支持Amex、MasterCard、Visa与银联四种卡，根据自己项目的需要进行检测
//        NSArray *supportedNetworks = @[PKPaymentNetworkAmex,            // 美国运通卡
//                                       PKPaymentNetworkMasterCard,      // Master卡
//                                       PKPaymentNetworkVisa,            // Visa卡
//                                       PKPaymentNetworkChinaUnionPay];  // 中国银联卡
//        // 判断 设备上用户有没有添加银行卡，如果没添加，不写这个判断，真机上会crash。
//        if (![PKPaymentAuthorizationViewController canMakePaymentsUsingNetworks:supportedNetworks]) {
//            [self presentFailureTips:LOCALIZATION(@"还没有绑定支付卡, 请先到 wallet 绑定支付卡")];
//            return;
//        }
//
//        // 支付类目及额度
//        PKPaymentRequest *request = [[PKPaymentRequest alloc] init];
//
//        PKPaymentSummaryItem *widget1 = [PKPaymentSummaryItem
//                                         summaryItemWithLabel:@"Widget 1"
//                                         amount:[NSDecimalNumber decimalNumberWithString:@"0.01"]];
//
//        PKPaymentSummaryItem *widget2 = [PKPaymentSummaryItem
//                                         summaryItemWithLabel:@"Widget 2"
//                                         amount:[NSDecimalNumber decimalNumberWithString:@"0.01"]];
//
//        PKPaymentSummaryItem *total = [PKPaymentSummaryItem
//                                       summaryItemWithLabel:@"Grand Total"
//                                       amount:[NSDecimalNumber decimalNumberWithString:@"0.02"]];
//
//        request.paymentSummaryItems = @[widget1, widget2, total];
//        // 国家码
//        request.countryCode = @"CN";
//        // 币种 (CNY 人民币)
//        request.currencyCode = @"CHW";
//
//        //能支付的币种
//        request.supportedNetworks = @[
//                                      PKPaymentNetworkChinaUnionPay,
//                                      PKPaymentNetworkMasterCard,
//                                      PKPaymentNetworkVisa
//                                      ];
//
//        //Merchant ID
//        request.merchantIdentifier = @"merchant.com.retech.EasyChineseReading.applepay";
//
//        // 询问你的付款处理器 （PKMerchantCapabilityCredit
//        // 信用卡，PKMerchantCapabilityDebit 借记卡）
//
//        /*
//         PKMerchantCapabilityCredit NS_ENUM_AVAILABLE_IOS(9_0)   = 1UL << 2,   //
//         支持信用卡
//         PKMerchantCapabilityDebit  NS_ENUM_AVAILABLE_IOS(9_0)   = 1UL << 3    //
//         支持借记卡
//         */
//        request.merchantCapabilities = PKMerchantCapabilityDebit;
//        // 添加联系人全部信息
//        request.requiredShippingAddressFields = PKAddressFieldAll;
//
//        // 调用 PKPaymentAuthorizationViewController
//        PKPaymentAuthorizationViewController *paymentPane = [[PKPaymentAuthorizationViewController alloc] initWithPaymentRequest:request];
//        paymentPane.delegate = self;
//        [self presentViewController:paymentPane animated:TRUE completion:nil];
//
//    } else {
//        [self presentFailureTips:LOCALIZATION(@"你的设备目前还不支持 applepay 支付")];
//        return;
//    }
//}
//
//#pragma mark PKPaymentAuthorizationViewControllerDelegate
//
//- (void)paymentAuthorizationViewController:(PKPaymentAuthorizationViewController *)controller didAuthorizePayment:(PKPayment *)payment completion:(void (^)(PKPaymentAuthorizationStatus status))completion {
//    NSLog(@"Payment was authorized: %@", payment);
//
////    -- PKPayment 对象
////    token 支付成功之后的回执，需要上传给服务器。
////    billingAddress 用户账单地址
////    billingContact 用户账单信息
////    shippingAddress 送货地址
////    shippingContact 送货信息
////    shippingMethod 送货方式
//
//    BOOL asyncSuccessful = FALSE;
//
//    if (asyncSuccessful) {
//        completion(PKPaymentAuthorizationStatusSuccess);
//        NSLog(@"支付成功");
//    }
//    else {
//        completion(PKPaymentAuthorizationStatusFailure);
//        NSLog(@"支付失败");
//    }
//}
//
//- (void)paymentAuthorizationViewControllerDidFinish:(PKPaymentAuthorizationViewController *)controller {
//    // hide the payment window
//    [controller dismissViewControllerAnimated:TRUE completion:nil];
//}

@end
