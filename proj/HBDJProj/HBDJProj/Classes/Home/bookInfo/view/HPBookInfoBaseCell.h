//
//  HPBookInfoBaseCell.h
//  HBDJProj
//
//  Created by Peanut Lee on 2018/5/2.
//  Copyright © 2018年 Lee. All rights reserved.
//

#import "LGBaseTableViewCell.h"

@class HPBookInfoModel,HPBookInfoBriefCell;

@protocol HPBookInfoBriefCellDelegate <NSObject>
- (void)bibCellShowAllButtonClick:(HPBookInfoBriefCell *)cell;

@end

@interface HPBookInfoBaseCell : LGBaseTableViewCell
//@property (strong,nonatomic) HPBookInfoModel *model;
@property (weak,nonatomic) id<HPBookInfoBriefCellDelegate> delegate;

@end
