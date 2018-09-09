//
//  DJUcMyUploadCheapSpeechListController.m
//  HBDJProj
//
//  Created by Peanut Lee on 2018/8/31.
//  Copyright © 2018年 Lee. All rights reserved.
//

#import "DJUcMyUploadCheapSpeechListController.h"
#import "DJUserNetworkManager.h"
#import "DJThoutghtRepotListModel.h"
#import "DJThoughtReportDetailViewController.h"

@interface DJUcMyUploadCheapSpeechListController ()

@end

@implementation DJUcMyUploadCheapSpeechListController

- (void)getData{

    [DJUserNetworkManager.sharedInstance frontUgc_selectWithUgctype:DJOnlineUGCTypeComponce offset:self.offset success:^(id responseObj) {
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
        detailvc.trOrSp = 4;
        detailvc.model = model;
        [self.navigationController pushViewController:detailvc animated:YES];
    }
    
}

@end
