//
//  UserTicketCenterVC.m
//  EasyChineseReading-ios
//
//  Created by 赵春阳 on 2017/10/23.
//  Copyright © 2017年 retech. All rights reserved.
//

#import "UserTicketCenterVC.h"

#import "UTicketCollectionViewCell.h"

#import "UserTicketCorrespondBooksVC.h"

static CGFloat const kCellHeight = 108.f; // cell 高度
static CGFloat const kCellSpace  = 36.f;  // cell 边距

@interface UserTicketCenterVC () <UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout>

@property (strong, nonatomic) UICollectionView *collectionView;   // 卡券列表
@property (strong, nonatomic) UICollectionViewFlowLayout *layout; // collecition 布局

@property (assign, nonatomic) CGFloat headerHeight;

@end

@implementation UserTicketCenterVC

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = LOCALIZATION(@"领券中心");
    [self configHeaderView];
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

#pragma mark - 界面布局

- (void)configHeaderView
{
    _headerHeight = isPad ? 240.f : 120.f; // 顶部图片高度

    UIImageView *imgView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, Screen_Width, _headerHeight)];
    imgView.image = [UIImage imageNamed:@"img_ticket_header"];
    [self.view addSubview:imgView];
}

#pragma mark - 获取数据

- (void)getTickets
{
    [self showWaitTips];
    WeakSelf(self)
    [[UserRequest sharedInstance] getAllTicketesWithCompletion:^(id object, ErrorModel *error) {
        StrongSelf(self)
        [self dismissTips];
        if (error) {
            [self presentFailureTips:error.message];
        }
        else {
            self.arrTickets = [TicketModel mj_objectArrayWithKeyValuesArray:object];
            [self.collectionView reloadData];            
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
    cell.data = _arrTickets[indexPath.row];
    return cell;
}

#pragma mark - UICollectionViewDelegate

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    TicketModel *ticket = _arrTickets[indexPath.row];
    if (ticket.status == ENUM_TicketStatusHaveNot && ticket.receiveNum < ticket.totalNum)
        [self getTicketWithTicket:ticket indexPath:indexPath];
    else
        [self userTicketWithType:ticket.fullminusType];
}

#pragma mark - action

- (void)userTicketWithType:(NSString *)ticketType
{
    UserTicketCorrespondBooksVC *booksVC = [UserTicketCorrespondBooksVC new];
    booksVC.ticketType = ticketType;
    [self.navigationController pushViewController:booksVC animated:YES];
}

- (void)getTicketWithTicket:(TicketModel *)ticket indexPath:(NSIndexPath *)indexPath
{
    WeakSelf(self)
    [[UserRequest sharedInstance] getTicketWithTicketId:ticket.seqid completion:^(id object, ErrorModel *error) {
        StrongSelf(self)
        if (error) {
            [self presentFailureTips:error.message];
        }
        else {
            ticket.status = ENUM_TicketStatusHave;
            ticket.receiveNum += 1;
            UTicketCollectionViewCell *cell = (UTicketCollectionViewCell *)[self.collectionView cellForItemAtIndexPath:indexPath];
            cell.data = ticket;
            [self.collectionView reloadItemsAtIndexPaths:@[indexPath]];
            [self presentSuccessTips:LOCALIZATION(@"领取成功")];
        }
    }];
}

#pragma mark - 属性

- (UICollectionView *)collectionView
{
    if (_collectionView == nil) {
        _collectionView = [[UICollectionView alloc] initWithFrame:CGRectMake(0, _headerHeight, Screen_Width, self.view.height - _headerHeight) collectionViewLayout:self.layout];
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
