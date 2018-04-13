//
//  LGPageView.h
//  RGTestPorject
//
//  Created by Peanut Lee on 2018/4/13.
//  Copyright © 2018年 Lee. All rights reserved.
//

#import <UIKit/UIKit.h>

@class LGSegmentControl;

@interface LGPageView : UIView


- (instancetype)initWithFrame:(CGRect)frame mainViewController:(UIViewController *)mainViewController viewControllers:(NSArray<UIViewController *> *)viewControllers;

@end
