//
//  DJTestScoreListTableViewController.m
//  HBDJProj
//
//  Created by Peanut Lee on 2018/7/9.
//  Copyright © 2018年 Lee. All rights reserved.
//

#import "DJTestScoreListTableViewController.h"
#import "DJTestScoreListModel.h"
#import "DJTestScoreListTableViewCell.h"
#import "DJTestScoreListHeader.h"
#import "DJTestScoreListHeader.h"

static CGFloat const bottomInset = 50;

@interface DJTestScoreListTableViewController ()<
UITableViewDelegate,
UITableViewDataSource>
@property (strong,nonatomic) UITableView *tableView;
@property (strong,nonatomic) NSArray *dataArray;

@end

@implementation DJTestScoreListTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self.view addSubview:self.tableView];
    [self.tableView registerNib:[UINib nibWithNibName:testScoreListHeader bundle:nil] forHeaderFooterViewReuseIdentifier:testScoreListHeader];
    [self.tableView registerNib:[UINib nibWithNibName:testScoreListCell bundle:nil] forCellReuseIdentifier:testScoreListCell];
    self.tableView.rowHeight = 40;
    self.tableView.sectionHeaderHeight = 40;
    
    CGFloat buttonWidth = kScreenWidth * 0.6;
    CGFloat buttonHeight = 40;
    CGFloat buttonX = (kScreenWidth - buttonWidth) / 2;
    CGFloat buttonY = kScreenHeight - bottomInset + 5;
    UIButton *footerButton = [UIButton.alloc initWithFrame:CGRectMake(buttonX, buttonY, buttonWidth, buttonHeight)];
    [footerButton cutBorderWithBorderWidth:0 borderColor:0 cornerRadius:footerButton.height * 0.5];
    [footerButton setBackgroundColor:UIColor.EDJMainColor];
    [footerButton setTitleColor:UIColor.whiteColor forState:UIControlStateNormal];
    [footerButton setTitle:@"个人测试成绩" forState:UIControlStateNormal];
    [footerButton addTarget:self action:@selector(personalScore:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:footerButton];
    
    NSMutableArray *tempArray = NSMutableArray.new;
    for (int i = 0; i < 30; i++) {
        DJTestScoreListModel *testModel = DJTestScoreListModel.new;
        testModel.rank = [NSString stringWithFormat:@"%d",i];
        testModel.name = @"党伟大";
        testModel.timeConsume = @"1分02秒";
        testModel.correctRate = @"0.9876";
        [tempArray addObject:testModel];
    }
    self.dataArray = tempArray.copy;
    [self.tableView reloadData];
    
}
- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:NO animated:YES];
}

- (void)personalScore:(id)sender{
    NSLog(@"查看个人成绩");
}

#pragma mark - Table view data source
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.dataArray.count;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    DJTestScoreListTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:testScoreListCell];
    return cell;
}
- (void)tableView:(UITableView *)tableView willDisplayCell:(DJTestScoreListTableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath{
    DJTestScoreListModel *model = self.dataArray[indexPath.row];
    cell.model = model;
}
- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    DJTestScoreListHeader *header = [tableView dequeueReusableHeaderFooterViewWithIdentifier:testScoreListHeader];
    return header;
}

- (UITableView *)tableView{
    if (!_tableView) {
        _tableView = [UITableView.alloc initWithFrame:CGRectMake(0, 0, kScreenWidth, kScreenHeight - bottomInset) style:UITableViewStylePlain];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        
    }
    return _tableView;
}

@end
