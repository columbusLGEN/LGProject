//
//  UIViewController+Extension.m
//  HBDJProj
//
//  Created by Peanut Lee on 2018/4/12.
//  Copyright © 2018年 Lee. All rights reserved.
//

#import "UIViewController+Extension.h"

@implementation UIViewController (Extension)

/// 该方法意图封装统一处理列表控制器统一处理网络成功回调数据，但是由于未知原因有bug，暂时不用
//- (NSArray *)callBackCommenHandleWithOffset:(NSInteger)offset tableView:(UITableView *)tableView keyvalueArray:(NSArray *)keyvalueArray dataArray:(NSArray *)dataArray modelClass:(NSString *)modelClass{
//    // 1.offset
//    if (offset == 0) {
//        // 2.tableview
//        [tableView.mj_header endRefreshing];
//    }else{
//        [tableView.mj_footer endRefreshing];
//    }
//    
//    // 3.responseObje( array )
//    if (keyvalueArray == nil || keyvalueArray.count == 0) {
//        [tableView.mj_footer endRefreshingWithNoMoreData];
//    }else{
//        
//        NSMutableArray *arrmu;
//        if (offset == 0) {
//            arrmu = NSMutableArray.new;
//        }else{
//            arrmu = [NSMutableArray arrayWithArray:dataArray];
//        }
//        // 4.modelClass
//        for (NSInteger i = 0; i < keyvalueArray.count; i++) {
//            id model = [NSClassFromString(modelClass) mj_objectWithKeyValues:keyvalueArray[i]];
//            [arrmu addObject:model];
//        }
//        // 5.return arrmu.copy
//        dataArray = arrmu.copy;
//        offset = dataArray.count;
//        
//    }
//    return dataArray;
//    
//}

- (UIViewController *)lgInstantiateViewControllerWithStoryboardName:(NSString *)name controllerId:(NSString *)controllerId{
    return [[UIStoryboard storyboardWithName:name bundle:nil] instantiateViewControllerWithIdentifier:controllerId];
}

- (void)lgPushViewControllerWithStoryboardName:(NSString *)name controllerId:(NSString *)controllerId animated:(BOOL)animated{
    UIViewController *vc = [self lgInstantiateViewControllerWithStoryboardName:name controllerId:controllerId];
    [self.navigationController pushViewController:vc animated:animated];
}

- (void)lgPushViewControllerWithClassName:(NSString *)className{
    UIViewController *vc = [NSClassFromString(className) new];
    vc.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:vc animated:YES];
}

@end
