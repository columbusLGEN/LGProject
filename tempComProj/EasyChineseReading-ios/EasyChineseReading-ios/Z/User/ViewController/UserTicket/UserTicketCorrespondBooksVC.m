//
//  UserTicketCorrespondBooksVC.m
//  EasyChineseReading-ios
//
//  Created by 赵春阳 on 2017/10/24.
//  Copyright © 2017年 retech. All rights reserved.
//

#import "UserTicketCorrespondBooksVC.h"

#import "UTCorrespondBookCollectionViewCell.h"
#import "ECRBookInfoViewController.h"

static CGFloat const kCellHeight   = 194.f; // cell 高度
static CGFloat const kCellSpace    = 1.f;   // cell 边距

@interface UserTicketCorrespondBooksVC () <UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout, UTCorrespondBookCollectionViewCellDelegate>

@property (strong, nonatomic) UICollectionView *collectionView;   // 卡券列表
@property (strong, nonatomic) UICollectionViewFlowLayout *layout; // collecition 布局

@property (strong, nonatomic) NSMutableArray *arrBooks;          // 图书数组

@property (assign, nonatomic) NSInteger currentPage;             // 当前页

@end

@implementation UserTicketCorrespondBooksVC


- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self configMJRefresh];
    [self getFirstPageBooks];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:NO animated:YES];
}

#pragma mark - 获取数据

- (void)updateSystemLanguage
{
    self.title = LOCALIZATION(@"活动图书");
    [_collectionView reloadData];
}

- (void)configMJRefresh
{
    WeakSelf(self)
    self.collectionView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        [weakself getFirstPageBooks];
    }];
    
    self.collectionView.mj_footer = [MJRefreshBackFooter footerWithRefreshingBlock:^{
        [weakself getBooksWithPage:_currentPage sort:0];
    }];
}

- (void)getFirstPageBooks
{
    _currentPage = 0;
    [self showWaitTips];
    WeakSelf(self)
    [[UserRequest sharedInstance] getTicketCorrespondBooksWithTicketType:_ticketType page:_currentPage length:cListNumber_10 sort:0 completion:^(id object, ErrorModel *error) {
        StrongSelf(self)
        [self.collectionView.mj_header endRefreshing];
        [self dismissTips];
        if (error) {
            [self presentSuccessTips:error.message];
        }
        else {
            self.arrBooks = [BookModel mj_objectArrayWithKeyValuesArray:object];
            if (self.arrBooks.count > 0) {
                self.currentPage += 1;
            }
            [self.collectionView reloadData];
        }
    }];
}

- (void)getBooksWithPage:(NSInteger)page sort:(NSInteger)sort
{
    WeakSelf(self)
    [[UserRequest sharedInstance] getTicketCorrespondBooksWithTicketType:_ticketType page:_currentPage length:cListNumber_10 sort:0 completion:^(id object, ErrorModel *error) {
        StrongSelf(self)
        [self.collectionView.mj_footer endRefreshing];
        if (error) {
            [self presentSuccessTips:error.message];
        }
        else {
            NSArray *array = [BookModel mj_objectArrayWithKeyValuesArray:object];
            if (array.count > 0) {
                self.currentPage += 1;
                [self.arrBooks addObjectsFromArray:array];
                [self.collectionView reloadData];                
            }
        }
    }];
}

#pragma mark - UICollectionViewDataSource

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return _arrBooks.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    UTCorrespondBookCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:NSStringFromClass([UTCorrespondBookCollectionViewCell class]) forIndexPath:indexPath];
    cell.delegate = self;
    cell.index = indexPath.row;
    cell.data = _arrBooks[indexPath.row];
    return cell;
}

#pragma mark - UICollectionViewDelegate

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    BookModel *book = _arrBooks[indexPath.row];
    [self toBookDetailWithBookId:book.bookId];
}

#pragma mark - UTCorrespondBookCollectionViewCellDelegate

- (void)addBookToShopCarWithBook:(BookModel *)book
{
    WeakSelf(self)
    [[ShopCarRequest sharedInstance] configShopCarWithBookId:[NSString stringWithFormat:@"%ld", (long)book.bookId]
                                                    serialId:@""
                                                     buyType:[NSString stringWithFormat:@"%ld", (long)ENUM_GetBookTypeBuy]
                                                        type:[NSString stringWithFormat:@"%ld", (long)ENUM_ShopCarActionAdd]
                                                       price:[NSString stringWithFormat:@"%.2f", book.price]
                                                     orderId:@""
                                                     readDay:@""
                                                  completion:^(id object, ErrorModel *error) {
                                                      if (error)
                                                          [weakself presentFailureTips:error.message];
                                                      else
                                                          [weakself presentSuccessTips:LOCALIZATION(@"成功添加到购物车")];
                                                  }];
}

#pragma mark - action

/** 查看图书详情 */
- (void)toBookDetailWithBookId:(NSInteger)bookId
{
    UIStoryboard *board = [UIStoryboard storyboardWithName:@"BookInfo" bundle:nil];
    ECRBookInfoViewController *bivc = [board instantiateViewControllerWithIdentifier:@"ECRBookInfoViewController"];
    bivc.viewControllerPushWay = ECRBaseControllerPushWayPush;
    bivc.bookId = bookId;
    [self.navigationController pushViewController:bivc animated:YES];
}

#pragma mark - 属性

- (UICollectionView *)collectionView
{
    if (_collectionView == nil) {
        _collectionView = [[UICollectionView alloc] initWithFrame:CGRectMake(0, 0, Screen_Width, self.view.height - cHeaderHeight_64) collectionViewLayout:self.layout];
        
        _collectionView.delegate = self;
        _collectionView.dataSource = self;
        
        _collectionView.backgroundColor = [UIColor whiteColor];
        
        [_collectionView registerNib:[UINib nibWithNibName:NSStringFromClass([UTCorrespondBookCollectionViewCell class]) bundle:nil] forCellWithReuseIdentifier:NSStringFromClass([UTCorrespondBookCollectionViewCell class])];
        
        [self.view addSubview:_collectionView];
    }
    return _collectionView;
}

- (UICollectionViewFlowLayout *)layout
{
    if (_layout == nil) {
        _layout = [[UICollectionViewFlowLayout alloc] init];
        
        _layout.minimumLineSpacing      = kCellSpace;
        _layout.minimumInteritemSpacing = kCellSpace;
        _layout.sectionInset            = UIEdgeInsetsZero;
        _layout.itemSize                = isPad ? CGSizeMake((self.view.width - kCellSpace)/2, kCellHeight) : CGSizeMake(self.view.width, kCellHeight);
    }
    return _layout;
}

- (NSMutableArray *)arrBooks
{
    if (_arrBooks == nil) {
        _arrBooks = [NSMutableArray array];
    }
    return _arrBooks;
}


@end
