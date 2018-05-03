//
//  EDJOnlineController.m
//  HBDJProj
//
//  Created by Peanut Lee on 2018/4/2.
//  Copyright © 2018年 Lee. All rights reserved.
//

#import "EDJOnlineController.h"
#import "EDJOnlineFlowLayout.h"
#import "OLHomeModel.h"
#import "OLHomeCollectionCell.h"

static NSString * const onlinCell = @"OLHomeCollectionCell";

@interface EDJOnlineController ()<
UICollectionViewDataSource>

@end

@implementation EDJOnlineController

- (void)getDataWithPlistName:(NSString *)plistName{
    _onlineModels  = [OLHomeModel loadLocalPlistWithPlistName:plistName];
    [self.collectionView reloadData];
}

- (instancetype)init
{
    self = [super init];
    if (self) {
    }
    return self;
}

#pragma mark - UICollectionViewDataSource
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    return _onlineModels.count;
}
- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    OLHomeModel *model = _onlineModels[indexPath.item];
    OLHomeCollectionCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:onlinCell forIndexPath:indexPath];
    cell.model = model;
    return cell;
}

#pragma mark - UICollectionViewDelegate
- (UICollectionView *)collectionView{
    if (_collectionView == nil) {
        CGRect frame = CGRectMake(0, kNavHeight, kScreenWidth, kScreenHeight - kNavHeight);
        _collectionView = [[UICollectionView alloc] initWithFrame:frame collectionViewLayout:self.flowLayout];
        if (@available(iOS 11.0,*)) {
            _collectionView.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
        }
        
        UIEdgeInsets insets = UIEdgeInsetsMake([[self class] headerHeight], 0, kTabBarHeight, 0);
        [_collectionView setContentInset:insets];
        _collectionView.backgroundColor = [UIColor whiteColor];
        _collectionView.dataSource = self;
        
        [_collectionView registerNib:[UINib nibWithNibName:onlinCell bundle:nil] forCellWithReuseIdentifier:onlinCell];
        _collectionView.scrollIndicatorInsets = insets;
    }
    return _collectionView;
}
- (EDJOnlineFlowLayout *)flowLayout{
    if (_flowLayout == nil) {
        _flowLayout = [EDJOnlineFlowLayout new];
    }
    return _flowLayout;
}

+ (CGFloat)headerHeight{
    return 242;
}
@end
