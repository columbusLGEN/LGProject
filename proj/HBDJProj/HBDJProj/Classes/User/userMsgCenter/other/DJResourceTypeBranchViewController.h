//
//  DJResourceTypeBranchViewController.h
//  HBDJProj
//
//  Created by Peanut Lee on 2018/9/8.
//  Copyright © 2018年 Lee. All rights reserved.
//

/// 消息--支部动态详情页面

#import "DCSubPartStateDetailViewController.h"
@class UCMsgModel;
@interface DJResourceTypeBranchViewController : DCSubPartStateDetailViewController
@property (strong,nonatomic) UCMsgModel *msgModel;

@end
