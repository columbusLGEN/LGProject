//
//  OLAddMoreToolViewController.m
//  HBDJProj
//
//  Created by Peanut Lee on 2018/4/25.
//  Copyright © 2018年 Lee. All rights reserved.
//

#import "OLAddMoreToolViewController.h"
#import "OLAddMoreFlowLayout.h"
#import "OLHomeCollectionCell.h"
#import "OLHomeModel.h"
#import "OLAddMoreToolHeader.h"
#import "OLAddMoreToolFooter.h"
#import "OLSkipObject.h"
#import "LGBaseNavigationController.h"/// testcode

static NSString * const onlinCell = @"OLHomeCollectionCell";
static NSString * const headerReuseID = @"OLAddMoreToolHeader";
static NSString * const footerReuseID = @"OLAddMoreToolFooter";
static CGFloat midHeight = 40;
static CGFloat footerHeight = 60;

@interface OLAddMoreToolViewController ()<
UICollectionViewDelegate,
UICollectionViewDataSource,
UICollectionViewDelegateFlowLayout>
@property (strong,nonatomic) UIButton *bigClose;
@property (strong,nonatomic) UIView *midView;
@property (strong,nonatomic) UIButton *close;
@property (strong,nonatomic) UICollectionView *collectionView;
@property (strong,nonatomic) OLAddMoreFlowLayout *flowLayout;
@property (strong,nonatomic) OLAddMoreToolFooter *fakeFooter;

@property (strong,nonatomic) NSArray *array;

@end

@implementation OLAddMoreToolViewController

- (void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    
    [self.view addSubview:self.bigClose];
    /// bigclose
    [self.bigClose mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.view.mas_left);
        make.right.equalTo(self.view.mas_right);
        make.top.equalTo(self.view.mas_top);
        make.bottom.equalTo(self.midView.mas_top);
    }];
    
}


- (void)viewDidLoad {
    [super viewDidLoad];
    [self configUI];
    
}

- (void)configUI{
    self.view.backgroundColor = [UIColor clearColor];
    
    [self.view addSubview:self.midView];
    [self.view addSubview:self.collectionView];
    [self.view addSubview:self.fakeFooter];
    
    [self.midView addSubview:self.close];
    
    /// midview
    
    [self.midView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.view.mas_left);
        make.right.equalTo(self.view.mas_right);
        make.height.mas_equalTo(midHeight);
    }];
    /// close
    [self.close mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.midView.mas_left).offset(marginTwenty);
        make.centerY.equalTo(self.midView.mas_centerY);
    }];
    
    /// collectionview
    [self.view addSubview:self.collectionView];
    [self.collectionView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.midView.mas_bottom);
        make.left.equalTo(self.view.mas_left);
        make.right.equalTo(self.view.mas_right);
        make.height.mas_equalTo(kScreenHeight / 2 + midHeight - kTabBarHeight - footerHeight);
        make.bottom.equalTo(self.fakeFooter.mas_top);
    }];
    [self.fakeFooter mas_makeConstraints:^(MASConstraintMaker *make) {
        make.height.mas_equalTo(footerHeight);
        make.left.equalTo(self.view.mas_left);
        make.right.equalTo(self.view.mas_right);
        make.bottom.equalTo(self.view.mas_bottom);///.offset(-kTabBarHeight);
    }];
    
    _array = [OLHomeModel loadLocalPlistWithPlistName:@"OLAddMoreTool"];
    [self.collectionView reloadData];
}

#pragma mark - delegate
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    return 3;
}
- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    OLHomeModel *model = _array[indexPath.item];
    OLHomeCollectionCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:onlinCell forIndexPath:indexPath];
    cell.model = model;
    return cell;
}
- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    OLHomeModel *model = self.array[indexPath.row];
    LGBaseViewController *vc = (LGBaseViewController *)[OLSkipObject viewControllerWithOLHomeModelType:model];
    vc.pushWay = LGBaseViewControllerPushWayModal;
    LGBaseNavigationController *nav = [[LGBaseNavigationController alloc] initWithRootViewController:vc];
    [self showViewController:nav sender:nil];
}

#pragma mark - header & footer
- (UICollectionReusableView *)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath{
    if ([kind isEqualToString:UICollectionElementKindSectionHeader]) {
        OLAddMoreToolHeader *header = [collectionView dequeueReusableSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:headerReuseID forIndexPath:indexPath];
        return header;
    }
//    if ([kind isEqualToString:UICollectionElementKindSectionFooter]) {
//        OLAddMoreToolFooter *footer = [collectionView dequeueReusableSupplementaryViewOfKind:UICollectionElementKindSectionFooter withReuseIdentifier:footerReuseID forIndexPath:indexPath];
//        return footer;
//    }
    return nil;
}
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout referenceSizeForHeaderInSection:(NSInteger)section{
    return CGSizeMake(kScreenWidth, 60);
}
//- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout referenceSizeForFooterInSection:(NSInteger)section{
//    return CGSizeMake(kScreenWidth, 60);
//}

- (void)close:(UIButton *)sender{
    [self.bigClose removeFromSuperview];
    [self dismissViewControllerAnimated:YES completion:nil];
}


/// MARK: lazy laod
- (UIButton *)bigClose{
    if (_bigClose == nil) {
        _bigClose = [[UIButton alloc] initWithFrame:CGRectZero];
        [_bigClose addTarget:self action:@selector(close:) forControlEvents:UIControlEventTouchUpInside];
        [_bigClose setBackgroundColor:[UIColor blackColor]];
        _bigClose.alpha = 0.3;
    }
    return _bigClose;
}
- (UIView *)midView{
    if (_midView == nil) {
        _midView = [UIView new];
        _midView.backgroundColor = [UIColor whiteColor];
    }
    return _midView;
}
- (UIButton *)close{
    if (_close == nil) {
        _close = [[UIButton alloc] initWithFrame:CGRectZero];
        [_close setImage:[UIImage imageNamed:@"ol_add_model_tool_close"] forState:UIControlStateNormal];
        [_close addTarget:self action:@selector(close:) forControlEvents:UIControlEventTouchUpInside];

    }
    return _close;
}

- (UICollectionView *)collectionView{
    if (_collectionView == nil) {
        _collectionView = [[UICollectionView alloc] initWithFrame:CGRectZero collectionViewLayout:self.flowLayout];
        _collectionView.backgroundColor = [UIColor whiteColor];
        _collectionView.delegate = self;
        _collectionView.dataSource = self;
        [_collectionView registerNib:[UINib nibWithNibName:onlinCell bundle:nil] forCellWithReuseIdentifier:onlinCell];
        [_collectionView registerClass:[OLAddMoreToolHeader class] forSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:headerReuseID];
    }
    return _collectionView;
}
- (OLAddMoreFlowLayout *)flowLayout{
    if (_flowLayout == nil) {
        _flowLayout = [OLAddMoreFlowLayout new];
    }
    return _flowLayout;
}
- (OLAddMoreToolFooter *)fakeFooter{
    if (_fakeFooter == nil) {
        _fakeFooter = [OLAddMoreToolFooter new];
        _fakeFooter.backgroundColor = [UIColor whiteColor];
    }
    return _fakeFooter;
}

@end
