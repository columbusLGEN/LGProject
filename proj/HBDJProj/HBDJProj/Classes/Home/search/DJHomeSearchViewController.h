//
//  DJHomeSearchViewController.h
//  HBDJProj
//
//  Created by Peanut Lee on 2018/7/30.
//  Copyright © 2018年 Lee. All rights reserved.
//

#import "DJUnitSearchViewController.h"
@class DJDataSyncer;

@interface DJHomeSearchViewController : DJUnitSearchViewController
@property (strong,nonatomic) DJDataSyncer *dataSyncer;

@end
