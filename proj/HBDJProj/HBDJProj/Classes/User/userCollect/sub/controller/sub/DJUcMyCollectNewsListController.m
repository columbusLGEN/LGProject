//
//  DJUcMyCollectNewsListController.m
//  HBDJProj
//
//  Created by Peanut Lee on 2018/8/29.
//  Copyright © 2018年 Lee. All rights reserved.
//

#import "DJUcMyCollectNewsListController.h"
#import "EDJMicroBuildCell.h"
#import "EDJMicroBuildModel.h"
#import "DJMediaDetailTransAssist.h"

@interface DJUcMyCollectNewsListController ()
@property (strong,nonatomic) DJMediaDetailTransAssist *transAssist;

@end

@implementation DJUcMyCollectNewsListController{
    NSInteger offset;
}

- (void)setDataArray:(NSArray *)dataArray{
    [super setDataArray:dataArray];
    
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
    
    self.tableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        self.offset = 0;
        [self.tableView.mj_footer resetNoMoreData];
        [self getData];
    }];
    
    self.tableView.mj_footer = [MJRefreshAutoNormalFooter footerWithRefreshingBlock:^{
        [self getData];
    }];
    [self.tableView.mj_header beginRefreshing];
}

- (void)headerFooterSet{
    self.tableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        self.offset = 0;
        [self.tableView.mj_footer resetNoMoreData];
        [self getData];
    }];
    
    self.tableView.mj_footer = [MJRefreshAutoNormalFooter footerWithRefreshingBlock:^{
        [self getData];
    }];
}

- (void)getData{
    [DJUserNetworkManager.sharedInstance frontUserCollections_selectWithType:2 offset:self.offset success:^(id responseObj) {
        
        if (self.offset == 0) {
            [self.tableView.mj_header endRefreshing];
        }else{
            [self.tableView.mj_footer endRefreshing];
        }
        
        
        NSArray *array_callback = responseObj;
        if (array_callback == nil || array_callback.count == 0) {
            [self.tableView.mj_footer endRefreshingWithNoMoreData];
            return;
        }else{
            
            NSMutableArray *arrmu;
            if (self.offset == 0) {
                arrmu = NSMutableArray.new;
            }else{
                arrmu = [NSMutableArray arrayWithArray:self.dataArray];
            }
            
            for (NSInteger i = 0; i < array_callback.count; i++) {
                EDJMicroBuildModel *model = [EDJMicroBuildModel mj_objectWithKeyValues:array_callback[i]];
                [arrmu addObject:model];
            }
            
            self.dataArray = arrmu.copy;
            self.offset = self.dataArray.count;
            [[NSOperationQueue mainQueue] addOperationWithBlock:^{
                [self.tableView reloadData];
            }];
        }
        
    } failure:^(id failureObj) {
        [self.tableView.mj_header endRefreshing];
        [self.tableView.mj_footer endRefreshing];
    }];
}

#pragma mark - Table view data source
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.dataArray.count;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    EDJMicroBuildModel *model = self.dataArray[indexPath.row];
    EDJMicroBuildCell *cell = [EDJMicroBuildCell cellWithTableView:tableView model:model];
    cell.collectModel = model;
    
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
    if (self.lg_edit) {
        /// 编辑状态
        DJUcMyCollectModel *model = self.dataArray[indexPath.row];
        model.select = !model.select;
        
        if ([self.delegate respondsToSelector:@selector(ucmcCellClickWhenEdit:modelArrayCount:)]) {
            [self.delegate ucmcCellClickWhenEdit:model modelArrayCount:self.dataArray.count];
        }
    }else{
        EDJMicroBuildModel *model = self.dataArray[indexPath.row];
        [self.transAssist skipWithType:2 model:model baseVc:self];
    }
    
}

- (void)startEdit{
    [super startEdit];
    
    self.tableView.mj_header = nil;
    self.tableView.mj_footer = nil;
}

- (void)endEdit{
    [super endEdit];
    [self headerFooterSet];
}

- (void)allSelect{
    [super allSelect];
    if ([self.delegate respondsToSelector:@selector(ucmcAllSelectClickWhenEdit:)]) {
        if (self.isAllSelect) {
            [self.delegate ucmcAllSelectClickWhenEdit:self.dataArray];
        }else{
            [self.delegate ucmcAllSelectClickWhenEdit:nil];
        }
    }
}

- (DJMediaDetailTransAssist *)transAssist{
    if (!_transAssist) {
        _transAssist = [DJMediaDetailTransAssist new];
    }
    return _transAssist;
}

@end
