//
//  EDJHomeHeaderView.h
//  HBDJProj
//
//  Created by Peanut Lee on 2018/4/2.
//  Copyright © 2018年 Lee. All rights reserved.
//

#import "LGBaseView.h"
#import "EDJHomeNav.h"
@class LGSegmentControl;

@interface EDJHomeHeaderView : LGBaseView

+ (CGFloat)headerHeight;
@property (strong,nonatomic) EDJHomeNav *nav;
@property (nonatomic) NSArray<NSString *> *imgURLStrings;
@property (strong,nonatomic) LGSegmentControl *segment;

@end
