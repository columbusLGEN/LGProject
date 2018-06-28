//
//  HPPointNewsTableViewController.m
//  HBDJProj
//
//  Created by Peanut Lee on 2018/4/28.
//  Copyright © 2018年 Lee. All rights reserved.
//

#import "HPPointNewsTableViewController.h"
#import "HPPartyBuildDetailViewController.h"
#import "HPPointNewsHeader.h"
#import "EDJMicroBuildCell.h"
#import "EDJMicroBuildModel.h"
#import "EDJHomeImageLoopModel.h"

@interface HPPointNewsTableViewController ()
@property (assign,nonatomic) NSInteger offset;

@end

@implementation HPPointNewsTableViewController

- (void)setModel:(EDJHomeImageLoopModel *)model{
    _model = model;
    HPPointNewsHeader *header = (HPPointNewsHeader *)self.tableView.tableHeaderView;
    header.model = model;
    
    [self loadData];
    
}

- (void)loadData{
    [DJHomeNetworkManager homeChairmanPoineNewsClassid:_model.seqid offset:_offset length:10 sort:1 success:^(id responseObj) {
        
        NSArray *array = responseObj;
        
        if (array == nil || array.count == 0) {
            [self.tableView.mj_footer endRefreshingWithNoMoreData];
        }else{
            [self.tableView.mj_footer endRefreshing];
            NSMutableArray *arrmu;
            
            if (_offset == 0) {
                arrmu = [NSMutableArray array];
            }else{
                arrmu = [NSMutableArray arrayWithArray:self.dataArray];
            }
            
            for (int i = 0; i < array.count; i++) {
                NSDictionary *obj = array[i];
                EDJMicroBuildModel *model = [EDJMicroBuildModel mj_objectWithKeyValues:obj];
                [arrmu addObject:model];
            }
            
            self.dataArray = arrmu.copy;
            _offset = self.dataArray.count;
            
            [[NSOperationQueue mainQueue] addOperationWithBlock:^{
                [self.tableView reloadData];
            }];
        }
        
    } failure:^(id failureObj) {
        [self.tableView.mj_footer endRefreshing];
        NSLog(@"homeChairmanPoineNewsClassid -- %@",failureObj);
        
    }];
}


- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:NO animated:YES];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    _offset = 0;
    
    HPPointNewsHeader *header = [HPPointNewsHeader pointNewsHeader];
    self.tableView.tableHeaderView = header;
    self.tableView.tableHeaderView.frame = CGRectMake(0, 0, kScreenWidth, 233);
    
    [self.tableView registerNib:[UINib nibWithNibName:buildCellNoImg bundle:nil] forCellReuseIdentifier:buildCellNoImg];
    [self.tableView registerNib:[UINib nibWithNibName:buildCellOneImg bundle:nil] forCellReuseIdentifier:buildCellOneImg];
    [self.tableView registerNib:[UINib nibWithNibName:buildCellThreeImg bundle:nil] forCellReuseIdentifier:buildCellThreeImg];
    
    self.tableView.mj_footer = [MJRefreshAutoNormalFooter footerWithRefreshingTarget:self refreshingAction:@selector(loadData)];
    
}

#pragma mark - Table view data source
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.dataArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    EDJMicroBuildModel *model = self.dataArray[indexPath.row];
    EDJMicroBuildCell *cell = [EDJMicroBuildCell cellWithTableView:tableView model:model];
    cell.model = model;
    return cell;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    EDJMicroBuildModel *model = self.dataArray[indexPath.row];
    return [EDJMicroBuildCell cellHeightWithModel:model];
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    EDJMicroBuildModel *model = self.dataArray[indexPath.row];
    [HPPartyBuildDetailViewController buildVcPushWith:model baseVc:self];
//    HPPartyBuildDetailViewController *dvc = [HPPartyBuildDetailViewController new];
//    dvc.coreTextViewType = LGCoreTextViewTypePoint;
//    [self.navigationController pushViewController:dvc animated:YES];
}


@end
