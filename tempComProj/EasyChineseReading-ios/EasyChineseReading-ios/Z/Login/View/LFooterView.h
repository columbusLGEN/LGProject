//
//  LFooterView.h
//  EasyChineseReading-ios
//
//  Created by 赵春阳 on 2017/9/8.
//  Copyright © 2017年 lee. All rights reserved.
//

#import "ECRBaseView.h"

@class LFooterView;

@protocol LFooterViewDelegate <NSObject>

/**
 第三方登录

 @param index 第几个第三方
 */
- (void)loginByIndex:(NSInteger)index;

/** 快速注册 */
- (void)registerNow;

/** 忘记密码 */
- (void)forgetPassword;

@end

@interface LFooterView : ECRBaseView

@property (weak, nonatomic) id<LFooterViewDelegate> delegate;
/* 选择登录的类型 */
@property (assign, nonatomic) NSInteger loginType;

@end
