//
//  HPDigitalCollectionView.m
//  HBDJProj
//
//  Created by Peanut Lee on 2018/6/5.
//  Copyright © 2018年 Lee. All rights reserved.
//

#import "HPDigitalCollectionView.h"
#import "EDJDigitalModel.h"
#import "EDJDigitalCell.h"

@interface HPDigitalCollectionView ()<
UICollectionViewDelegate
,UICollectionViewDataSource>


@end

@implementation HPDigitalCollectionView

@synthesize dataArray = _dataArray;

- (void)setDataArray:(NSArray *)dataArray{
    _dataArray = dataArray;
    [self reloadData];
    
}

#pragma mark - UICollectionViewDataSource
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    return _dataArray.count;
}
- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    EDJDigitalModel *model = _dataArray[indexPath.item];
    EDJDigitalCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:digitalCell forIndexPath:indexPath];
    cell.model = model;
    return cell;
}

- (instancetype)initWithFrame:(CGRect)frame collectionViewLayout:(UICollectionViewLayout *)layout{
    if (self = [super initWithFrame:frame collectionViewLayout:layout]) {
        self.dataSource = self;
        self.delegate = self;
        [self registerNib:[UINib nibWithNibName:digitalCell bundle:nil]
          forCellWithReuseIdentifier:digitalCell];
    }
    return self;
}

@end
