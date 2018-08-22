//
//  DJDisSearchHigCell.h
//  HBDJProj
//
//  Created by Peanut Lee on 2018/8/22.
//  Copyright © 2018年 Lee. All rights reserved.
//

#import <UIKit/UIKit.h>

static NSString * const djdsSearchHisCell = @"DJDisSearchHigCell";
@class EDJSearchTagModel;

@interface DJDisSearchHisCell : UICollectionViewCell
@property (strong,nonatomic) EDJSearchTagModel *model;

@end
