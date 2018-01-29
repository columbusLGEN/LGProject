//
//  ECRHomeTitleView.h
//  EasyChineseReading-ios
//
//  Created by lee on 2017/8/30.
//  Copyright © 2017年 lee. All rights reserved.
//

#import "ECRBaseView.h"

@class LGCartIcon;

typedef NS_ENUM(NSUInteger, ECRHomeTitleViewBgdsState) {
    ECRHomeTitleViewBgdsStateDefault,/// 透明状态
    ECRHomeTitleViewBgdsStateSolid,/// 不透明状态
};

@class ECRHomeTitleView;

@protocol ECRHomeTitleViewDelelgate <NSObject>

@optional
/**
 开始搜索

 @param titleView self
 */
- (void)htViewBeginSearch:(ECRHomeTitleView *)titleView;

/**
 点击购物车

 @param titlView self
 @param param 预留参数
 */
- (void)htView:(ECRHomeTitleView *)titlView sCarClick:(id)param;
- (void)htViewRgLocated:(ECRHomeTitleView *)titleView cnBlock:(void(^)(NSString *country))cnBlock;// cn = country name

@end

@interface ECRHomeTitleView : ECRBaseView

/** 购物车按钮 */
@property (strong,nonatomic) LGCartIcon *cartButton;

@property (assign,nonatomic) ECRHomeTitleViewBgdsState bgdsState;

@property (copy,nonatomic) NSString *title;
@property (strong,nonatomic) UILabel *contryName;//
@property (weak,nonatomic) id<ECRHomeTitleViewDelelgate> delegate;
@property (copy,nonatomic) NSString *defaultLocText;

@end
