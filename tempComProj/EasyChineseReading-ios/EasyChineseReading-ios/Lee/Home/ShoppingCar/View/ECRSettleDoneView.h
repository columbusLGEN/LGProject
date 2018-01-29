//
//  ECRSettleDoneView.h
//  EasyChineseReading-ios
//
//  Created by lee on 2017/8/31.
//  Copyright © 2017年 lee. All rights reserved.
//

#import "ECRBaseView.h"
@class ECRSettleDoneView;

@protocol ECRSettleDoneViewDelegate <NSObject>

- (void)sdView:(ECRSettleDoneView *)sdView;
- (void)sdViewAllSelected:(ECRSettleDoneView *)sdView;
- (void)sdViewAllRemoveFormCar:(ECRSettleDoneView *)sdView;

@end

@interface ECRSettleDoneView : ECRBaseView

@property (assign,nonatomic) CGFloat price;// 结算总价
@property (weak,nonatomic) id<ECRSettleDoneViewDelegate> delegate;
- (void)allSelected;
- (void)allSelectedCanceled;

@end
