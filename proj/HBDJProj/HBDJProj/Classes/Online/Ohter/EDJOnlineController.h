//
//  EDJOnlineController.h
//  HBDJProj
//
//  Created by Peanut Lee on 2018/4/2.
//  Copyright © 2018年 Lee. All rights reserved.
//

#import "LIGObject.h"
@class EDJOnlineFlowLayout;

@interface EDJOnlineController : LIGObject
@property (strong,nonatomic) EDJOnlineFlowLayout *flowLayout;
@property (strong,nonatomic) UICollectionView *collectionView;
@property (strong,nonatomic) NSMutableArray *onlineModels;
+ (CGFloat)headerHeight;

@end
