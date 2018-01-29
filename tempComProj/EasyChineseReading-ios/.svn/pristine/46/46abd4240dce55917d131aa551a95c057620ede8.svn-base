//
//  ECRRentSeriousViewController.m
//  EasyChineseReading-ios
//
//  Created by Peanut Lee on 2017/10/9.
//  Copyright © 2017年 retech. All rights reserved.
//

#import "ECRRentSeriousViewController.h"
#import "ECRMoreBooksCell.h"
#import "ECRBookListModel.h"
#import "ECRBookInfoModel.h"
#import "UserLeaseSelectedVC.h"
#import "ECRBookFormViewController.h"
#import "ECRBookInfoViewController.h"

static CGFloat  listCellH = 150;// 图示列表cell高度
static NSString *cellID = @"ECRMoreBooksCell";

@interface ECRRentSeriousViewController ()<
UITableViewDelegate,
UITableViewDataSource
>
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (weak, nonatomic) IBOutlet UIButton *doneButton;// 租阅此系列
@property (weak, nonatomic) IBOutlet UIButton *buySeries;// 购买此系列
@property (strong,nonatomic) NSArray *array;//
@property (assign,nonatomic) NSInteger requestLength;//
@property (assign,nonatomic) NSInteger requestPage;//

@end

@implementation ECRRentSeriousViewController

- (void)setModel:(ECRBookInfoModel *)model{
    _model = model;
    [self loadNewData];
    
}

- (void)textDependsLauguage{
//    self.title = [LGPChangeLanguage localizedStringForKey:@"系列包月"];
    self.title = [LGPChangeLanguage localizedStringForKey:@"系列"];
    [self.doneButton setTitle:[LGPChangeLanguage localizedStringForKey:@"系列包月"] forState:UIControlStateNormal];
    [self.buySeries setTitle:[LGPChangeLanguage localizedStringForKey:@"购买"] forState:UIControlStateNormal];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self  setupUI];
}

- (void)loadNewData{
    [ECRDataHandler selectBuySeriesWithSeries:self.model.serialId success:^(id object) {
        NSLog(@"请求系列全部书object -- %@",object);
        self.array = [NSMutableArray arrayWithArray:object];
        NSLog(@"page_more -- %ld",self.requestPage);
        [[NSOperationQueue mainQueue] addOperationWithBlock:^{
            [self.tableView.mj_header endRefreshing];
            [self.tableView reloadData];
        }];
    } failure:^(NSString *msg) {
        [self.tableView.mj_header endRefreshing];
    } commenFailure:^(NSError *error) {
        [self.tableView.mj_header endRefreshing];
    }];
}

- (void)setupUI{
    [self textDependsLauguage];
    [self.tableView registerNib:[UINib nibWithNibName:cellID bundle:nil] forCellReuseIdentifier:cellID];
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    
    MJRefreshNormalHeader *header = [MJRefreshNormalHeader headerWithRefreshingTarget:self refreshingAction:@selector(loadNewData)];
    self.tableView.mj_header = header;
    
//    MJRefreshAutoNormalFooter *footer = [MJRefreshAutoNormalFooter footerWithRefreshingTarget:self refreshingAction:@selector(loadMoreData)];
//    self.tableView.mj_footer = footer;
    
    self.tableView.estimatedRowHeight = 0;
    self.tableView.estimatedSectionHeaderHeight = 0;
    self.tableView.estimatedSectionFooterHeight = 0;
    
    self.buySeries.layer.borderWidth = 1;
    self.buySeries.layer.borderColor = [UIColor cm_mainColor].CGColor;
    [self.buySeries setTitleColor:[UIColor cm_mainColor] forState:UIControlStateNormal];
    self.doneButton.backgroundColor = [UIColor cm_mainColor];
}


// MARK: 购买该系列所有书
- (IBAction)butButtonClick:(UIButton *)sender {
    [self userOnLine:^{
        ECRBookFormViewController *dFormDetail = [[ECRBookFormViewController alloc] init];
        dFormDetail.viewControllerPushWay = ECRBaseControllerPushWayPush;
        dFormDetail.tickedArray = self.array;
        // TODO: 系列书籍 总价
        CGFloat totalPrice = 0;
        for (NSInteger i = 0; i < self.array.count; i++) {
            ECRBookListModel *book = self.array[i];
            totalPrice += book.price;
        }
        dFormDetail.tickedPrice = totalPrice;
        [self.navigationController pushViewController:dFormDetail animated:YES];
    } offLine:nil];
}

// MARK: 租阅结算
- (IBAction)doneButtonClick:(UIButton *)sender{
//    NSLog(@"点击系列包月 -- ");
    [self userOnLine:^{
        // 跳转 系列包月
        UserLeaseSelectedVC *leaseSelectedVC = [UserLeaseSelectedVC new];
        leaseSelectedVC.payPurpose = ENUM_PayPurposeContinue;
        SerialModel *series = [SerialModel new];
        series.serialId = self.model.serialId;
        leaseSelectedVC.serial = series;
        [self.navigationController pushViewController:leaseSelectedVC animated:YES];
    } offLine:nil];
}

#pragma mark - UITableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return _array.count;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    ECRBookListModel *model = _array[indexPath.row];
    ECRMoreBooksCell *cell = [tableView dequeueReusableCellWithIdentifier:cellID];
    
    cell.model = model;
    return cell;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return listCellH;
}
#pragma mark - UITableViewDelegate
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    BookModel *book = self.array[indexPath.row];
    UIStoryboard *board = [UIStoryboard storyboardWithName:@"BookInfo" bundle:nil];
    ECRBookInfoViewController *bivc = [board instantiateViewControllerWithIdentifier:@"ECRBookInfoViewController"];
    bivc.viewControllerPushWay = ECRBaseControllerPushWayPush;
    bivc.bookId = book.bookId;
    [self.navigationController pushViewController:bivc animated:YES];
    
}
- (NSInteger)requestLength{
    return 100;
}

@end
