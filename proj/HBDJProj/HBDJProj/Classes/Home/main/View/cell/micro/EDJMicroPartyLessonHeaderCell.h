//
//  EDJMicroPartyLessonHeaderCell.h
//  HBDJProj
//
//  Created by Peanut Lee on 2018/4/11.
//  Copyright © 2018年 Lee. All rights reserved.
//

#import "LGBaseTableViewCell.h"
@class EDJMicroLessionAlbumModel,EDJMicroPartyLessonHeaderCell;

@protocol EDJMicroPartyLessonHeaderCellDelegate <NSObject>
- (void)headerAlbumClick:(EDJMicroPartyLessonHeaderCell *)header index:(NSInteger)index;

@end

@interface EDJMicroPartyLessonHeaderCell : LGBaseTableViewCell
@property (strong,nonatomic) EDJMicroLessionAlbumModel *model;
@property (weak,nonatomic) id<EDJMicroPartyLessonHeaderCellDelegate> delegate;

@end
