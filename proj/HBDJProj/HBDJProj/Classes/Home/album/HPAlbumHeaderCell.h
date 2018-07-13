//
//  HPAlbumHeaderCell.h
//  HBDJProj
//
//  Created by Peanut Lee on 2018/6/5.
//  Copyright © 2018年 Lee. All rights reserved.
//

#import "LGBaseTableViewCell.h"
@class DJDataBaseModel;

@protocol HPAlbumHeaderCellDelegate <NSObject>
- (void)albumListHeaderTimeSort;

@end

static NSString * const albumListHeaderCell = @"HPAlbumHeaderCell";

@interface HPAlbumHeaderCell : LGBaseTableViewCell
@property (strong,nonatomic) DJDataBaseModel *model;
@property (weak,nonatomic) id<HPAlbumHeaderCellDelegate> delegate;

- (CGFloat)headerHeight;

@end
