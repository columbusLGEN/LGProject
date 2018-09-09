//
//  DJResourceTypeNewsViewController.h
//  HBDJProj
//
//  Created by Peanut Lee on 2018/9/7.
//  Copyright © 2018年 Lee. All rights reserved.
//

/// 消息页面的 新闻详情控制器

#import "HPPartyBuildDetailViewController.h"
@class UCMsgModel;

@interface DJResourceTypeNewsViewController : HPPartyBuildDetailViewController
@property (strong,nonatomic) UCMsgModel *msgModel;
@property (assign,nonatomic) NSInteger resourceid;

@end
