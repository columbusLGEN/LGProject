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
/** 点击最有边的按钮 */
- (void)navRightButtonClick:(LGNavigationSearchBar *)navigationSearchBar;
/** 点击最左边的按钮 */
- (void)leftButtonClick:(LGNavigationSearchBar *)navigationSearchBar;
/** 点击语音搜索 */
- (void)voiceButtonClick:(LGNavigationSearchBar *)navigationSearchBar;

@end

@interface LGNavigationSearchBar : LGBaseView

/** 是否处于搜索内容输入状态 */
@property (assign,nonatomic) BOOL isEditing;
/** 搜索按钮 */
@property (strong,nonatomic) UIButton *fakeSearch;

@property (assign,nonatomic) NavState bgdsState;

@property (weak,nonatomic) id<LGNavigationSearchBarDelelgate> delegate;

@property (assign,nonatomic) BOOL isShowRightBtn;
@property (copy,nonatomic) NSString *rightButtonTitle;

@property (weak,nonatomic) NSString *leftImgName;

CGFloat navHeight(void);

@end
