//
//  UCUploadCollectionCell.h
//  HBDJProj
//
//  Created by Peanut Lee on 2018/5/3.
//  Copyright © 2018年 Lee. All rights reserved.
//

#import "LGBaseCollectionViewCell.h"
@class UCUploadModel;

static NSString * const cellID = @"UCUploadCollectionCell";

@interface UCUploadCollectionCell : LGBaseCollectionViewCell
@property (strong,nonatomic) UCUploadModel *model;
@property (strong,nonatomic) NSIndexPath *idx;
@property (copy, nonatomic) void (^photoViewChangeHeightBlock)(UICollectionViewCell *myCell);

@end
