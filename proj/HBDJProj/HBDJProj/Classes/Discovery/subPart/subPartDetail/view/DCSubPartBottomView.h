//
//  DCSubPartBottomView.h
//  HBDJProj
//
//  Created by Peanut Lee on 2018/5/8.
//  Copyright © 2018年 Lee. All rights reserved.
//

#import "LGBaseView.h"

typedef NS_ENUM(NSUInteger, SubPartyBottomAction) {
    SubPartyBottomActionLike,
    SubPartyBottomActionCollect,
};

@protocol DCSubPartBottomViewDelegate;

@interface DCSubPartBottomView : LGBaseView

@property (weak,nonatomic) id<DCSubPartBottomViewDelegate> delegate;
+ (instancetype)sbBottom;

@end

@protocol DCSubPartBottomViewDelegate <NSObject>
- (void)sbBottomActionClick:(DCSubPartBottomView *)sbBottom action:(SubPartyBottomAction)action;

@end
