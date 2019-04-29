//
//  LGBaseCollectionViewController.m
//  youbei
//
//  Created by Peanut Lee on 2019/2/22.
//  Copyright © 2019 赵春阳. All rights reserved.
//

#import "LGBaseCollectionViewController.h"

@interface LGBaseCollectionViewController ()


@end

@implementation LGBaseCollectionViewController


- (void)viewDidLoad {
    [super viewDidLoad];
    [self.view addSubview:self.collectionView];
    
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    return 0;
}
- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    return nil;
}

- (UICollectionViewFlowLayout *)flowLayout{
    if (!_flowLayout) {
        _flowLayout = [UICollectionViewFlowLayout.alloc init];
        CGSize ss = [UIScreen mainScreen].bounds.size;
        _flowLayout.itemSize = CGSizeMake(ss.width, ss.height);
        _flowLayout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
    }
    return _flowLayout;
}

- (UICollectionView *)collectionView{
    if (!_collectionView) {
        _collectionView = [UICollectionView.alloc initWithFrame:self.view.bounds collectionViewLayout:self.flowLayout];
        _collectionView.dataSource = self;
        _collectionView.delegate = self;
        _collectionView.backgroundColor = UIColor.whiteColor;
        
    }
    return _collectionView;
}

@end
