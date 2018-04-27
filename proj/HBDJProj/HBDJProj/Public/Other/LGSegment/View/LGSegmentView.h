//
//  LGSegmentView.h
//  HBDJProj
//
//  Created by Peanut Lee on 2018/4/20.
//  Copyright © 2018年 Lee. All rights reserved.
//

#import "LGBaseView.h"
@protocol LGSegmentViewDelegate;

@interface LGSegmentView : LGBaseView
- (instancetype)initWithSegmentItems:(NSArray<NSDictionary *> *)items;
- (void)setFlyLocationWithIndex:(NSInteger)index;
@property (weak,nonatomic) id<LGSegmentViewDelegate> delegate;
@end

@protocol LGSegmentViewDelegate <NSObject>
- (void)segmentView:(LGSegmentView *)segmentView click:(NSInteger)click;
@end
