//
//  HPAlbumHeaderCell.h
//  HBDJProj
//
//  Created by Peanut Lee on 2018/6/5.
//  Copyright © 2018年 Lee. All rights reserved.
//

#import "LGBaseTableViewCell.h"
@class EDJMicroPartyLessionSubModel;

static NSString * const albumListHeaderCell = @"HPAlbumHeaderCell";

@interface HPAlbumHeaderCell : LGBaseTableViewCell
@property (strong,nonatomic) EDJMicroPartyLessionSubModel *model;
@end
