//
//  ZAnimationTips.m
//  EasyChineseReading-ios
//
//  Created by 赵春阳 on 2017/12/2.
//  Copyright © 2017年 retech. All rights reserved.
//

#import "ZAnimationTips.h"

@interface ZAnimationTips ()

@end

@implementation ZAnimationTips

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor cm_blackColor_000000_2F];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/**
 点击空白
 */
- (void)touchesEnded:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    UITouch *touch = [touches anyObject];
    UIView *view = touch.view;
    
    if (view == self.view) {
        [self hidden];
    }
}

- (void)hidden
{
    [self dismissViewControllerAnimated:YES completion:nil];
}

@end
