//
//  DJSelectDateViewController.h
//  HBDJProj
//
//  Created by Peanut Lee on 2018/7/4.
//  Copyright © 2018年 Lee. All rights reserved.
//

#import "LGBaseViewController.h"

@class DJSelectDateViewController;

@protocol DJSelectDateViewControllerDelegate <NSObject>
- (void)selectDate:(DJSelectDateViewController *)vc dateString:(NSString *)dateString cellIndex:(NSIndexPath *)cellIndex;

@end

@interface DJSelectDateViewController : LGBaseViewController
// TODO:Zup_添加时间限定
@property (assign,nonatomic) BOOL lastMonth;// 只能选择上一个月
@property (strong,nonatomic) NSIndexPath *cellIndex;
@property (weak,nonatomic) id<DJSelectDateViewControllerDelegate> delegate;

@end
