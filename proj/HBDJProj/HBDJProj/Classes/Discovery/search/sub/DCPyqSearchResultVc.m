//
//  DCPyqSearchResultVc.m
//  HBDJProj
//
//  Created by Peanut Lee on 2018/8/23.
//  Copyright © 2018年 Lee. All rights reserved.
//

#import "DCPyqSearchResultVc.h"
#import "DJDiscoveryNetworkManager.h"
#import "DCSubStageModel.h"
#import "DJDsSearchChildVcDelegate.h"

@interface DCPyqSearchResultVc ()

@end

@implementation DCPyqSearchResultVc

- (void)scrollViewDidScroll:(UIScrollView *)scrollView{
    if ([self.delegate respondsToSelector:@selector(childVcDidScroll)]) {
        [self.delegate childVcDidScroll];
    }
}

- (void)getData{
    [DJDiscoveryNetworkManager.sharedInstance frontIndex_findSearchWithContent:self.searchContent label:_tagId offset:0 type:3 success:^(id responseObj) {
        /// MARK: 刷新子可控制器视图
        NSArray *array = responseObj;
        if (array == nil || array.count == 0) {
            [self.tableView.mj_footer endRefreshingWithNoMoreData];
        }else{
            [self.tableView.mj_footer endRefreshing];
            
            NSMutableArray *arrmu  = [NSMutableArray arrayWithArray:self.dataArray];

            for (NSInteger i = 0; i < array.count; i++) {
                DCSubStageModel *model = [DCSubStageModel mj_objectWithKeyValues:array[i]];
                [arrmu addObject:model];
            }
            self.dataArray = arrmu.copy;
            self.offset = self.dataArray.count;
            
            [[NSOperationQueue mainQueue] addOperationWithBlock:^{
                [self.tableView reloadData];
            }];
        }
        
    } failure:^(id failureObj) {
        [self.tableView.mj_footer endRefreshing];
        NSLog(@"faillureObject -- %@",failureObj);
        if ([failureObj isKindOfClass:[NSError class]]) {
            [self presentFailureTips:@"网络异常"];
        }else{
            [self presentFailureTips:@"没有数据"];
        }
    }];
}

@end
