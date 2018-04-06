//
//  UIButton+Extension.m
//  HBDJProj
//
//  Created by Peanut Lee on 2018/4/2.
//  Copyright © 2018年 Lee. All rights reserved.
//

#import "UIButton+Extension.h"
#import <objc/runtime.h>

@implementation UIButton (Extension)

/// TODO: 测试用代码
+ (void)load{
    Method init_with_frame = class_getInstanceMethod(self, @selector(initWithFrame:));
    Method lbc_init_with_frame = class_getInstanceMethod(self, @selector(lbc_initWithFrame:));
    
    method_exchangeImplementations(init_with_frame, lbc_init_with_frame);
    
}
- (instancetype)lbc_initWithFrame:(CGRect)frame{
    /// test
    self.backgroundColor = [UIColor orangeColor];
    return [self lbc_initWithFrame:frame];
}

@end
