//
//  UFriendInfoVC.m
//  EasyChineseReading-ios
//
//  Created by 赵春阳 on 17/9/1.
//  Copyright © 2017年 lee. All rights reserved.
//

#import "UFriendInfoVC.h"

#import "UFriendInfoCollectionViewCell.h"
#import "UFriendInfoHeaderView.h"

#import "ECRBookInfoViewController.h"

static CGFloat const kCollectionHeaderH = 375.f;

@interface UFriendInfoVC () <UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout>

@property (weak, nonatomic) IBOutlet UICollectionView *collectionView;
@property (strong, nonatomic) UICollectionViewFlowLayout *layout;

@property (strong, nonatomic) UFriendInfoHeaderView *collectionHeaderView;    // 好友信息

@property (strong, nonatomic) UIView *headerView;

@property (assign, nonatomic) NSInteger kCollectionCellNumber;  // 展示推荐图书的数量

@property (assign, nonatomic) CGFloat cellWidth;  // cell宽度
@property (assign, nonatomic) CGFloat cellHeight; // cell高度
@property (assign, nonatomic) CGFloat cellSpace;  // cell间距

@end

@implementation UFriendInfoVC

- (void)viewDidLoad {
    [super viewDidLoad];
    [self configCollectionView];
    [self getFriendsData];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - 配置界面

- (void)updateSystemLanguage
{
    self.title = LOCALIZATION(@"好友信息");
    [_collectionView reloadData];
}

- (void)configCollectionView
{
    _kCollectionCellNumber = isPad ? cCollectionNum_Pad : cCollectionNum_Phone;
    _cellSpace = isPad ? cCollectionSpace_Pad : cCollectionSpace_Phone;
    _cellWidth = (Screen_Width - (_kCollectionCellNumber + 1)*_cellSpace)/_kCollectionCellNumber;
    _cellHeight = _cellWidth*cCollectionScale + 40; // 40 是图书封面到底部高度
    
    _collectionView.backgroundColor = [UIColor whiteColor];
    [self.collectionView registerNib:[UINib nibWithNibName:NSStringFromClass([UFriendInfoCollectionViewCell class]) bundle:nil] forCellWithReuseIdentifier:NSStringFromClass([UFriendInfoCollectionViewCell class])];
    [self.collectionView registerNib:[UINib nibWithNibName:NSStringFromClass([UFriendInfoHeaderView class]) bundle:nil] forSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:NSStringFromClass([UFriendInfoHeaderView class])];
    self.collectionView.collectionViewLayout = self.layout;
}

#pragma mark - 获取好友信息

/** 获取好友的阅读信息 */
- (void)getFriendsData
{
    [self showWaitTips];
    WeakSelf(self)
    [[FriendRequest sharedInstance] getFriendReadHistoryWithFriendId:[NSString stringWithFormat:@"%ld", _friendInfo.userId] completion:^(id object, ErrorModel *error) {
        StrongSelf(self)
        [self dismissTips];
        if (error) {
            [self presentFailureTips:error.message];
        }
        else {
            NSArray *array = [NSDictionary mj_objectArrayWithKeyValuesArray:object];
            _friendInfo.readBook = [BookModel mj_objectArrayWithKeyValuesArray:array.firstObject[@"readBook"]];
            _friendInfo.readHistory = [ReadHistoryModel mj_objectArrayWithKeyValuesArray:array.firstObject[@"readHistory"]];
            _friendInfo.canview = [array.firstObject[@"canview"] integerValue];
            
            [_collectionView reloadData];
        }
    }];
}

#pragma mark - UICollectionViewDataSource

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    // 如果用户允许查看ta的信息，则展示ta最近阅读的书籍
    return _friendInfo.canview ? _friendInfo.readBook.count : 0;
}

- (__kindof UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    UFriendInfoCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"UFriendInfoCollectionViewCell" forIndexPath:indexPath];
    cell.data = _friendInfo.readBook[indexPath.row];
    return cell;
}

#pragma mark - UICollectionViewDelegate

- (UICollectionReusableView *)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath {
    self.collectionHeaderView = (UFriendInfoHeaderView *)[collectionView dequeueReusableSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:NSStringFromClass([UFriendInfoHeaderView class]) forIndexPath:indexPath];
    _collectionHeaderView.data = _friendInfo;
    return _collectionHeaderView;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    [self pushToViewControllerWithIndex:indexPath.row];
}

#pragma mark - action

/** 查看图书详情 */
- (void)pushToViewControllerWithIndex:(NSInteger)index
{
    BookModel *book = _friendInfo.readBook[index];
    UIStoryboard *board = [UIStoryboard storyboardWithName:@"BookInfo" bundle:nil];
    ECRBookInfoViewController *bivc = [board instantiateViewControllerWithIdentifier:@"ECRBookInfoViewController"];
    bivc.viewControllerPushWay = ECRBaseControllerPushWayPush;
    bivc.bookId = book.bookId;
    [self.navigationController pushViewController:bivc animated:YES];
}

- (void)tapBack
{
    [self.navigationController popViewControllerAnimated:YES];
}

#pragma mark - 属性

- (UICollectionViewFlowLayout *)layout
{
    if (!_layout) {
        _layout = [[UICollectionViewFlowLayout alloc] init];
        _layout.minimumLineSpacing = _cellSpace;
        _layout.minimumInteritemSpacing = _cellSpace;
        _layout.itemSize = CGSizeMake(_cellWidth, _cellHeight);
        _layout.sectionInset = UIEdgeInsetsMake(_cellSpace, _cellSpace, _cellSpace, _cellSpace);
        _layout.headerReferenceSize = CGSizeMake(Screen_Width, kCollectionHeaderH);
    }
    return _layout;
}

@end
