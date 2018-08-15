//
//  LGBaseTableViewController.h
//  HBDJProj
//
//  Created by Peanut Lee on 2018/4/18.
//  Copyright © 2018年 Lee. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "LGBaseViewController.h"

@interface LGBaseTableViewController : UITableViewController

@property (assign,nonatomic) LGBaseViewControllerPushWay pushWay;
@property (strong,nonatomic) NSArray *dataArray;

- (void)baseViewControllerDismiss;


@end
