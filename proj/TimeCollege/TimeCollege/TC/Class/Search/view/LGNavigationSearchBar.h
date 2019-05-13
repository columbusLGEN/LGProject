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

/// 左边 icon name
@property (weak,nonatomic) NSString *leftImgName;
/// 左边标题
@property (weak,nonatomic) NSString *leftTitle;
/// 右边按钮
@property (strong,nonatomic) UIButton *rightButton;

CGFloat navHeight(void);

@end
