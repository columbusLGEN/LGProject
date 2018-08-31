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

@end
