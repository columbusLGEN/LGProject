//
//  ECRBookrackNavMenuView.h
//  EasyChineseReading-ios
//
//  Created by Peanut Lee on 2017/9/21.
//  Copyright © 2017年 retech. All rights reserved.
//

#import "ECRBaseView.h"
@class ECRBookrackNavMenuView;

@protocol ECRBookrackNavMenuViewDelegate <NSObject>

- (void)brnmView:(ECRBookrackNavMenuView *)view tb:(BOOL)tb;// 0上。1下。
- (void)closeBrnmView:(ECRBookrackNavMenuView *)view;

@end

@interface ECRBookrackNavMenuView : ECRBaseView

@property (weak,nonatomic) id<ECRBookrackNavMenuViewDelegate> delegate;// <##>
+ (instancetype)bookrackNavMenuView;

@end
