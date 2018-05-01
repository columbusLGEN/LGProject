//
//  EDJHomeHeaderView.h
//  HBDJProj
//
//  Created by Peanut Lee on 2018/4/2.
//  Copyright © 2018年 Lee. All rights reserved.
//

#import "LGBaseView.h"
#import "LGNavigationSearchBar.h"
@class LGSegmentControl;

@protocol EDJHomeHeaderViewDelegate;

@interface EDJHomeHeaderView : LGBaseView

+ (CGFloat)headerHeight;
@property (strong,nonatomic) LGNavigationSearchBar *nav;
@property (nonatomic) NSArray<NSString *> *imgURLStrings;
@property (strong,nonatomic) LGSegmentControl *segment;
@property (weak,nonatomic) id<EDJHomeHeaderViewDelegate> delegate;

@end

@protocol EDJHomeHeaderViewDelegate <NSObject>
@optional
- (void)headerImgLoopClick:(EDJHomeHeaderView *)header didSelectItemAtIndex:(NSInteger)index;

@end
