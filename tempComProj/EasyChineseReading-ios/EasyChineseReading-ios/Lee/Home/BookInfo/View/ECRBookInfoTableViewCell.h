//
//  ECRBookInfoTableViewCell.h
//  EasyChineseReading-ios
//
//  Created by lee on 2017/9/12.
//  Copyright © 2017年 lee. All rights reserved.
//

#import "ECRBaseTableViewCell.h"
@class ECRBookInfoModel,ECRBookInfoTableViewCell,ECRRecoBook;

@protocol ECRBookInfoTableViewCellDelegate <NSObject>

- (void)bitbrecoBookClick:(ECRBookInfoTableViewCell *)cell model:(ECRRecoBook *)model;
- (void)bitbnrcaFold:(ECRBookInfoTableViewCell *)cell;

@end

@interface ECRBookInfoTableViewCell : ECRBaseTableViewCell

@property (strong,nonatomic) ECRBookInfoModel *model;
@property (strong,nonatomic) NSIndexPath *indx;

+ (NSString *)gainReuseID:(NSIndexPath *)indexPath;
@property (assign,nonatomic) CGFloat rHeight;
@property (assign,nonatomic) CGFloat rHeight1;
@property (assign,nonatomic) CGFloat rHeight2;
@property (assign,nonatomic) CGFloat rHeight3;
@property (assign,nonatomic) CGFloat rHeight4;

@property (weak,nonatomic) id<ECRBookInfoTableViewCellDelegate> delegate;//

@end
