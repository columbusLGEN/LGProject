//
//  ECRHomeTitleView.h
//  EasyChineseReading-ios
//
//  Created by lee on 2017/8/30.
//  Copyright © 2017年 lee. All rights reserved.
//

#import "LGBaseView.h"

@class LGNavigationSearchBar;

typedef NS_ENUM(NSUInteger, NavState) {
    NavStateDefault,/// 透明状态
    NavStateSolid,/// 不透明状态
};

@protocol LGNavigationSearchBarDelelgate <NSObject>

@optional
/**
 开始搜索

 @param navigationSearchBar self
 */
- (void)navSearchClick:(LGNavigationSearchBar *)navigationSearchBar;
- (void)navRightButtonClick:(LGNavigationSearchBar *)navigationSearchBar;

/**
 点击 语音助手

 @param titlView self
 @param param 预留参数
 */

@end

@interface LGNavigationSearchBar : LGBaseView

@property (assign,nonatomic) NavState bgdsState;

@property (weak,nonatomic) id<LGNavigationSearchBarDelelgate> delegate;

@property (assign,nonatomic) BOOL isShowRightBtn;
@property (copy,nonatomic) NSString *rightButtonTitle;

CGFloat navHeight(void);

@end
