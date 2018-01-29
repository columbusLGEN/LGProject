//
//  ECRPpvScoreView.h
//  downloadStateDemo
//
//  Created by Peanut Lee on 2017/9/28.
//  Copyright © 2017年 Lee. All rights reserved.
//

#import "ECRBaseView.h"
@class ECRRgButton;

@interface ECRPpvScoreView : ECRBaseView

/** 选中积分按钮 */
@property (strong,nonatomic) ECRRgButton *userScore;//

//@property (assgin,nonatomic) NSString *priceYu;//
@property (assign,nonatomic) NSInteger priceYu;//

/** 可以使用积分 */
@property (assign,nonatomic) NSInteger avaScore;//
@property (assign,nonatomic) NSInteger integralrate;//

/** 是否可以点击,YES:可以 NO:不可以 */
@property (assign,nonatomic) BOOL userCanCLick;//


@end
