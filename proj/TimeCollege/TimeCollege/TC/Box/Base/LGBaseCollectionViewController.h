//
//  LGBaseCollectionViewController.h
//  youbei
//
//  Created by Peanut Lee on 2019/2/22.
//  Copyright © 2019 赵春阳. All rights reserved.
//

#import "LGBaseViewController.h"

NS_ASSUME_NONNULL_BEGIN

@interface LGBaseCollectionViewController : LGBaseViewController<
UICollectionViewDelegate,
UICollectionViewDataSource>
@property (strong,nonatomic) UICollectionView *collectionView;
@property (strong,nonatomic) UICollectionViewFlowLayout *flowLayout;
@property (strong,nonatomic) NSArray *array;

@end

NS_ASSUME_NONNULL_END
