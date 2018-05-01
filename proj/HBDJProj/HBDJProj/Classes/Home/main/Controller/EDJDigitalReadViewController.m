//
//  EDJDigitalReadViewController.m
//  HBDJProj
//
//  Created by Peanut Lee on 2018/4/3.
//  Copyright © 2018年 Lee. All rights reserved.
//

#import "EDJDigitalReadViewController.h"
#import "EDJHomeDigitalsFlowLayout.h"
#import "EDJHomeHeaderView.h"
#import "EDJDigitalCell.h"
#import "EDJDigitalModel.h"

static NSString * const digitalCell = @"EDJDigitalCell";

@interface EDJDigitalReadViewController ()


@end

@implementation EDJDigitalReadViewController

- (instancetype)init{
    if (self = [super init]) {
        _digitalModels  = [NSMutableArray array];
        for (int i = 0; i < 10; i++) {
            EDJDigitalModel *model = [EDJDigitalModel new];
            [_digitalModels addObject:model];
        }
        [self.collectionView reloadData];
    }
    return self;
}

#pragma mark - UICollectionViewDataSource
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    return _digitalModels.count;
}
- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    EDJDigitalModel *model = _digitalModels[indexPath.item];
    EDJDigitalCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:digitalCell forIndexPath:indexPath];
    cell.model = model;
    return cell;
}

- (UICollectionView *)collectionView{
    if (_collectionView == nil) {
        _collectionView = [[UICollectionView alloc] initWithFrame:kScreenBounds collectionViewLayout:self.flowLayout];
        if (@available(iOS 11.0,*)) {
            _collectionView.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
        }
        _collectionView.backgroundColor = [UIColor whiteColor];
        _collectionView.dataSource = self;
        [_collectionView registerNib:[UINib nibWithNibName:digitalCell bundle:nil]
          forCellWithReuseIdentifier:digitalCell];
        UIEdgeInsets insets = UIEdgeInsetsMake([self headerHeight], 0, kTabBarHeight, 0);
        [_collectionView setContentInset:insets];
//        _collectionView.scrollIndicatorInsets = insets;
    }
    return _collectionView;
}
- (EDJHomeDigitalsFlowLayout *)flowLayout{
    if (_flowLayout == nil) {
        _flowLayout = [EDJHomeDigitalsFlowLayout new];
    }
    return _flowLayout;
}

- (CGFloat)headerHeight{
    return [EDJHomeHeaderView headerHeight];
}

@end