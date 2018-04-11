//
//  EDJOnlineController.m
//  HBDJProj
//
//  Created by Peanut Lee on 2018/4/2.
//  Copyright © 2018年 Lee. All rights reserved.
//

#import "EDJOnlineController.h"
#import "EDJOnlineFlowLayout.h"

static NSString * const onlinCell = @"onlineCell";

@interface EDJOnlineController ()<UICollectionViewDataSource>

@end

@implementation EDJOnlineController

- (instancetype)init
{
    self = [super init];
    if (self) {
        _onlineModels  = [NSMutableArray array];
        for (int i = 0; i < 10; i++) {
            [_onlineModels addObject:@"B"];
        }
        [self.collectionView reloadData];
    }
    return self;
}

#pragma mark - UICollectionViewDataSource
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    return _onlineModels.count;
}
- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    UICollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:onlinCell forIndexPath:indexPath];
    cell.backgroundColor = [UIColor randomColor];
    return cell;
}

- (UICollectionView *)collectionView{
    if (_collectionView == nil) {
        CGRect frame = CGRectMake(0, kNavHeight, kScreenWidth, kScreenHeight - kNavHeight);
        _collectionView = [[UICollectionView alloc] initWithFrame:frame collectionViewLayout:self.flowLayout];
        if (@available(iOS 11.0,*)) {
            _collectionView.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
            NSLog(@"never");
        }
        
        _collectionView.backgroundColor = [UIColor whiteColor];
        _collectionView.dataSource = self;
        [_collectionView registerClass:[UICollectionViewCell class] forCellWithReuseIdentifier:onlinCell];
        UIEdgeInsets insets = UIEdgeInsetsMake([[self class] headerHeight], 0, kTabBarHeight, 0);
        [_collectionView setContentInset:insets];
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
