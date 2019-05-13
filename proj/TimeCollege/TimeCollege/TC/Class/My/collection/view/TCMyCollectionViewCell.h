//
//  TCMyCollectionViewCell.h
//  TimeCollege
//
//  Created by Peanut Lee on 2019/4/16.
//  Copyright © 2019 lee. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@class TCMyBookrackModel,BookDownloadProgressv;

static NSString *myCollectionCell = @"TCMyCollectionViewCell";

@interface TCMyCollectionViewCell : UICollectionViewCell
@property (strong, nonatomic) UIImageView *cover;
@property (strong,nonatomic) TCMyBookrackModel *model;
/** 下载状态视图 */
@property (strong,nonatomic) BookDownloadProgressv *progressv;

@end

NS_ASSUME_NONNULL_END
