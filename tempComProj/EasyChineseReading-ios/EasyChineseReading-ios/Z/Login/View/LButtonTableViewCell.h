//
//  LButtonTableViewCell.h
//  EasyChineseReading-ios
//
//  Created by 赵春阳 on 2017/9/8.
//  Copyright © 2017年 lee. All rights reserved.
//

#import <UIKit/UIKit.h>

@class LButtonTableViewCell;

@protocol LButtonTableViewCellDelegate <NSObject>

/** 登录 */
- (void)login;

@end

@interface LButtonTableViewCell : ECRBaseTableViewCell

/** 代理 */
@property (weak, nonatomic) id<LButtonTableViewCellDelegate> delegate;
@property (weak, nonatomic) IBOutlet UIButton *btnLogin;

/**
 改变登录按键的可点击状态

 @param btnEnable 是否可点击
 */
- (void)updateButtonEnable:(BOOL)btnEnable;

@end
