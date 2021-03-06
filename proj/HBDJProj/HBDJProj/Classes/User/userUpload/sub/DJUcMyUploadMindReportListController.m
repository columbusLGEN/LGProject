//
//  DJUcMyUploadMindReportListController.m
//  HBDJProj
//
//  Created by Peanut Lee on 2018/8/31.
//  Copyright © 2018年 Lee. All rights reserved.
//

#import "DJUcMyUploadMindReportListController.h"
#import "DJThoutghtRepotListModel.h"
#import "DJThoutghtRepotListTableViewCell.h"
#import "DJUploadMindReportController.h"
#import "DJUserNetworkManager.h"
#import "DJThoughtReportDetailViewController.h"

@interface DJUcMyUploadMindReportListController ()

@end

@implementation DJUcMyUploadMindReportListController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self configUI];
}

- (void)configUI{
    
    [self.tableView registerNib:[UINib nibWithNibName:thoughtRepotrListCell bundle:nil] forCellReuseIdentifier:thoughtRepotrListCell];
    self.tableView.rowHeight = 100;
    
    UIBarButtonItem *create = [UIBarButtonItem.alloc initWithTitle:@"创建" style:UIBarButtonItemStyleDone target:self action:@selector(create)];
    self.navigationItem.rightBarButtonItem = create;
    
    [self headerFooterSet];
    
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

    [DJUserNetworkManager.sharedInstance frontUgc_selectWithUgctype:DJOnlineUGCTypeMindReport offset:self.offset  success:^(id responseObj) {
        NSArray *array = responseObj;
        BOOL arrayIsNull = (array == nil || array.count == 0);
        if (self.offset == 0) {
            [self.tableView.mj_header endRefreshing];
        }else{
            if (arrayIsNull) {
                [self.tableView.mj_footer endRefreshingWithNoMoreData];
            }else{
                [self.tableView.mj_footer endRefreshing];
            }
            
        }
        if (arrayIsNull) {
            return;
        }else{
            NSMutableArray *arrMutable;
            if (self.offset == 0) {
                arrMutable  = NSMutableArray.new;
            }else{
                arrMutable  = [NSMutableArray arrayWithArray:self.dataArray];
            }
            for (NSInteger i = 0; i < array.count; i++) {
                DJThoutghtRepotListModel *model = [DJThoutghtRepotListModel mj_objectWithKeyValues:array[i]];
                [arrMutable addObject:model];
            }
            self.dataArray = arrMutable.copy;
            self.offset = arrMutable.count;
            [[NSOperationQueue mainQueue] addOperationWithBlock:^{
                [self.tableView reloadData];
            }];
        }
        
    } failure:^(id failureObj) {
        if (self.offset == 0) {
            [self.tableView.mj_header endRefreshing];
        }else{
            [self.tableView.mj_footer endRefreshing];
            
        }
    }];
    
}

#pragma mark - target
- (void)create{
    DJUploadMindReportController *upvc = DJUploadMindReportController.new;
    upvc.pushWay = LGBaseViewControllerPushWayModal;
//    upvc.listType = _listType;
    LGBaseNavigationController *nav = [LGBaseNavigationController.alloc initWithRootViewController:upvc];
    [self presentViewController:nav animated:YES completion:nil];
}

#pragma mark - Table view data source
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.dataArray.count;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    DJThoutghtRepotListModel *model = self.dataArray[indexPath.row];
    DJThoutghtRepotListTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:thoughtRepotrListCell forIndexPath:indexPath];
    cell.ucmuModel = model;
    
    return cell;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    DJThoutghtRepotListModel *model = self.dataArray[indexPath.row];
    
    if (self.lg_edit) {
        ///  编辑状态
        model.select = !model.select;
        if ([self.delegate respondsToSelector:@selector(ucmp_mindCellClickWhenEdit:modelArrayCount:)]) {
            [self.delegate ucmp_mindCellClickWhenEdit:model modelArrayCount:self.dataArray.count];
        }
    }else{
        /// 普通状态
        DJThoughtReportDetailViewController *detailvc = DJThoughtReportDetailViewController.new;
        detailvc.trOrSp = 2;
        detailvc.model = model;
        [self.navigationController pushViewController:detailvc animated:YES];
    }
    
}

- (void)startEdit{
    self.lg_edit = YES;

    for (DJThoutghtRepotListModel *model in self.dataArray) {
        model.edit = YES;
    }
    [self.tableView reloadData];
    
    self.tableView.mj_header = nil;
    self.tableView.mj_footer = nil;
}
- (void)endEdit{
    self.lg_edit = NO;
    for (DJThoutghtRepotListModel *model in self.dataArray) {
        model.edit = NO;
        model.select = NO;
    }
    [self.tableView reloadData];
    [self headerFooterSet];
}
- (void)allSelect{
    BOOL allAlreadySelect = YES;
    for (DJThoutghtRepotListModel *model in self.dataArray) {
        if (!model.select) {
            allAlreadySelect = NO;
            break;
        }
    }
    
    BOOL select;
    if (allAlreadySelect) {
        select = NO;
        self.isAllSelect = NO;
    }else{
        select = YES;
        self.isAllSelect = YES;
    }
    
    for (DJThoutghtRepotListModel *model in self.dataArray) {
        model.select = select;
    }
    [self.tableView reloadData];
    
    if ([self.delegate respondsToSelector:@selector(ucmp_mindAllSelectClickWhenEdit:)]) {
        if (self.isAllSelect) {
            [self.delegate ucmp_mindAllSelectClickWhenEdit:self.dataArray];
        }else{
            [self.delegate ucmp_mindAllSelectClickWhenEdit:nil];
        }
    }
}

@end
