//
//  UCRStudentsSelectedView.h
//  EasyChineseReading-ios
//
//  Created by 赵春阳 on 2017/9/15.
//  Copyright © 2017年 lee. All rights reserved.
//

#import "ECRBaseView.h"

@interface UCRStudentsSelectedView : ECRBaseView

@property (strong, nonatomic) NSMutableArray *objects;
@property (strong, nonatomic) UITableView *tableView;
@property (assign, nonatomic) ENUM_UserType userType; // 用户类型

- (instancetype)initWithFrame:(CGRect)frame withObjects:(NSMutableArray *)objects;

- (instancetype)initWithFrame:(CGRect)frame withObjects:(NSMutableArray *)objects canReorder:(BOOL)reOrder;

@end
