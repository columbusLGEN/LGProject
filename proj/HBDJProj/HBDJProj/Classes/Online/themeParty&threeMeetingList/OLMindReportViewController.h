//
//  OLMindReportViewController.h
//  HBDJProj
//
//  Created by Peanut Lee on 2018/5/3.
//  Copyright © 2018年 Lee. All rights reserved.
//

/// 思想汇报，主题党日，述职述廉，以及三会一课内容 的列表视图控制器

typedef NS_ENUM(NSUInteger, DJThemeMeetingDetailFromType) {
    DJThemeMeetingDetailFromTypePartyDay,/// 主题党日
    DJThemeMeetingDetailFromTypeThreeMeeting /// 三会一课
};

#import "LGBaseTableViewController.h"

@interface OLMindReportViewController : LGBaseTableViewController

@property (assign,nonatomic) DJThemeMeetingDetailFromType fromType;
@property (assign,nonatomic) OnlineModelType listType;

@end
