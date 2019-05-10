//
//  UIViewController+LGExtension.m
//  TimeCollege
//
//  Created by Peanut Lee on 2019/5/10.
//  Copyright © 2019 lee. All rights reserved.
//

#import "UIViewController+LGExtension.h"

@implementation UIViewController (LGExtension)

- (void)addNavSearch{
    /// 搜索按钮
    UIBarButtonItem *right = [UIBarButtonItem.alloc initWithImage:[UIImage imageNamed:@"icon_search_white"] style:UIBarButtonItemStyleDone target:self action:@selector(searchMyBookrack)];
    self.navigationItem.rightBarButtonItem = right;
}

@end
