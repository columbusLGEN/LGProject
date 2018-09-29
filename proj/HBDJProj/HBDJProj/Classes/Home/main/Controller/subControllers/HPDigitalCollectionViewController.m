//
//  HPDigitalCollectionViewController.m
//  HBDJProj
//
//  Created by Peanut Lee on 2018/6/20.
//  Copyright © 2018年 Lee. All rights reserved.
//

#import "HPDigitalCollectionViewController.h"

#import "EDJDigitalCell.h"
#import "EDJDigitalModel.h"

#import "LTScrollView-Swift.h"
#import "LGDidSelectedNotification.h"

@interface HPDigitalCollectionViewController ()<
UICollectionViewDelegate,
UICollectionViewDataSource>
@property (strong,nonatomic) UICollectionViewFlowLayout *layout;

@end

@implementation HPDigitalCollectionViewController

- (void)setDataArray:(NSArray *)dataArray{
    _dataArray = dataArray;
    
    [self.collectionView reloadData];
}

#pragma mark <UICollectionViewDataSource>
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return self.dataArray.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    EDJDigitalModel *model = _dataArray[indexPath.item];
    EDJDigitalCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:digitalCell forIndexPath:indexPath];
    cell.model = model;
    return cell;
}
- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    EDJDigitalModel *model = self.dataArray[indexPath.row];
    NSDictionary *dict = @{LGDidSelectedModelKey:model,
                           LGDidSelectedSkipTypeKey:@(LGDidSelectedSkipTypeDigitalBook)
                           };
    [[NSNotificationCenter defaultCenter] postNotificationName:LGDidSelectedNotification object:nil userInfo:dict];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self.view addSubview:self.collectionView];
    self.glt_scrollView = self.collectionView;
    
    self.collectionView.mj_footer = [MJRefreshAutoNormalFooter footerWithRefreshingTarget:self.superVc refreshingAction:@selector(digitalLoadMoreDatas)];
}
- (UICollectionView *)collectionView{
    if (!_collectionView) {
        _collectionView = [[UICollectionView alloc] initWithFrame:CGRectMake(0, kStatusBarHeight + 10, kScreenWidth, kScreenHeight - kTabBarHeight - kNavHeight - 10) collectionViewLayout:self.layout];
        _collectionView.delegate = self;
        _collectionView.dataSource = self;
        _collectionView.backgroundColor = [UIColor whiteColor];
        [_collectionView registerNib:[UINib nibWithNibName:digitalCell bundle:nil] forCellWithReuseIdentifier:digitalCell];
    }
    return _collectionView;
}
- (UICollectionViewFlowLayout *)layout{
    if (!_layout) {
        _layout = [UICollectionViewFlowLayout new];
        _layout.itemSize = CGSizeMake((kScreenWidth - 30) / 3, 133 + 48);
    }
    return _layout;
}


@end
