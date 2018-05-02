//
//  UCUploadViewController.m
//  HBDJProj
//
//  Created by Peanut Lee on 2018/5/2.
//  Copyright © 2018年 Lee. All rights reserved.
//

#import "UCUploadViewController.h"
#import "UCUploadCollectionViewFlowLayout.h"

@interface UCUploadViewController ()<
UICollectionViewDelegate,
UICollectionViewDataSource>
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
    
}

#pragma mark - delegaet & data source
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    return 5;//_array.count;
}
- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    UICollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"cell" forIndexPath:indexPath];
    cell.backgroundColor = [UIColor randomColor];
    return cell;
}

#pragma mark - target
- (void)cancelClick{
    [self.navigationController dismissViewControllerAnimated:YES completion:nil];
}
- (void)sendClick{
    NSLog(@"发送 -- ");
}

#pragma mark - getter
- (UICollectionView *)collectionView{
    if (_collectionView == nil) {
        _collectionView = [[UICollectionView alloc] initWithFrame:self.view.bounds collectionViewLayout:self.flowLayout];
        _collectionView.backgroundColor = [UIColor whiteColor];
        _collectionView.dataSource = self;
        _collectionView.delegate = self;
        [_collectionView registerClass:[UICollectionViewCell class] forCellWithReuseIdentifier:@"cell"];
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
