//
//  EDJDigitalCell.h
//  HBDJProj
//
//  Created by Peanut Lee on 2018/4/25.
//  Copyright © 2018年 Lee. All rights reserved.
//

#import <UIKit/UIKit.h>
@class EDJDigitalModel;

static NSString * const digitalCell = @"EDJDigitalCell";

@interface EDJDigitalCell : UICollectionViewCell
@property (strong,nonatomic) EDJDigitalModel *model;

@end
