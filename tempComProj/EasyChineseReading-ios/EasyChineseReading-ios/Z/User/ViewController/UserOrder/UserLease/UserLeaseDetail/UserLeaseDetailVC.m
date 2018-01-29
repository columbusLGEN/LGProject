//
//  UserLeaseDetailVC.m
//  EasyChineseReading-ios
//
//  Created by 赵春阳 on 2017/10/27.
//  Copyright © 2017年 retech. All rights reserved.
//

#import "UserLeaseDetailVC.h"
#import "ECRBookInfoViewController.h"

#import "ECRMoreBooksCell.h"
#import "UserLeaseDetailTableViewCell.h"

@interface UserLeaseDetailVC () <UITableViewDelegate, UITableViewDataSource>

@property (strong, nonatomic) UITableView *tableView;

@property (strong, nonatomic) NSMutableArray *arrLeases;
@property (strong, nonatomic) NSMutableArray *arrTicket;

@property (assign, nonatomic) NSInteger currentLeasePage;
@property (assign, nonatomic) NSInteger currentTicketPage;

@end

@implementation UserLeaseDetailVC

- (void)viewDidLoad {
    [super viewDidLoad];
    [self configLeaseDetailView];
    // 根据传入的数据模型，判断获取哪一种数据
    if (_serial)
        [self getFirstPageLeases];
    else if (_ticket)
        [self getFirstTicketBooks];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

#pragma mark - 配置界面

- (void)updateSystemLanguage
{
    if (_serial) {
        self.title = [UserRequest sharedInstance].language == ENUM_LanguageTypeChinese ? _serial.serialName : _serial.serialName;
    }
    else if (_ticket){
        self.title = LOCALIZATION(@"包月");
    }
}

- (void)configLeaseDetailView
{
    _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, Screen_Width, Screen_Height - cHeaderHeight_64) style:UITableViewStylePlain];
    _tableView.delegate = self;
    _tableView.dataSource = self;
    
    _tableView.backgroundColor = [UIColor whiteColor];
    _tableView.rowHeight = 150.f;
    
    UIView *footer = [UIView new];
    footer.backgroundColor = [UIColor whiteColor];
    _tableView.tableFooterView = footer;
    
    [self.view addSubview:_tableView];
    
    [_tableView registerNib:[UINib nibWithNibName:NSStringFromClass([ECRMoreBooksCell class]) bundle:nil] forCellReuseIdentifier:NSStringFromClass([ECRMoreBooksCell class])];
    [_tableView registerNib:[UINib nibWithNibName:NSStringFromClass([UserLeaseDetailTableViewCell class]) bundle:nil] forCellReuseIdentifier:NSStringFromClass([UserLeaseDetailTableViewCell class])];
}


- (void)configMJRefresh
{
    WeakSelf(self)
    _tableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        StrongSelf(self)
        self.serial ? [self getFirstPageLeases] : [self getFirstTicketBooks];
    }];
    _tableView.mj_footer = [MJRefreshBackNormalFooter footerWithRefreshingBlock:^{
        StrongSelf(self)
        self.serial ? [self getLeasesWithPage] : [self getTicketBooksWithPage];
    }];
}

#pragma mark - 获取数据

/** 获取第一页包月数据 */
- (void)getFirstPageLeases
{
    _currentLeasePage = 0;
    [self showWaitTips];
    WeakSelf(self)
    [[BookRequest sharedInstance] getSeriesBooksWithPage:_currentLeasePage length:cListNumber_10 series:_serial.serialId Completion:^(id object, ErrorModel *error) {
        StrongSelf(self)
        [self dismissTips];
        if (error) {
            [self presentFailureTips:error.message];
        }
        else {
            self.arrLeases = [BookModel mj_objectArrayWithKeyValuesArray:object];
            if (self.arrLeases.count > 0) {
                self.currentLeasePage += 1;
            }
            [self.tableView reloadData];
        }
    }];
}

/** 获取更多包月数据 */
- (void)getLeasesWithPage
{
    WeakSelf(self)
    [[BookRequest sharedInstance] getSeriesBooksWithPage:_currentLeasePage length:cListNumber_10 series:_serial.serialId Completion:^(id object, ErrorModel *error) {
        StrongSelf(self)
        if (error) {
            [self presentFailureTips:error.message];
        }
        else {
            NSArray *array = [BookModel mj_objectArrayWithKeyValuesArray:object];
            if (array.count > 0) {
                self.currentLeasePage += 1;
                [self.arrLeases addObjectsFromArray:array];
                [self.tableView reloadData];
            }
        }
    }];
}

/** 获取第一页卡券兑换的数据 */
- (void)getFirstTicketBooks
{
    _currentTicketPage = 0;
    [self showWaitTips];
    WeakSelf(self)
    [[OrderRequest sharedInstance] getTicketBooksWithGrantbatchId:_ticket.grantbatchId page:_currentTicketPage length:cListNumber_10 completion:^(id object, ErrorModel *error) {
        StrongSelf(self)
        [self dismissTips];
        if (error) {
            [self presentFailureTips:error.message];
        }
        else {
            self.arrTicket = [BookModel mj_objectArrayWithKeyValuesArray:object];
            if (self.arrTicket.count > 0) {
                self.currentTicketPage += 1;
            }
            [self.tableView reloadData];
        }
    }];
}

/** 获取更多卡券兑换的数据 */
- (void)getTicketBooksWithPage
{
    WeakSelf(self)
    [[OrderRequest sharedInstance] getTicketBooksWithGrantbatchId:_ticket.grantbatchId page:_currentTicketPage length:cListNumber_10 completion:^(id object, ErrorModel *error) {
        StrongSelf(self)
        NSArray *array = [BookModel mj_objectArrayWithKeyValuesArray:object];
        if (array.count > 0) {
            self.currentTicketPage += 1;
            [self.arrTicket addObjectsFromArray:array];
            [self.tableView reloadData];
        }
    }];
}

#pragma mark - UITableViewDataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return _serial ? _arrLeases.count : _arrTicket.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    ECRMoreBooksCell *ticketCell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([ECRMoreBooksCell class])];
    UserLeaseDetailTableViewCell *leaseCell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([UserLeaseDetailTableViewCell class])];
    if (_serial) {
        leaseCell.data = _arrLeases[indexPath.row];
        return leaseCell;
    }
    else {
        ticketCell.model = _arrTicket[indexPath.row];
        return ticketCell;
    }
}

#pragma mark - UITableViewDelegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    UIStoryboard *board = [UIStoryboard storyboardWithName:@"BookInfo" bundle:nil];
    ECRBookInfoViewController *bivc = [board instantiateViewControllerWithIdentifier:@"ECRBookInfoViewController"];
    bivc.viewControllerPushWay = ECRBaseControllerPushWayPush;
    BookModel *book = [BookModel mj_objectWithKeyValues:_serial ? _arrLeases[indexPath.row] : _arrTicket[indexPath.row]];
    bivc.bookId = book.bookId;
    [self.navigationController pushViewController:bivc animated:YES];
}

#pragma mark - 属性

- (NSMutableArray *)arrLeases
{
    if (_arrLeases == nil) {
        _arrLeases = [NSMutableArray array];
    }
    return _arrLeases;
}

- (NSMutableArray *)arrTicket
{
    if (_arrTicket == nil) {
        _arrTicket = [NSMutableArray array];
    }
    return _arrTicket;
}

@end
