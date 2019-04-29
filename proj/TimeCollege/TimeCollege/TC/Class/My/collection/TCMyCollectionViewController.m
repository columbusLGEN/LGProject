//
//  TCMyCollectionViewController.m
//  TimeCollege
//
//  Created by Peanut Lee on 2019/4/16.
//  Copyright © 2019 lee. All rights reserved.
//

#import "TCMyCollectionViewController.h"
#import "TCMyCollectionViewCell.h"

static NSString *myCollectionCell = @"TCMyCollectionViewCell";

@interface TCMyCollectionViewController ()

@end

@implementation TCMyCollectionViewController

@synthesize flowLayout = _flowLayout;
//@synthesize collectionView = _collectionView;

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self configUI];
}

- (void)configUI{
    
    [self.collectionView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.view);
    }];
    
    [self.collectionView registerNib:[UINib nibWithNibName:myCollectionCell bundle:nil] forCellWithReuseIdentifier:myCollectionCell];

}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    return 20;
}
- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    
    TCMyCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:myCollectionCell forIndexPath:indexPath];
    
    
    return cell;
}

- (UICollectionViewFlowLayout *)flowLayout{
    if (!_flowLayout) {
        _flowLayout = [UICollectionViewFlowLayout.alloc init];
        CGSize ss = [UIScreen mainScreen].bounds.size;
        _flowLayout.itemSize = CGSizeMake(ss.width / 3, 200);
        _flowLayout.scrollDirection = UICollectionViewScrollDirectionVertical;
        _flowLayout.minimumLineSpacing = 0;
        _flowLayout.minimumInteritemSpacing = 0;
    }
    return _flowLayout;
}


@end
