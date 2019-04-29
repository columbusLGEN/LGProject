//
//  TCBookInfoRecoCollectionViewController.m
//  TimeCollege
//
//  Created by Peanut Lee on 2019/4/28.
//  Copyright © 2019 lee. All rights reserved.
//

#import "TCBookInfoRecoCollectionViewController.h"
#import "TCBookInfoRecoCollectionViewCell.h"

static NSString *recoCell = @"TCBookInfoRecoCollectionViewCell";

@interface TCBookInfoRecoCollectionViewController ()

@end

@implementation TCBookInfoRecoCollectionViewController

@synthesize flowLayout = _flowLayout;

- (void)viewDidLoad {
    [super viewDidLoad];
    [self configUI];
    
}

- (void)configUI{
    self.collectionView.showsHorizontalScrollIndicator = NO;
    [self.collectionView registerNib:[UINib nibWithNibName:recoCell bundle:nil] forCellWithReuseIdentifier:recoCell];
    [self.collectionView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.view);
    }];
    
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    return 10;
}
- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    TCBookInfoRecoCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:recoCell forIndexPath:indexPath];
    cell.model = @"test";
    return cell;
}

- (UICollectionViewFlowLayout *)flowLayout{
    if (!_flowLayout) {
        _flowLayout = [UICollectionViewFlowLayout.alloc init];
        _flowLayout.itemSize = CGSizeMake(110, self.itemHeight);
        _flowLayout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
    }
    return _flowLayout;
}

- (CGFloat)itemHeight{
    return 220;
}

@end
