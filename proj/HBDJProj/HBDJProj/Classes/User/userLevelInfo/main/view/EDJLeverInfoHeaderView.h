//
//  EDJLeverInfoHeaderView.h
//  HBDJProj
//
//  Created by Peanut Lee on 2018/4/18.
//  Copyright © 2018年 Lee. All rights reserved.
//

#import "LGBaseView.h"

@class DJLevelHomeModel;

@protocol EDJLeverInfoHeaderViewDelegate;

@interface EDJLeverInfoHeaderView : LGBaseView
+ (instancetype)levelInfoHeader;
@property (weak,nonatomic) id<EDJLeverInfoHeaderViewDelegate> delegate;
@property (strong,nonatomic) DJLevelHomeModel *model;

@end

@protocol EDJLeverInfoHeaderViewDelegate <NSObject>

/** tag: 1=等级介绍,0=今日加分 */
- (void)levelInfoHeaderCLick:(EDJLeverInfoHeaderView *)header itemTag:(NSInteger)tag;

@end
