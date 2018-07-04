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

@end

@interface DJSelectDateViewController : LGBaseViewController
@property (weak,nonatomic) id<DJSelectDateViewControllerDelegate> delegate;

@end
