//
//  UIViewController+Nib.m
//  EasyChineseReading-ios
//
//  Created by 赵春阳 on 17/8/29.
//  Copyright © 2017年 lee. All rights reserved.
//

#import "UIViewController+Nib.h"

@implementation UIViewController(Nib)

+ (instancetype)loadFromNib
{
    return [[self alloc] initWithNibName:NSStringFromClass(self) bundle:nil];
}

@end
