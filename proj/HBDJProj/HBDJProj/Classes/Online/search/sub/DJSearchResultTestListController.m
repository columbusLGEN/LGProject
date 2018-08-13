//
//  DJSearchResultTestListController.m
//  HBDJProj
//
//  Created by Peanut Lee on 2018/8/11.
//  Copyright © 2018年 Lee. All rights reserved.
//

#import "DJSearchResultTestListController.h"
#import "DJOnlineNetorkManager.h"
#import "OLTkcsModel.h"

@interface DJSearchResultTestListController ()
@property (assign,nonatomic) NSInteger offset;

@end

@implementation DJSearchResultTestListController

- (instancetype)init{
    if (self = [super init]) {
        self.tkcsType = OLTkcsTypecs;
        self.portName = @"Tests";
    }
    return self;
}

- (void)viewDidLoad{
    [super viewDidLoad];
    self.tableView.mj_header = nil;
    self.tableView.mj_footer = nil;
}

- (void)setDataArray:(NSArray *)dataArray{
    [super setDataArray:dataArray];
    _offset = dataArray.count;
    [[NSOperationQueue mainQueue] addOperationWithBlock:^{
        [self.tableView reloadData];
    }];
}

//- (void)getNetDataWithOffset:(NSInteger)offset{
//    [DJOnlineNetorkManager.sharedInstance frontIndex_onlineSearchWithContent:_searchContent type:3 offset:_offset success:^(id responseObj) {
//        NSArray *array = responseObj;
//        if (array == nil || array.count == 0) {
//            [self.tableView.mj_footer endRefreshingWithNoMoreData];
//            return;
//        }else{
//            [self.tableView.mj_footer endRefreshing];
//
//            NSMutableArray *arrmu = [NSMutableArray arrayWithArray:self.dataArray];
//            for (NSInteger i = 0; i < array.count; i++) {
//                OLTkcsModel *model = [OLTkcsModel mj_objectWithKeyValues:array[i]];
//                model.tkcsType = OLTkcsTypecs;
//                [arrmu addObject:model];
//            }
//            self.dataArray = arrmu.copy;
//            _offset = self.dataArray.count;
//            [[NSOperationQueue mainQueue] addOperationWithBlock:^{
//                [self.tableView reloadData];
//            }];
//        }
//
//    } failure:^(id failureObj) {
//        [self.tableView.mj_footer endRefreshing];
//
//    }];
//}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:YES animated:YES];
}

@end
