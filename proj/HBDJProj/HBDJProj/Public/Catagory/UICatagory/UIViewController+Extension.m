//
//  UIViewController+Extension.m
//  HBDJProj
//
//  Created by Peanut Lee on 2018/4/12.
//  Copyright © 2018年 Lee. All rights reserved.
//

#import "UIViewController+Extension.h"

@implementation UIViewController (Extension)

- (instancetype)lgInstantiateViewControllerWithStoryboardName:(NSString *)name controllerId:(NSString *)controllerId{
    return [[UIStoryboard storyboardWithName:name bundle:nil] instantiateViewControllerWithIdentifier:controllerId];
}

- (void)lgPushViewControllerWithStoryboardName:(NSString *)name controllerId:(NSString *)controllerId animated:(BOOL)animated{
    UIViewController *vc = [self lgInstantiateViewControllerWithStoryboardName:name controllerId:controllerId];
    [self.navigationController pushViewController:vc animated:animated];
}

- (void)lgPushViewControllerWithClassName:(NSString *)className{
    UIViewController *vc = [NSClassFromString(className) new];
    vc.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:vc animated:YES];
}

@end
