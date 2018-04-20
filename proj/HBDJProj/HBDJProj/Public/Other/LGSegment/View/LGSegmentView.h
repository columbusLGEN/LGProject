//
//  LGSegmentView.h
//  HBDJProj
//
//  Created by Peanut Lee on 2018/4/20.
//  Copyright © 2018年 Lee. All rights reserved.
//

#import "LGBaseView.h"

@interface LGSegmentView : LGBaseView
- (instancetype)initWithSegmentItems:(NSArray<NSString *> *)items;
- (void)setFlyLocationWithIndex:(NSInteger)index;
@end
