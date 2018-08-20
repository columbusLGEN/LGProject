//
//  EDJSearchTagCollectionViewCell.m
//  HBDJProj
//
//  Created by Peanut Lee on 2018/4/25.
//  Copyright © 2018年 Lee. All rights reserved.
//

#import "EDJSearchTagCollectionViewCell.h"
#import "EDJSearchTagModel.h"

@interface EDJSearchTagCollectionViewCell ()


@end

@implementation EDJSearchTagCollectionViewCell


+ (NSString *)cellIdWithIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.section == 0) {
        return @"EDJSearchTagHotCell";
    }
    if (indexPath.section == 1) {
        return @"EDJSearchTagHistoryCell";
    }
    return @"";
}

@end
