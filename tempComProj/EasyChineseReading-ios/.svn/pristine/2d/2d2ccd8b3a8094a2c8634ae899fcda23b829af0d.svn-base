//
//  UITableViewCell+SeparatorInset.m
//  EasyChineseReading-ios
//
//  Created by 赵春阳 on 17/8/30.
//  Copyright © 2017年 lee. All rights reserved.
//

#import "UITableViewCell+SeparatorInset.h"

@implementation UITableViewCell(SeparatorInset)

- (void)setCellSeparatorInset:(UIEdgeInsets)separatorInset
{
    if ([self respondsToSelector:@selector(setSeparatorInset:)]) {
        [self setSeparatorInset:separatorInset];
    }
    if ([self respondsToSelector:@selector(setLayoutMargins:)]) {
        [self setLayoutMargins:separatorInset];
    }
}

@end
