//
//  UIViewController+Data.m
//  EasyChineseReading-ios
//
//  Created by 赵春阳 on 2017/10/11.
//  Copyright © 2017年 retech. All rights reserved.
//

#import "UIViewController+Data.h"
#import <objc/runtime.h>

static const char kUIViewDataKey;

@implementation UIViewController (Data)

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

@end
