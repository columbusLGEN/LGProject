//
//  UserTicketListVC.m
//  EasyChineseReading-ios
//
//  Created by 赵春阳 on 2017/9/28.
//  Copyright © 2017年 retech. All rights reserved.
//

#import "UserTicketListVC.h"

#import "UTicketCollectionViewCell.h"

#import "UserTicketCorrespondBooksVC.h"

static CGFloat const kCellHeight   = 108.f; // cell 高度
static CGFloat const kCellSpace    = 36.f;  // cell 边距

@interface UserTicketListVC () <UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout>

@property (strong, nonatomic) UICollectionView *collectionView;   // 卡券列表
@property (strong, nonatomic) UICollectionViewFlowLayout *layout; // collecition 布局

@property (strong, nonatomic) NSMutableArray *arrTickets;         // 卡券数组

@property (strong, nonatomic) EmptyView *emptyView;  // 没有卡券

@end

@implementation UserTicketListVC

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self addEmptyView];
    [self getTickets];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:NO animated:YES];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)updateSystemLanguage
{
    self.title = LOCALIZATION(@"我的卡券");
    [_collectionView reloadData];
}

#pragma mark - 界面布局

- (void)addEmptyView
{
    _emptyView = [EmptyView loadFromNibWithFrame:CGRectMake(0, 0, Screen_Width, self.view.height)];
    [_emptyView updateEmptyViewWithType:ENUM_EmptyResultTypeTicket Image:nil desc:nil subDesc:nil];
    [self.view addSubview:_emptyView];
}

#pragma mark - 获取数据

- (void)getTickets
{
    [self showWaitTips];
    WeakSelf(self)
    [[UserRequest sharedInstance] getMyTicketsWithCompletion:^(id object, ErrorModel *error) {
        StrongSelf(self)
        [self dismissTips];
        if (error) {
            [self presentFailureTips:error.message];
        }
        else {
            self.arrTickets = [TicketModel mj_objectArrayWithKeyValuesArray:object];
            self.emptyView.hidden = self.arrTickets.count > 0;
            if (self.arrTickets.count > 0) {
                [self.collectionView reloadData];
            }
        }
    }];
}

#pragma mark - UICollectionViewDataSource

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return _arrTickets.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    UTicketCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:NSStringFromClass([UTicketCollectionViewCell class]) forIndexPath:indexPath];
    cell.myTicket = YES;
    cell.data = _arrTickets[indexPath.row];
    return cell;
}

#pragma mark - UICollectionViewDelegate

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    TicketModel *ticket = _arrTickets[indexPath.row];

    UserTicketCorrespondBooksVC *booksVC = [UserTicketCorrespondBooksVC new];
    booksVC.ticketType = ticket.fullminusType;
    [self.navigationController pushViewController:booksVC animated:YES];
}

#pragma mark - 属性

- (UICollectionView *)collectionView
{
    if (_collectionView == nil) {
        _collectionView = [[UICollectionView alloc] initWithFrame:CGRectMake(0, 0, Screen_Width, self.view.height) collectionViewLayout:self.layout];
        _collectionView.delegate = self;
        _collectionView.dataSource = self;
        _collectionView.backgroundColor = [UIColor whiteColor];
        
        [_collectionView registerNib:[UINib nibWithNibName:NSStringFromClass([UTicketCollectionViewCell class]) bundle:nil] forCellWithReuseIdentifier:NSStringFromClass([UTicketCollectionViewCell class])];
        
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
        _layout.sectionInset            = UIEdgeInsetsMake(kCellSpace, kCellSpace, kCellSpace, kCellSpace);
        _layout.itemSize                = isPad ? CGSizeMake((self.view.width - kCellSpace * 3)/2, kCellHeight) : CGSizeMake(self.view.width - kCellSpace * 2, kCellHeight);
    }
    return _layout;
}

- (NSMutableArray *)arrTickets
{
    if (_arrTickets == nil) {
        _arrTickets = [NSMutableArray array];
    }
    return _arrTickets;
}

@end
