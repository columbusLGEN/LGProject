//
//  DJSendCommentsViewController.h
//  HBDJProj
//
//  Created by Peanut Lee on 2018/8/16.
//  Copyright © 2018年 Lee. All rights reserved.
//

#import "LGBaseViewController.h"

@class DJDataBaseModel;

@interface DJSendCommentsViewController : LGBaseViewController
+ (instancetype)sendCommentvcWithModel:(DJDataBaseModel *)model;
@property (strong,nonatomic) DJDataBaseModel *model;

@end
