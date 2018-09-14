//
//  HPSearchBuildPoineNewsController.m
//  HBDJProj
//
//  Created by Peanut Lee on 2018/6/12.
//  Copyright © 2018年 Lee. All rights reserved.
//

#import "HPSearchBuildPoineNewsController.h"

#import "EDJMicroBuildCell.h"
#import "EDJMicroBuildModel.h"

#import "DJMediaDetailTransAssist.h"

@interface HPSearchBuildPoineNewsController ()

@property (strong,nonatomic) DJMediaDetailTransAssist *transAssist;

@end

@implementation HPSearchBuildPoineNewsController{
    NSInteger offset;
}

@synthesize dataArray = _dataArray;

- (void)setDataArray:(NSArray *)dataArray{
    _dataArray = dataArray;
    offset = dataArray.count;
    [self.tableView.mj_footer resetNoMoreData];
    [[NSOperationQueue mainQueue] addOperationWithBlock:^{
        [self.tableView reloadData];
    }];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    /// EDJMicroBuildCell
    [self.tableView registerNib:[UINib nibWithNibName:buildCellNoImg bundle:nil] forCellReuseIdentifier:buildCellNoImg];
    [self.tableView registerNib:[UINib nibWithNibName:buildCellOneImg bundle:nil] forCellReuseIdentifier:buildCellOneImg];
    [self.tableView registerNib:[UINib nibWithNibName:buildCellThreeImg bundle:nil] forCellReuseIdentifier:buildCellThreeImg];
    
    self.tableView.mj_footer = [MJRefreshAutoNormalFooter footerWithRefreshingTarget:self refreshingAction:@selector(loadData)];
}

- (void)loadData{
    [DJHomeNetworkManager homeSearchWithString:_searchContent type:2 offset:offset length:1 sort:0 success:^(id responseObj) {
        NSLog(@"homesearch_loadmore_lesson: %@",responseObj);
        NSArray *array = (NSArray *)responseObj;
        
        if (array == nil || array.count == 0) {
            [self.tableView.mj_footer endRefreshingWithNoMoreData];
        }else{
            [self.tableView.mj_footer endRefreshing];
            
            NSMutableArray *arrayMutable = [NSMutableArray arrayWithArray:self.dataArray];
            for (int i = 0; i < array.count; i++) {
                id obj = array[i];
                EDJMicroBuildModel *model = [EDJMicroBuildModel mj_objectWithKeyValues:obj];
                [arrayMutable addObject:model];
            }
            
            self.dataArray = arrayMutable.copy;
            [[NSOperationQueue mainQueue] addOperationWithBlock:^{
                [self.tableView reloadData];
            }];
            
        }
    } failure:^(id failureObj) {
        [self.tableView.mj_footer endRefreshing];
        NSLog(@"homesearch_loadmore_lesson_failure -- %@",failureObj);
        
    }];
}

#pragma mark - Table view data source
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    return self.dataArray.count;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    EDJMicroBuildModel *model = self.dataArray[indexPath.row];
    EDJMicroBuildCell *cell = [EDJMicroBuildCell cellWithTableView:tableView model:model];
    return cell;
}

- (void)tableView:(UITableView *)tableView willDisplayCell:(EDJMicroBuildCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath{
    EDJMicroBuildModel *model = self.dataArray[indexPath.row];
    cell.model = model;
}


- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    CGFloat height = [EDJMicroBuildCell cellHeightWithModel:self.dataArray[indexPath.row]];
    return height;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    EDJMicroBuildModel *model = self.dataArray[indexPath.row];
    [self.transAssist skipWithType:2 model:model baseVc:self dataSyncer:self.dataSyncer];
    
}

- (DJMediaDetailTransAssist *)transAssist{
    if (!_transAssist) {
        _transAssist = [DJMediaDetailTransAssist new];
    }
    return _transAssist;
}

@end
