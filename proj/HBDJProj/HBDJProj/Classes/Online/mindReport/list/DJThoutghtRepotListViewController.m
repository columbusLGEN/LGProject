//
//  DJThoutghtRepotListViewController.m
//  HBDJProj
//
//  Created by Peanut Lee on 2018/7/11.
//  Copyright © 2018年 Lee. All rights reserved.
//

#import "DJThoutghtRepotListViewController.h"
#import "DJThoutghtRepotListModel.h"
#import "DJThoutghtRepotListTableViewCell.h"
#import "DJUploadMindReportController.h"
#import "DJOnlineNetorkManager.h"
#import "DJThoughtReportDetailViewController.h"

@interface DJThoutghtRepotListViewController ()
@property (assign,nonatomic) NSInteger offset;

@end

@implementation DJThoutghtRepotListViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self configUI];
    [self getNetDataWithOffset:0];
}
- (void)getNetDataWithOffset:(NSInteger)offset{
    /// request data
//    NSLog(@"self.listtype: %lu",(unsigned long)self.listType);
    NSLog(@"党建述职思想汇报offset: %ld",offset);
    
    /**
     listType
        思想汇报 -- 6
        党建述职 -- 7
     */
    /**
     DJOnlineUGCType
        思想汇报 -- 2
        党建述职 -- 3
     */
    [DJOnlineNetorkManager.sharedInstance frontUgcWithType:(self.listType - 4) offset:offset length:10 success:^(id responseObj) {
        NSArray *array = responseObj;
        BOOL arrayIsNull = (array == nil || array.count == 0);
        if (offset == 0) {
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
            if (_offset == 0) {
                arrMutable  = NSMutableArray.new;
            }else{
                arrMutable  = [NSMutableArray arrayWithArray:self.dataArray];
            }
            for (NSInteger i = 0; i < array.count; i++) {
                DJThoutghtRepotListModel *model = [DJThoutghtRepotListModel mj_objectWithKeyValues:array[i]];
                [arrMutable addObject:model];
            }
            self.dataArray = arrMutable.copy;
            _offset = arrMutable.count;
            [[NSOperationQueue mainQueue] addOperationWithBlock:^{
                [self.tableView reloadData];
            }];
        }
        
    } failure:^(id failureObj) {
        if (offset == 0) {
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
    upvc.listType = _listType;
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
    cell.model = model;
    
    return cell;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    DJThoutghtRepotListModel *model = self.dataArray[indexPath.row];
    DJThoughtReportDetailViewController *detailvc = DJThoughtReportDetailViewController.new;
    if (self.listType == 6) {
        detailvc.trOrSp = 2;
    }
    if (self.listType == 7) {
        detailvc.trOrSp = 4;
    }
    detailvc.model = model;
    [self.navigationController pushViewController:detailvc animated:YES];
}

- (void)configUI{
    
    [self.tableView registerNib:[UINib nibWithNibName:thoughtRepotrListCell bundle:nil] forCellReuseIdentifier:thoughtRepotrListCell];
    self.tableView.rowHeight = 100;
    
    UIBarButtonItem *create = [UIBarButtonItem.alloc initWithTitle:@"创建" style:UIBarButtonItemStyleDone target:self action:@selector(create)];
    self.navigationItem.rightBarButtonItem = create;
    
    self.tableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        _offset = 0;
        [self getNetDataWithOffset:_offset];
    }];
    self.tableView.mj_footer = [MJRefreshAutoNormalFooter footerWithRefreshingBlock:^{
        [self getNetDataWithOffset:_offset];
    }];
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:NO animated:YES];
}
@end
