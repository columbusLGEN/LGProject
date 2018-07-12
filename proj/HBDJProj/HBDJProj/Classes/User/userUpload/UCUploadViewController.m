//
//  UCUploadViewController.m
//  HBDJProj
//
//  Created by Peanut Lee on 2018/5/2.
//  Copyright © 2018年 Lee. All rights reserved.
//

#import "UCUploadViewController.h"
#import "UCUploadCollectionViewFlowLayout.h"
#import "UCUploadHeaderFooterView.h"
#import "UCUploadCollectionCell.h"
#import "UCUploadModel.h"
//#import "LGPhotoManager.h"

@interface UCUploadViewController ()<
UICollectionViewDelegate,
UICollectionViewDataSource,
UICollectionViewDelegateFlowLayout>
@property (strong,nonatomic) UICollectionView *collectionView;
@property (strong,nonatomic) UCUploadCollectionViewFlowLayout *flowLayout;
@property (strong,nonatomic) NSArray *array;

@end

@implementation UCUploadViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self configUI];
    
}
- (void)configUI{
    
    /// 导航部分
    UIBarButtonItem *cancel = [[UIBarButtonItem alloc] initWithTitle:@"取消" style:UIBarButtonItemStyleDone target:self action:@selector(cancelClick)];
    self.navigationItem.leftBarButtonItem = cancel;
    
    UIButton *sendButton = [[UIButton alloc] initWithFrame:CGRectZero];
    [sendButton setTitle:@"发送" forState:UIControlStateNormal];
    [sendButton setTitleColor:[UIColor EDJMainColor] forState:UIControlStateNormal];
    sendButton.titleLabel.font = [UIFont fontWithName:textBold size:17];/// 加粗
    UIBarButtonItem *send = [[UIBarButtonItem alloc] initWithCustomView:sendButton];
    
    self.navigationItem.rightBarButtonItem = send;
    
    /// 视图部分
    [self.view addSubview:self.collectionView];
    
    UCUploadModel *model = UCUploadModel.new;
    self.array = @[model];
    [self.collectionView reloadData];
    
}

#pragma mark - target
- (void)cancelClick{
    [self.navigationController dismissViewControllerAnimated:YES completion:nil];
}
- (void)sendClick{
    NSLog(@"发送 -- ");
    
}

#pragma mark - delegaet & data source
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath{
    UCUploadModel *model = self.array[indexPath.item];
    return CGSizeMake(kScreenWidth, model.cellHeight + 30);
}
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    return _array.count;
}
- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    UCUploadModel *model = _array[indexPath.row];
    UCUploadCollectionCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:cellID forIndexPath:indexPath];
    cell.model = model;
    __weak typeof(self) weakSelf = self;
    [cell setPhotoViewChangeHeightBlock:^(UICollectionViewCell *mycell) {
        [weakSelf.collectionView reloadData];
    }];
    return cell;
}

/// MARK: collection view header & footer
- (UICollectionReusableView *)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath{
    if ([kind isEqualToString:UICollectionElementKindSectionHeader]) {
        UCUploadHeaderFooterView *header = [collectionView dequeueReusableSupplementaryViewOfKind:kind withReuseIdentifier:headerFooterID forIndexPath:indexPath];
        if (self.uploadType == UploadTyleMemberStage) {
            header.titleText = @"你的描述内容是";
        }else{
            header.titleText = @"你的标题是";
        }
        return header;
    }
    if (!(self.uploadType == UploadTyleMemberStage)) {
        if ([kind isEqualToString:UICollectionElementKindSectionFooter]) {
            UCUploadHeaderFooterView *footer = [collectionView dequeueReusableSupplementaryViewOfKind:kind withReuseIdentifier:headerFooterID forIndexPath:indexPath];
            if (self.uploadType == UploadTyleMindReport) {
                footer.titleText = @"你的思想汇报内容是你的述职述廉内容是你的述职述廉内容是你的述职述廉内容是你的述职述廉内容是你的述职述廉内容是你的述职述廉内容是你的述职述廉内容是你的述职述廉内容是你的述职述廉内容是你的述职述廉内容是你的述职述廉内容是你的述职述廉内容是你的述职述廉内容是";
            }else{
                footer.titleText = @"你的述职述廉内容是";
            }
            return footer;
        }
    }
    return nil;
}
#pragma mark - UICollectionViewDelegateFlowLayout
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout referenceSizeForHeaderInSection:(NSInteger)section{
    /// 高度根据输入的内容返回
    return CGSizeMake(kScreenWidth, 77);
}
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout referenceSizeForFooterInSection:(NSInteger)section{
    /// 高度根据输入的内容返回
    if (!(self.uploadType == UploadTyleMemberStage)) {
        return CGSizeMake(kScreenWidth, 277);
    }
    return CGSizeZero;
}

#pragma mark - getter
- (UICollectionView *)collectionView{
    if (_collectionView == nil) {
        _collectionView = [[UICollectionView alloc] initWithFrame:self.view.bounds collectionViewLayout:self.flowLayout];
        _collectionView.backgroundColor = [UIColor whiteColor];
        _collectionView.dataSource = self;
        _collectionView.delegate = self;
        [_collectionView registerClass:[UCUploadHeaderFooterView class] forSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:headerFooterID];
        [_collectionView registerClass:[UCUploadHeaderFooterView class] forSupplementaryViewOfKind:UICollectionElementKindSectionFooter withReuseIdentifier:headerFooterID];
        [_collectionView registerClass:[UCUploadCollectionCell class] forCellWithReuseIdentifier:cellID];
    }
    return _collectionView;
}
- (UCUploadCollectionViewFlowLayout *)flowLayout{
    if (_flowLayout == nil) {
        _flowLayout = [UCUploadCollectionViewFlowLayout new];
    }
    return _flowLayout;
}

@end
