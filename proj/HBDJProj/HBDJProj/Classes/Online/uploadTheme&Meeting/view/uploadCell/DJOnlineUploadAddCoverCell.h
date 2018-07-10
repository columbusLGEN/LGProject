//
//  DJOnlineUploadAddCoverCell.h
//  HBDJProj
//
//  Created by Peanut Lee on 2018/7/4.
//  Copyright © 2018年 Lee. All rights reserved.
//

#import "DJOnlineUplaodBaseCell.h"

static NSString * const addCoverCell = @"DJOnlineUploadAddCoverCell";

@class DJOnlineUploadAddCoverCell;

@protocol DJOnlineUploadAddCoverCellDelegate <NSObject>
- (void)addCoverClick:(DJOnlineUploadAddCoverCell *)cell;

@end

@interface DJOnlineUploadAddCoverCell : DJOnlineUplaodBaseCell
@property (weak,nonatomic) id<DJOnlineUploadAddCoverCellDelegate> delegate;

@end
