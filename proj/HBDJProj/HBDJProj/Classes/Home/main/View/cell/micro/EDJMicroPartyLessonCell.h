//
//  EDJMicroPartyLessonCell.h
//  HBDJProj
//
//  Created by Peanut Lee on 2018/4/2.
//  Copyright © 2018年 Lee. All rights reserved.
//

#import "LGBaseTableViewCell.h"

@class EDJMicroLessionAlbumModel;

@interface EDJMicroPartyLessonCell : LGBaseTableViewCell
+ (NSString *)cellIdentifierWithIndexPath:(NSIndexPath *)indexPath;
+ (CGFloat)cellHeightWithIndexPath:(NSIndexPath *)indexPath;
@property (strong,nonatomic) EDJMicroLessionAlbumModel *model;

@end
