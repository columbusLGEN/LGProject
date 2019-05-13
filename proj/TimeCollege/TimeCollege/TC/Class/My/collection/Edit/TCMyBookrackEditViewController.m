//
//  TCMyBookrackEditViewController.m
//  TimeCollege
//
//  Created by Peanut Lee on 2019/5/10.
//  Copyright © 2019 lee. All rights reserved.
//

#import "TCMyBookrackEditViewController.h"
#import "TCMyBookrackEditCell.h"
#import "TCMyBookrackFlowLayout.h"
#import "LGNavigationSearchBar.h"
#import "TCMyBookrackModel.h"
#import "TCMyBookrackEditBottom.h"
#import "TCMyBookrackEditMakesureView.h"

@interface TCMyBookrackEditViewController ()<
LGNavigationSearchBarDelelgate>
@property (strong,nonatomic) TCMyBookrackEditMakesureView *makesurev;
@end

@implementation TCMyBookrackEditViewController

@synthesize flowLayout = _flowLayout;

- (void)viewDidLoad {
    [super viewDidLoad];
    [self configUI];
    
}

#pragma mark - target
/// TCMyBookrackEditBottom target
- (void)showMakesurev{
    self.makesurev.hidden = NO;
}
/// makesurev target
- (void)deleteCancel{
    /// 取消删除
    self.makesurev.hidden = YES;
}

#pragma mark - delegate
/** 全选 */
- (void)leftButtonClick:(LGNavigationSearchBar *)navigationSearchBar;{
    NSLog(@"全选");
    [self lg_dismissViewController];
}
/** 完成 */
- (void)navDoneClick{
    NSLog(@"完成");
}

- (void)configUI{
    
    UIButton *navRightButton = UIButton.new;
    [navRightButton setTitle:@"完成" forState:UIControlStateNormal];
    [navRightButton setTitleColor:UIColor.whiteColor forState:UIControlStateNormal];
    [navRightButton addTarget:self action:@selector(navDoneClick) forControlEvents:UIControlEventTouchUpInside];
 
    /// 假导航
    LGNavigationSearchBar *fakeNavgationBar = [[LGNavigationSearchBar alloc] initWithFrame:CGRectMake(0, 0, Screen_Width, navHeight())];
    fakeNavgationBar.leftTitle = @"全选";
    fakeNavgationBar.fakeSearch.hidden = YES;
    fakeNavgationBar.delegate = self;
    fakeNavgationBar.rightButton = navRightButton;
    
    [self.view addSubview:fakeNavgationBar];
    [fakeNavgationBar mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.top.right.equalTo(self.view);
        make.height.mas_equalTo(navHeight());
    }];
    
    /// collectionview
    [self.collectionView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(self.view);
        make.top.equalTo(fakeNavgationBar.mas_bottom);
    }];
    
    [self.collectionView registerClass:[TCMyBookrackEditCell class] forCellWithReuseIdentifier:myBookrackEditCell];
    
    /// bottom 删除按钮 + 蓝色渐变条
    TCMyBookrackEditBottom *bottom = [TCMyBookrackEditBottom brdBottom];
    [bottom.deleteButton addTarget:self action:@selector(showMakesurev) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:bottom];
    [bottom mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.bottom.equalTo(self.view);
        make.top.equalTo(self.collectionView.mas_bottom);
        make.height.mas_equalTo(50);
    }];
    
    /// 确定删除视图
    self.makesurev = [TCMyBookrackEditMakesureView mbemsView];
    [self.makesurev.cancel addTarget:self action:@selector(deleteCancel) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:self.makesurev];
    [self.makesurev mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.view);
    }];
    self.makesurev.hidden = YES;
    
    /// testcode
    NSMutableArray *arrmu = NSMutableArray.new;
    for (NSInteger i = 0; i < 20; i++) {
        TCMyBookrackModel *model = TCMyBookrackModel.new;
        model.ds = arc4random_uniform(4);
        model.editSelect = NO;
        [arrmu addObject:model];
        
    }
    self.array = arrmu.copy;
    
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    return self.array.count;
}
- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    TCMyBookrackModel *model = self.array[indexPath.item];
    TCMyBookrackEditCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:myBookrackEditCell forIndexPath:indexPath];
    cell.model = model;
    
    return cell;
}
- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    TCMyBookrackModel *model = self.array[indexPath.item];
    model.editSelect = !model.editSelect;
    [collectionView reloadItemsAtIndexPaths:@[indexPath]];

}

- (UICollectionViewFlowLayout *)flowLayout{
    if (!_flowLayout) {
        _flowLayout = TCMyBookrackFlowLayout.new;
    }
    return _flowLayout;
}


@end
