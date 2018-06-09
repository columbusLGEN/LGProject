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

#import "LGDidSelectedNotification.h"

@interface HPDigitalCollectionView ()<
STCollectionViewDelegate
,STCollectionViewDataSource>

@end

@implementation HPDigitalCollectionView

- (void)setDataArray:(NSArray *)dataArray{
    _dataArray = dataArray;
    [self reloadData];
    
}

#pragma mark - STCollectionViewDataSource
- (NSInteger)stCollectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    return _dataArray.count;
}
- (UICollectionViewCell *)stCollectionView:(STCollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    EDJDigitalModel *model = _dataArray[indexPath.item];
    EDJDigitalCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:digitalCell forIndexPath:indexPath];
    cell.model = model;
    return cell;
}
#pragma mark - STCollectionViewFlowLayoutDelegate
- (NSInteger)collectionView:(UICollectionView *)collectionView layout:(STCollectionViewFlowLayout *)layout numberOfColumnsInSection:(NSInteger)section {
    return 3;
}
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    return CGSizeMake(kScreenWidth / 3, 133 + 48);
}
#pragma mark - UICollectionViewDataSource

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    EDJDigitalModel *model = self.dataArray[indexPath.row];
    NSDictionary *dict = @{LGDidSelectedModelKey:model,
                           LGDidSelectedSkipTypeKey:@(LGDidSelectedSkipTypeDigitalBook)
                           };
    [[NSNotificationCenter defaultCenter] postNotificationName:LGDidSelectedNotification object:nil userInfo:dict];
}

- (instancetype)initWithFrame:(CGRect)frame{
    if (self = [super initWithFrame:frame]) {
        [self commonInit];
    }
    return self;
}
- (void)commonInit{
    self.backgroundColor = [UIColor whiteColor];
    /// MARK: 修改layout的相关值
//        STCollectionViewFlowLayout * layout = self.st_collectionViewLayout;
    //    layout.minimumInteritemSpacing = 5;
    //    layout.minimumLineSpacing = 5;
//        layout.sectionInset = UIEdgeInsetsMake(5, 5, 5, 5);
    self.stDelegate = self;
    self.stDataSource = self;
    
    [self registerNib:[UINib nibWithNibName:digitalCell bundle:nil] forCellWithReuseIdentifier:digitalCell];
    
    if (@available(iOS 11.0, *)) {
        self.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
    } else {
        // Fallback on earlier versions
    }
    
    self.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        [[NSOperationQueue mainQueue] addOperationWithBlock:^{
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                [self.mj_header endRefreshing];
            });
        }];
    }];
    
}


@end
