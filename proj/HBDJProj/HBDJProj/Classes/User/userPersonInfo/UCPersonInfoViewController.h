//
//  UCPersonInfoViewController.h
//  HBDJProj
//
//  Created by Peanut Lee on 2018/4/12.
//  Copyright © 2018年 Lee. All rights reserved.
//

#import "LGBaseTableViewController.h"

@protocol UCPersonInfoViewControllerDelegate <NSObject>
- (void)pivcUpdateAvadater:(NSURL *)iconUrl;

@end

@interface UCPersonInfoViewController : LGBaseTableViewController
@property (weak,nonatomic) id<UCPersonInfoViewControllerDelegate> delegate;

@end
