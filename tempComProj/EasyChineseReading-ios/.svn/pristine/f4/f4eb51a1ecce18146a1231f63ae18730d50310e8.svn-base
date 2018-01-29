//
//  UIVCRFooterRV.h
//  EasyChineseReading-ios
//
//  Created by 赵春阳 on 17/9/7.
//  Copyright © 2017年 lee. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ECRVirScoreRateModel.h"

@class UIVCRFooterRV;

@protocol UIVCRFooterRVDelegate <NSObject>

- (void)payWithMoney;

@end

@interface UIVCRFooterRV : UICollectionReusableView

@property (weak, nonatomic) id<UIVCRFooterRVDelegate> delegate;

@property (weak, nonatomic) IBOutlet UILabel *lblDescribe;

/* 花费 */
@property (assign, nonatomic) CGFloat payNum;

@property (assign, nonatomic) ENUM_PayPurpose payPurpose;

@property (assign, nonatomic) BOOL foreign; // 国外

@property (strong, nonatomic) ECRVirScoreRateModel *scoreRate; // 兑换比例

@end
