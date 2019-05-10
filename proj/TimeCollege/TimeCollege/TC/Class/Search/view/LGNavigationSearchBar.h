//
//  ECRHomeTitleView.h
//  EasyChineseReading-ios
//
//  Created by lee on 2017/8/30.
//  Copyright © 2017年 lee. All rights reserved.
//

#import <UIKit/UIKit.h>

@class LGNavigationSearchBar;

typedef NS_ENUM(NSUInteger, NavState) {
    NavStateDefault,/// 透明状态
    NavStateSolid,/// 不透明状态
};

@protocol LGNavigationSearchBarDelelgate <NSObject>

/** 返回 */
- (void)leftButtonClick:(LGNavigationSearchBar *)navigationSearchBar;

@optional
/** 开始搜索 */
- (void)navSearchClick:(LGNavigationSearchBar *)navigationSearchBar;

@end

@interface LGNavigationSearchBar : UIView

/** 是否处于搜索内容输入状态 */
@property (assign,nonatomic) BOOL isEditing;
/** 搜索按钮 */
@property (strong,nonatomic) UIButton *fakeSearch;

@property (weak,nonatomic) id<LGNavigationSearchBarDelelgate> delegate;

@property (weak,nonatomic) NSString *leftImgName;

CGFloat navHeight(void);

@end
