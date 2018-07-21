//
//  DJInputContentViewController.h
//  HBDJProj
//
//  Created by Peanut Lee on 2018/7/10.
//  Copyright © 2018年 Lee. All rights reserved.
//

/// 创建主题党日 & 三会一课 输入内容的控制器

#import "LGBaseViewController.h"

@class DJInputContentViewController,DJOnlineUploadTableModel;

@protocol DJInputContentViewControllerDelegate <NSObject>
- (void)inputContentViewController:(DJInputContentViewController *)vc model:(DJOnlineUploadTableModel *)model;

@end

@interface DJInputContentViewController : LGBaseViewController
@property (weak,nonatomic) id<DJInputContentViewControllerDelegate> delegate;
@property (strong,nonatomic) DJOnlineUploadTableModel *model;
+ (LGBaseNavigationController *)modalInputvcWithModel:(id)model delegate:(id)delegate;

@end
