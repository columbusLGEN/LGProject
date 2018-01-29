//
//  ZAppStore.m
//  EasyChineseReading-ios
//
//  Created by 赵春阳 on 2017/11/27.
//  Copyright © 2017年 retech. All rights reserved.
//

#import "ZAppStore.h"

#import <StoreKit/StoreKit.h> // AppStore 支付 必须引用

/** 沙盒测试环境验证 */
#define SandBox  @"https://sandbox.itunes.apple.com/verifyReceipt"
/** 正式环境验证 */
#define AppStore @"https://buy.itunes.apple.com/verifyReceipt"

@interface ZAppStore () <SKPaymentTransactionObserver, SKProductsRequestDelegate>

@property (strong, nonatomic) NSString *productsId; // 商品id
@property (strong, nonatomic) UIViewController *viewConstroller; // 使用app内购的控制器

@end

@implementation ZAppStore

#pragma mark - 根据商品 id 购买
+ (void)buyProductsWithId:(NSString *)productsId viewController:(UIViewController *)viewController {
    [self buyProductsWithId:productsId viewController:viewController];
}

- (void)buyProductsWithId:(NSString *)productsId viewController:(UIViewController *)viewController {
    self.productsId = productsId;
    _viewConstroller = viewController;
    // 添加观察者
    [[SKPaymentQueue defaultQueue] addTransactionObserver:self];
    // 检查是否能够使用app内购
    if ([SKPaymentQueue canMakePayments])
        [self requestProductData:@[self.productsId]];
    else
        [_viewConstroller presentFailureTips:LOCALIZATION(@"您的手机没有打开程序内付费购买")];
}

// iTunes Connect里面提取产品列表
- (void)requestProductData:(NSArray *)data {
    NSLog(@"-------请求对应的产品信息--------");
    NSSet *requestSet = [NSSet setWithArray:data];
    SKProductsRequest *request = [[SKProductsRequest alloc] initWithProductIdentifiers:requestSet];
    request.delegate = self;
    [request start];
}

// SKProductsRequestDelegate 会接收到请求响应，在此回调中，发送购买请求. 收到产品返回信息
- (void)productsRequest:(SKProductsRequest *)request didReceiveResponse:(SKProductsResponse *)response {
    NSLog(@"-------收到产品反馈消息--------");
    NSArray *products = response.products;
    if([products count] == 0){
        NSLog(@"----------没有商品----------");
        [self alertFailed];
        return;
    }
    
    NSLog(@"productID:%@", response.invalidProductIdentifiers);
    NSLog(@"产品付费数量:%lu",(unsigned long)[products count]);
    
    SKProduct *p = nil;
    for (SKProduct *product in products) {
        NSLog(@"product description %@", [product description]);
        NSLog(@"product localizedTitle %@", [product localizedTitle]);
        NSLog(@"product localizedDescription %@", [product localizedDescription]);
        NSLog(@"product price %@", [product price]);
        NSLog(@"product productIdentifier %@", [product productIdentifier]);
        
        if ([product.productIdentifier isEqualToString:_productsId])
            p = product;
    }
    if (!p) {
        [self alertFailed];
        return;
    }
    NSLog(@"发送购买请求");
    SKPayment *payment = [SKPayment paymentWithProduct:p];
    [[SKPaymentQueue defaultQueue] addPayment:payment];
}

#pragma mark - 请求商品失败
- (void)request:(SKRequest *)request didFailWithError:(NSError *)error {
    [self alertFailed];
    NSLog(@"--------请求商品失败------:%@", error);
}

- (void)requestDidFinish:(SKRequest *)request {
    NSLog(@"---------反馈信息结束----------");
}

#pragma mark - 监听购买结果
- (void)paymentQueue:(SKPaymentQueue *)queue updatedTransactions:(NSArray *)transactions {
    // 发送到苹果服务器验证凭证
    for(SKPaymentTransaction *transaction in transactions){
        switch (transaction.transactionState) {
            case SKPaymentTransactionStatePurchased: // 交易完成
                [self completeTransaction:transaction];
                break;
            case SKPaymentTransactionStatePurchasing:// 商品添加到列表
                [self failedTransaction:transaction];
                break;
            case SKPaymentTransactionStateRestored:  // 购买过商品
                [self restoreTransaction:transaction];
                break;
            case SKPaymentTransactionStateFailed:    // 购买商品失败
                [self failedTransaction:transaction];
                break;
            default:
                break;
        }
    }
}

#pragma mark - 交易失败
- (void)failedTransaction:(SKPaymentTransaction *)transaction{
    [self alertFailed];
    [self finishTransaction:transaction];
}

/** 提示支付失败 */
- (void)alertFailed {
    [_viewConstroller presentFailureTips:LOCALIZATION(@"支付失败")];
}

#pragma mark - 交易恢复处理
- (void)restoreTransaction:(SKPaymentTransaction *)transaction {
    NSLog(@"交易恢复处理");
}

#pragma mark - 交易结束
/** 交易结束后需要验证购买，避免越狱软件模拟苹果请求达到非法购买问题或其他问题引起的数据错误导致损失 */
- (void)completeTransaction:(SKPaymentTransaction *)transaction {
    // 从沙盒中获取交易凭证并且拼接成请求体数据
    NSURL *receiptUrl = [[NSBundle mainBundle] appStoreReceiptURL];
    NSData *receiptData = [NSData dataWithContentsOfURL:receiptUrl];
    if (!receiptData) {
        [self failedTransaction:transaction];
        return;
    }
    // 转化为base64字符串
    NSString *receiptString = [receiptData base64EncodedStringWithOptions:NSDataBase64EncodingEndLineWithLineFeed];
    NSString *bodyString = [NSString stringWithFormat:@"{\"receipt-data\" : \"%@\"}", receiptString];//拼接请求数据
    // 再转换为字符串,来发送请求
    NSData *bodyData = [bodyString dataUsingEncoding:NSUTF8StringEncoding];
    
    // 创建请求到苹果官方进行购买验证
    NSURL *url = [NSURL URLWithString:SandBox];
    NSMutableURLRequest *requestM = [NSMutableURLRequest requestWithURL:url];
    requestM.HTTPBody = bodyData;
    requestM.HTTPMethod = @"POST";
    // 创建连接并发送同步请求
    NSError *error = nil;
    NSData *responseData = [NSURLConnection sendSynchronousRequest:requestM returningResponse:nil error:&error];
    if (error) {
        NSLog(@"验证购买过程中发生错误，错误信息：%@",error.localizedDescription);
        [self failedTransaction:transaction];
        return;
    }
    NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:responseData options:NSJSONReadingAllowFragments error:nil];
    NSLog(@"%@",dic);
    if ([dic[@"status"] intValue] == 0) {
        NSLog(@"购买成功！");
//        NSDictionary *dicReceipt = dic[@"receipt"];
//        NSDictionary *dicInApp = [dicReceipt[@"in_app"] firstObject];
//        NSString *productIdentifier = dicInApp[@"product_id"];//读取产品标识
//        // 如果是消耗品则记录购买数量，非消耗品则记录是否购买过
//        NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
//        if ([productIdentifier isEqualToString:@"123"]) {
//            NSInteger purchasedCount = [defaults integerForKey:productIdentifier]; //已购买数量
//            [[NSUserDefaults standardUserDefaults] setInteger:(purchasedCount + 1) forKey:productIdentifier];
//        }
//        else {
//            [defaults setBool:YES forKey:productIdentifier];
//        }
        //在此处对购买记录进行存储，可以存储到开发商的服务器端
        
        [self finishTransaction:transaction];
    }
    else {
        NSLog(@"购买失败，未通过验证！");
        [self failedTransaction:transaction];
    }
}

#pragma mark - 交易结束
- (void)finishTransaction:(SKPaymentTransaction *)transaction {
    [[SKPaymentQueue defaultQueue] finishTransaction:transaction];
    // 移除观察者
    [[SKPaymentQueue defaultQueue] removeTransactionObserver:self];
}

@end
