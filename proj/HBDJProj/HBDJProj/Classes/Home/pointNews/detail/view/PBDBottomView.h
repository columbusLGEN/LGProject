//
//  PBDBottomView.h
//  HBDJProj
//
//  Created by Peanut Lee on 2018/5/9.
//  Copyright © 2018年 Lee. All rights reserved.
//

#import "LGBaseView.h"

typedef NS_ENUM(NSUInteger, PBDBottomAction) {
    PBDBottomActionLike,
    PBDBottomActionCollect,
    PBDBottomActionShare,
};

@protocol PBDBottomViewDelegate;

@interface PBDBottomView : LGBaseView

+ (instancetype)pbdBottom;
@property (weak,nonatomic) id<PBDBottomViewDelegate> delegate;

@end

@protocol PBDBottomViewDelegate <NSObject>
- (void)pbdBottomClick:(PBDBottomView *)bottomView action:(PBDBottomAction)action;

@end
