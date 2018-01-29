//
//  FirstLaunchCountryVC.h
//  EasyChineseReading-ios
//
//  Created by 赵春阳 on 2017/11/22.
//  Copyright © 2017年 retech. All rights reserved.
//

#import "ECRBaseViewController.h"

@class FirstLaunchCountryVC;

@protocol FirstLaunchCountryVCDelegate <NSObject>

- (void)dissmissLaunchView;

@end

@interface FirstLaunchCountryVC : ECRBaseViewController

@property (weak, nonatomic) id<FirstLaunchCountryVCDelegate> delegate;

@end
