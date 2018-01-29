//
//  UIView+Data.m
//  EasyChineseReading-ios
//
//  Created by 赵春阳 on 17/8/30.
//  Copyright © 2017年 lee. All rights reserved.
//

#import "UIView+Data.h"
#import <objc/runtime.h>

static const char kUIViewDataKey;

@implementation UIView(Data)

@dynamic data;

- (void)setData:(id)data {
    [self dataWillChange];
    
    objc_setAssociatedObject(self, &kUIViewDataKey, data, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    
    [self dataDidChange];
}

- (id)data {
    return objc_getAssociatedObject(self, &kUIViewDataKey);
}

- (void)dataWillChange {
    
}

- (void)dataDidChange {
    
}

- (UIViewController *)getSuperViewController
{
    for (UIView *next = [self superview]; next; next = next.superview)
    {
        UIResponder* nextResponder = [next nextResponder];
        if ([nextResponder isKindOfClass:[UIViewController class]])
        {
            return (UIViewController*)nextResponder;
        }
    }
    return nil;
}

@end
