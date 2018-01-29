//
//  RButtonTableViewCell.h
//  EasyChineseReading-ios
//
//  Created by 赵春阳 on 2017/9/8.
//  Copyright © 2017年 lee. All rights reserved.
//

#import <UIKit/UIKit.h>

@class RButtonTableViewCell;

@protocol RButtonTableViewCellDelegate <NSObject>

/** 立刻注册 */
- (void)registerNow;

@end

@interface RButtonTableViewCell : ECRBaseTableViewCell

@property (weak, nonatomic) id<RButtonTableViewCellDelegate> delegate;

/**
 改变登录按键的可点击状态
 
 @param btnEnable 是否可点击
 */
- (void)updateButtonEnable:(BOOL)btnEnable;

@end
