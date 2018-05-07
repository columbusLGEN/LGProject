//
//  OLTestResultViewController.h
//  HBDJProj
//
//  Created by Peanut Lee on 2018/5/4.
//  Copyright © 2018年 Lee. All rights reserved.
//

#import "LGBaseViewController.h"

@class OLTestResultViewController;

@protocol OLTestResultViewControllerDelegate <NSObject>
- (void)testResultVcBack:(OLTestResultViewController *)trvc;

@end

@interface OLTestResultViewController : LGBaseViewController
@property (weak,nonatomic) id<OLTestResultViewControllerDelegate> delegate;

@end
