//
//  ECRSortTableViewController.h
//  EasyChineseReading-ios
//
//  Created by lee on 2017/8/30.
//  Copyright © 2017年 lee. All rights reserved.
//

// MARK: 分类页面筛选条件控制器

#import "ECRBaseTableViewController.h"
@class ECRSortTableViewController,ECRClassSortModel,ECRMoreRowModel;

@protocol ECRSortTableViewControllerDelegate <NSObject>

@optional
// 当代理收到此通知时,需要在 互动教材, 汉语读物, 文化读物 之间切换
//- (void)stbController:(ECRSortTableViewController *)controller classModel:(ECRClassSortModel *)classModel rowModel:(ECRMoreRowModel *) rowModel;

- (void)stbController:(ECRSortTableViewController *)controller classModel:(ECRClassSortModel *)classModel rowModel:(ECRMoreRowModel *) rowModel indexPath:(NSIndexPath *)indexPath;

@end

@interface ECRSortTableViewController : ECRBaseTableViewController

@property (strong,nonatomic) NSArray *dataArray;// 

// -------
@property (assign,nonatomic) NSInteger bookListType;
@property (strong,nonatomic) NSArray *modelArray;
@property (copy,nonatomic) NSString *localPlistName;// 需要加载的本地plist名字
@property (weak,nonatomic) id<ECRSortTableViewControllerDelegate> delegate;
@property (assign,nonatomic) CGFloat sortCellH;//

@end
