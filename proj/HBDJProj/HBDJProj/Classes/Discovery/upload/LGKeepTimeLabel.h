//
//  LGKeepTimeLabel.h
//  HBDJProj
//
//  Created by Peanut Lee on 2018/8/20.
//  Copyright © 2018年 Lee. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface LGKeepTimeLabel : UILabel
- (void)fire;
- (void)pause;
- (void)stop;
- (instancetype)initWithFrame:(CGRect)frame sec:(NSInteger)sec;

@end
