//
//  LGSegmentBottomView.h
//  HBDJProj
//
//  Created by Peanut Lee on 2018/5/9.
//  Copyright © 2018年 Lee. All rights reserved.
//

#import "LGBaseView.h"

@protocol LGSegmentBottomViewDelegate;

@interface LGSegmentBottomView : LGBaseView

@property (weak,nonatomic) id<LGSegmentBottomViewDelegate> delegate;
+ (instancetype)segmentBottom;
@end

@protocol LGSegmentBottomViewDelegate <NSObject>
- (void)segmentBottomAll:(LGSegmentBottomView *)bottom;
- (void)segmentBottomDelete:(LGSegmentBottomView *)bottom;

@end
