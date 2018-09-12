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

@interface OLNoMoreToolsView : UIView
@end

@implementation OLNoMoreToolsView
- (instancetype)initWithFrame:(CGRect)frame{
    if (self = [super initWithFrame:frame]) {
        UIColor *txtColor = UIColor.EDJGrayscale_11;
        UIFont *txtFont = [UIFont systemFontOfSize:15];
        UILabel *label0 = UILabel.new;
        UILabel *label1 = UILabel.new;
        label0.text = @"暂无更多工具 , 如需更多定制化党务工具";
        NSString *phoneNumber = [NSUserDefaults.standardUserDefaults objectForKey:dj_service_numberKey];
        label1.text = phoneNumber;
        label0.textColor = txtColor;
        label1.textColor = txtColor;
        label0.font = txtFont;
        label1.font = txtFont;
        label0.textAlignment = NSTextAlignmentCenter;
        label1.textAlignment = NSTextAlignmentCenter;
        
        [self addSubview:label0];
        [self addSubview:label1];
        
        [label0 mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerX.equalTo(self);
            make.centerY.equalTo(self).offset(-35);
        }];
        [label1 mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerX.equalTo(self);
            make.top.equalTo(label0.mas_bottom).offset(marginTen);
        }];
    }
    return self;
}
@end

static NSString * const onlinCell = @"OLHomeCollectionCell";
static NSString * const headerReuseID = @"OLAddMoreToolHeader";
static NSString * const footerReuseID = @"OLAddMoreToolFooter";
static CGFloat midHeight = 40;
static CGFloat footerHeight = 80;

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
@property (strong,nonatomic) OLNoMoreToolsView *noMoreToolsView;

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

- (void)setArray:(NSArray *)array{
    _array = array;
//    array = nil;
    if (array.count == 0 || array == nil) {
        [self.view addSubview:self.noMoreToolsView];
        [self.noMoreToolsView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.midView.mas_bottom);
            make.left.equalTo(self.view.mas_left);
            make.right.equalTo(self.view.mas_right);
            make.height.mas_equalTo(kScreenHeight / 2 + midHeight - kTabBarHeight - footerHeight);
            make.bottom.equalTo(self.view.mas_bottom);
        }];
        [self.collectionView removeFromSuperview];
        [self.fakeFooter removeFromSuperview];
    }else{
        [self.collectionView reloadData];
    }
    
}

#pragma mark - delegate
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    return _array.count;
}
- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    OLHomeModel *model = _array[indexPath.item];
    OLHomeCollectionCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:onlinCell forIndexPath:indexPath];
    cell.model = model;
    return cell;
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

- (OLNoMoreToolsView *)noMoreToolsView{
    if (!_noMoreToolsView) {
        _noMoreToolsView = OLNoMoreToolsView.new;
        _noMoreToolsView.backgroundColor = UIColor.whiteColor;
    }
    return _noMoreToolsView;
}

@end
