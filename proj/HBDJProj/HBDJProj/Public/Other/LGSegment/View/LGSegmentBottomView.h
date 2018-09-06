//
//  LGSegmentBottomView.h
//  HBDJProj
//
//  Created by Peanut Lee on 2018/5/9.
//  Copyright © 2018年 Lee. All rights reserved.
//

// 全选底部view

#import "LGBaseView.h"

@protocol LGSegmentBottomViewDelegate;

@interface LGSegmentBottomView : LGBaseView

/** 全选按钮状态 */
@property (assign,nonatomic) BOOL asbState;
@property (weak,nonatomic) id<LGSegmentBottomViewDelegate> delegate;
+ (CGFloat)bottomHeight;
+ (instancetype)segmentBottom;
@end

@protocol LGSegmentBottomViewDelegate <NSObject>
- (void)segmentBottomAll:(LGSegmentBottomView *)bottom;
- (void)segmentBottomDelete:(LGSegmentBottomView *)bottom;

@end
