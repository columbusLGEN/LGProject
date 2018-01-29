//
//  ECRBookFormViewController.h
//  EasyChineseReading-ios
//
//  Created by Peanut Lee on 2017/9/27.
//  Copyright © 2017年 retech. All rights reserved.

//  订单明细页面

#import "ECRBaseViewController.h"
@class ECRShoppingCarModel,ECRFullminusModel,ECRBookFormViewController;

@protocol ECRBookFormViewControllerDelegate <NSObject>

@optional
- (void)payDoneCallback:(ECRBookFormViewController *)vc;

@end

@interface ECRBookFormViewController : ECRBaseViewController

//3. 勾选的商品
@property (strong,nonatomic) NSArray<ECRShoppingCarModel *> *tickedArray;//
//4. 勾选商品总价
@property (assign,nonatomic) CGFloat tickedPrice;//

/// 订单id
@property (strong,nonatomic) NSString *orderId;/// 订单id

@property (weak,nonatomic) id<ECRBookFormViewControllerDelegate> delegate;//

@end
