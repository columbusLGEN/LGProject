//
//  EDJMicroPartyLessionViewController.h
//  HBDJProj
//
//  Created by Peanut Lee on 2018/4/3.
//  Copyright © 2018年 Lee. All rights reserved.
//

/// 微党课 & 党建要闻公用控制器

#import "LIGObject.h"

typedef NS_ENUM(NSUInteger, EDJHomeDataType) {
    EDJHomeDataTypeMicro,/// 微党课
    EDJHomeDataTypeBuild,/// 党建要闻
};

@interface EDJMicroPartyLessionViewController : LIGObject

@property (strong,nonatomic) UITableView *tableView;
/** 微党课数据 */
@property (strong,nonatomic) NSMutableArray *microModels;
/** 党建数据 */
@property (strong,nonatomic) NSMutableArray *buildModels;
@property (assign,nonatomic) EDJHomeDataType dataType;
- (void)configHeaderWithSegment:(NSInteger)segment delegate:(id)delegate;

@end
