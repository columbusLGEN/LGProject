//
//  ECRRequestFailuredView.h
//  EasyChineseReading-ios
//
//  Created by Peanut Lee on 2017/10/18.
//  Copyright © 2017年 retech. All rights reserved.
//

/**
 空页面类型
 
 - ECRRFViewEmptyTypeDisconnect: 网络错误
 - ECRRFViewEmptyTypeCartEmpty: 购物车为空
 - ECRRFViewEmptyTypeBookrackEmpty: 书架为空
 */
typedef NS_ENUM(NSUInteger, ECRRFViewEmptyType) {
    ECRRFViewEmptyTypeDisconnect,
    ECRRFViewEmptyTypeCartEmpty,
    ECRRFViewEmptyTypeBookrackEmpty,
    ECRRFViewEmptyTypeNotLogIn,
    ECRRFViewEmptyTypeNoComments,
    ECRRFViewEmptyTypeNoJuan,
    ECRRFViewEmptyTypeClassifyNoData,
    ECRRFViewEmptyTypeNoAccess
};

#import "ECRBaseView.h"
@class ECRRequestFailuredView;
@protocol ECRRequestFailuredViewDelegate;

@interface ECRRequestFailuredView : ECRBaseView

/** 空页面类型 */
@property (assign,nonatomic) ECRRFViewEmptyType emptyType;

@property (weak,nonatomic) id<ECRRequestFailuredViewDelegate> delegate;//
- (instancetype)requestFailuredViewWithFrame:(CGRect)frame clickBlock:(void(^)())block;

@end

@protocol ECRRequestFailuredViewDelegate <NSObject>
- (void)rfViewReloadData:(ECRRequestFailuredView *)view eType:(ECRRFViewEmptyType)etype;

@end

