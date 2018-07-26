//
//  DJUnitSearchViewController.h
//  HBDJProj
//
//  Created by Peanut Lee on 2018/7/26.
//  Copyright © 2018年 Lee. All rights reserved.
//

#import "LGSegmentViewController.h"

@interface DJUnitSearchViewController : LGSegmentViewController

/** 是否语音搜索 */
@property (assign,nonatomic) BOOL voice;

/// --------------- 以下属性、方法 由子类实现 ---------------

/** 本地历史记录索引 0:首页 1:在线 2:在线 */
- (NSInteger)searchRecordExePart;
/** 设置列表视图搜索内容，用于上拉刷新 */
- (void)setChildvcSearchContent:(NSString *)searchContent;
/** 发送搜索请求 */
- (void)sendSerachRequestWithSearchContent:(NSString *)searchContent;

@end
