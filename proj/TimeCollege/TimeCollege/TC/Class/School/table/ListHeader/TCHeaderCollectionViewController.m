//
//  TCHeaderCollectionViewController.m
//  TimeCollege
//
//  Created by Peanut Lee on 2019/5/14.
//  Copyright © 2019 lee. All rights reserved.
//

#import "TCHeaderCollectionViewController.h"
#import "TCHeaderCollectionViewCell.h"
#import "TCQuadrateModel.h"

@interface TCHeaderCollectionViewController ()

@end

@implementation TCHeaderCollectionViewController

@synthesize flowLayout = _flowLayout;
@synthesize array = _array;

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self configUI];
}

- (void)configUI{
    self.collectionView.showsHorizontalScrollIndicator = NO;
    [self.collectionView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.view);
    }];
    
    self.view.backgroundColor = UIColor.clearColor;
    self.collectionView.backgroundColor = UIColor.clearColor;

    [self.collectionView registerClass:[TCHeaderCollectionViewCell class] forCellWithReuseIdentifier:hcCell];
    
    [NSNotificationCenter.defaultCenter addObserver:self selector:@selector(listFenleiClick:) name:kNotificationListFenleiClick object:nil];
}

- (void)listFenleiClick:(NSNotification *)notification{
    /// 遍历 array 将其余模型 不选中
    
    /// 获取当前点击的分类
    TCQuadrateModel *currentQuadrateModel = notification.userInfo[kNotificationListFenleiClickInfoOrigin];
    
    TCBookCatagoryLineModel *currentLineModel = notification.userInfo[kNotificationListFenleiClickInfoCurrenLine];
    
    if (currentLineModel == self.lineModel) {
        for (TCQuadrateModel *quadrateModel in self.array) {
            if (currentQuadrateModel == quadrateModel) {
            }else{
                NSLog(@"name: %@",quadrateModel.title);
                quadrateModel.seleted = NO;
            }
        }
        [self.collectionView reloadData];
        
    }
    
}

- (void)setArray:(NSArray *)array{
    _array = array;
    
    [self.collectionView reloadData];
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    return self.array.count;
}
- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    
    TCQuadrateModel *qmodel = self.array[indexPath.item];
    
    TCHeaderCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:hcCell forIndexPath:indexPath];
    cell.model = qmodel;
    return cell;
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath{
    /// 根据数据计算 itemsize
    TCQuadrateModel *qmodel = self.array[indexPath.item];
    CGFloat width = qmodel.title.length * 18 + 16;
    CGFloat height = 20;
    
    /// 高度固定,宽度为:文字个数 * 15 + 20
    //    NSLog(@"sizeForItemAtIndexPath: %@: %f",qmodel.title,width);
    return CGSizeMake(width, height);
}

- (UICollectionViewFlowLayout *)flowLayout{
    if (!_flowLayout) {
        _flowLayout = UICollectionViewFlowLayout.new;
        _flowLayout.itemSize = CGSizeMake(40, 30);
        _flowLayout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
    }
    return _flowLayout;
}

@end
