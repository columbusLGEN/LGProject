//
//  UCRecommendDetailVC.h
//  EasyChineseReading-ios
//
//  Created by 赵春阳 on 2017/9/14.
//  Copyright © 2017年 lee. All rights reserved.
//

#import "ECRBaseViewController.h"

@interface UCRecommendDetailVC : ECRBaseViewController

@property (copy, nonatomic) void(^cancelImpower)(ImpowerModel *impower);

@property (assign, nonatomic) ENUM_RecommendType recommendType; // 推荐类型
@property (assign, nonatomic) ENUM_UserType userType;           // 用户类型
@property (assign, nonatomic) BOOL hiddenUsers;                 // 隐藏被推荐的人(在任务列表中跳转的)

@property (strong, nonatomic) RecommendModel *recommend; // 推荐详情
@property (strong, nonatomic) ImpowerModel *impower;     // 授权详情

@property (strong, nonatomic) NSString *content; 

@end
