//
//  LGGaussManager.m
//  HBDJProj
//
//  Created by Peanut Lee on 2018/6/8.
//  Copyright © 2018年 Lee. All rights reserved.
//

#import "LGGaussManager.h"

@implementation LGGaussManager

+ (UIVisualEffectView *)gaussViewWithFrame:(CGRect)frame style:(UIBlurEffectStyle)style{
   return [[[LGGaussManager alloc] init] gaussViewWithFrame:frame style:style];
}
- (UIVisualEffectView *)gaussViewWithFrame:(CGRect)frame style:(UIBlurEffectStyle)style{
    /// new效果对象
    UIBlurEffect *effect = [UIBlurEffect effectWithStyle:style];
    /// new高斯view
    UIVisualEffectView *effectView = [[UIVisualEffectView alloc] initWithEffect:effect];
    effectView.frame = frame;
    return effectView;
}
@end
