//
//  LIGBaseViewController.h
//  HBDJProj
//
//  Created by Peanut Lee on 2018/4/2.
//  Copyright © 2018年 Lee. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface LIGBaseViewController : UIViewController

/** 数据 */
@property (strong,nonatomic) id data;
- (instancetype)viewControllerWithData:(id)data;

@end
