//
//  HPDigitalCollectionViewController.h
//  HBDJProj
//
//  Created by Peanut Lee on 2018/6/20.
//  Copyright © 2018年 Lee. All rights reserved.
//

#import "LGBaseViewController.h"

@interface HPDigitalCollectionViewController : LGBaseViewController
@property (strong,nonatomic) NSArray *dataArray;
/** 父控制器,用作接收上拉刷新事件 */
@property (strong,nonatomic) UIViewController *superVc;
@property (strong,nonatomic) UICollectionView *collectionView;

@end
