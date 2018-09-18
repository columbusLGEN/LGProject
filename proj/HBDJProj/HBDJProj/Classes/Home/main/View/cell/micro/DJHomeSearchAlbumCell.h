//
//  DJHomeSearchAlbumCell.h
//  HBDJProj
//
//  Created by Peanut Lee on 2018/9/18.
//  Copyright © 2018 Lee. All rights reserved.
//

#import "LGBaseTableViewCell.h"

NS_ASSUME_NONNULL_BEGIN

@class EDJMicroLessionAlbumModel;

static NSString * homeSearchAlbumCell = @"DJHomeSearchAlbumCell";

@interface DJHomeSearchAlbumCell : LGBaseTableViewCell
@property (strong,nonatomic) EDJMicroLessionAlbumModel *model;

@end

NS_ASSUME_NONNULL_END
