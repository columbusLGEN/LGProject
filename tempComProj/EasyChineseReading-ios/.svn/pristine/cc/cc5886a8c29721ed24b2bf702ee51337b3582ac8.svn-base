//
//  ECRSortTableViewCell.h
//  EasyChineseReading-ios
//
//  Created by lee on 2017/8/30.
//  Copyright © 2017年 lee. All rights reserved.
//

#import <UIKit/UIKit.h>
@class ECRHomeSortModel,ECRSortTableViewCell,ECRClassSortModel,ECRMoreRowModel;

@protocol ECRSortTableViewCellDelegate <NSObject>

@optional
- (void)stbCell:(ECRSortTableViewCell *)cell classModel:(ECRClassSortModel *)classModel indexPath:(NSIndexPath *)indexPath;

- (void)stbCell:(ECRSortTableViewCell *)cell classModel:(ECRClassSortModel *)classModel indexPath:(NSIndexPath *)indexPath rowSelectedModelId:(NSInteger)rowSelectedModelId;

@end

@interface ECRSortTableViewCell : UITableViewCell


@property (assign,nonatomic) NSInteger bookListType;

@property (strong,nonatomic) ECRMoreRowModel *model;//
@property (strong,nonatomic) NSIndexPath *indexPath;//
@property (weak,nonatomic) id<ECRSortTableViewCellDelegate> delegate;

@property (assign,nonatomic) NSInteger rowSelectModelId;//

@end
