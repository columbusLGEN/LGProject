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
/** 保存选中数据,向服务器提交 */
@property (strong,nonatomic) NSMutableArray *selectedArray;

@end

@implementation TCMyBookrackEditViewController

@synthesize flowLayout = _flowLayout;
@synthesize array = _array;

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
- (void)deleteSure{
    /// 确定删除
    NSLog(@"确定删除%ld本书吗?",self.selectedArray.count);
}
- (void)deleteCancel{
    /// 取消删除
    self.makesurev.hidden = YES;
    
}

#pragma mark - delegate
/** 全选 */
- (void)leftButtonClick:(LGNavigationSearchBar *)navigationSearchBar;{
    NSLog(@"全选");
    /// 如果所有模型都是 选中状态,则全部取消选中,否则全部设为 选中状态
    BOOL allSelect = YES;
    for (TCMyBookrackModel *model in self.array) {
        if (!model.editSelect) {
            allSelect = NO;
            break;
        }
    }
    
    BOOL select;
    if (allSelect) {
        select = NO;
        /// 删除所有选中数据
        [self.selectedArray removeAllObjects];
    }else{
        select = YES;
        self.selectedArray = [NSMutableArray arrayWithArray:self.array];
    }
    
    for (TCMyBookrackModel *model in self.array) {
        model.editSelect = select;
    }
    
    [self.collectionView reloadData];
    
}
/** 完成 */
- (void)navDoneClick{
    NSLog(@"完成");
    [self lg_dismissViewController];
}

- (void)configUI{
    
    _selectedArray = NSMutableArray.new;
    
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
    [self.makesurev.done addTarget:self action:@selector(deleteSure) forControlEvents:UIControlEventTouchUpInside];
    [self.makesurev.cancel addTarget:self action:@selector(deleteCancel) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:self.makesurev];
    [self.makesurev mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.view);
    }];
    self.makesurev.hidden = YES;
    
    /// 数据
    for (NSInteger i = 0; i < _array.count; i++) {
        TCMyBookrackModel *model = _array[i];
        if (self.longPressIndex.item == i) {
            [self.selectedArray addObject:model];
            model.editSelect = YES;
        }
    }
    [self.collectionView reloadData];
}

- (void)setArray:(NSArray *)array{
    _array = array;
    
    
    /// 代码执行顺序是 先 setArray 在viewDidload
    /// 所以不能在此处 reloadData,因为此时collectionview还没有载入
//    [self.collectionView reloadData];
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
    
    if (model.editSelect) {
        [self.selectedArray addObject:model];
    }else{
        [self.selectedArray removeObject:model];
    }
    
    [collectionView reloadItemsAtIndexPaths:@[indexPath]];

}

- (UICollectionViewFlowLayout *)flowLayout{
    if (!_flowLayout) {
        _flowLayout = TCMyBookrackFlowLayout.new;
    }
    return _flowLayout;
}


@end
