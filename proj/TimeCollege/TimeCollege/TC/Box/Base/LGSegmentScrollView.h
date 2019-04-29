//
//  LGSegmentView.h
//  HBDJProj
//
//  Created by Peanut Lee on 2018/4/20.
//  Copyright © 2018年 Lee. All rights reserved.
//

#import <UIKit/UIKit.h>
@protocol LGSegmentScrollViewDelegate;

@interface LGSegmentScrollView : UIView

/** 初始化，传入字符串数组即可 */
- (instancetype)initWithSegmentItems:(NSArray<NSString *> *)items frame:(CGRect)frame;
/** 根据index切换 */
- (void)setFlyLocationWithIndex:(NSInteger)index;
@property (weak,nonatomic) id<LGSegmentScrollViewDelegate> delegate;

@end

@protocol LGSegmentScrollViewDelegate <NSObject>
/** 通知代理，切换到了 index */
- (void)segmentView:(LGSegmentScrollView *)segmentView index:(NSInteger)index;

@end
