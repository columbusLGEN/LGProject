//
//  EDJMicroPartyLessionViewController.m
//  HBDJProj
//
//  Created by Peanut Lee on 2018/4/3.
//  Copyright © 2018年 Lee. All rights reserved.
//

#import "EDJMicroPartyLessionViewController.h"
#import "EDJHomeHeaderView.h"
#import <MJRefresh.h>
#import "EDJMicroPartyLessonCell.h"
#import "EDJMicroBuildModel.h"
#import "EDJMicroBuildCell.h"

static NSString * const microCell = @"EDJMicroPartyLessonCell";
static NSString * const microHeaderCell = @"EDJMicroPartyLessonHeaderCell";
static NSString * const buildCellNoImg = @"EDJMicroBuildNoImgCell";
static NSString * const buildCellOneImg = @"EDJMicroBuildOneImgCell";
static NSString * const buildCellThreeImg = @"EDJMicroBuildThreeImgCell";

@interface EDJMicroPartyLessionViewController ()<
UITableViewDataSource,
UITableViewDelegate
>

@property (strong,nonatomic) NSArray *array;

@end

@implementation EDJMicroPartyLessionViewController

- (void)setDataType:(EDJHomeDataType)dataType{
    _dataType = dataType;
    if (dataType == EDJHomeDataTypeMicro) {
        _array = _microModels.copy;
    }else if (dataType == EDJHomeDataTypeBuild){
        _array = _buildModels.copy;
    }
    
    [self.tableView reloadData];
}

- (instancetype)init{
    if (self = [super init]) {
        _microModels  = [NSMutableArray array];
        for (int i = 0; i < 4; i++) {
            EDJMicroBuildModel *model = [EDJMicroBuildModel new];
            if (i == 0) {
                model.imgs = @[@"",@""];
            }
            [_microModels addObject:model];
        }
        _array = _microModels.copy;
        [self.tableView reloadData];
        
        _buildModels = [NSMutableArray new];
        for (int i = 0; i < 20; i++) {
            EDJMicroBuildModel *model = [EDJMicroBuildModel new];
            NSMutableArray *imgs = [NSMutableArray new];
            int k = arc4random_uniform(3);
            if (k == 2) {
                k++;
            }
            for (int j = 0;j < k; j++) {
                [imgs addObject:@"build"];
            }
            model.imgs = imgs.copy;
            [_buildModels addObject:model];
        }
        
        /// testcode
//        self.tableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
//            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
//                [self.tableView.mj_header endRefreshing];
//            });
//        }];
//
//        self.tableView.mj_footer = [MJRefreshAutoNormalFooter footerWithRefreshingBlock:^{
////            for (int i = 0; i < 5; i++) {
////                [_microOrBuildModels addObject:@"a"];
////            }
////            [_tableView reloadData];
//            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
//                [self.tableView.mj_footer endRefreshing];
//            });
//
//        }];
        
    }
    return self;
}


#pragma mark - data source
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return _array.count;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    EDJMicroBuildModel *model = _array[indexPath.row];
    if (_dataType == EDJHomeDataTypeBuild) {
        EDJMicroBuildCell *cell = [EDJMicroBuildCell cellWithTableView:tableView model:model];
        return cell;
    }else if (_dataType == EDJHomeDataTypeMicro){
        EDJMicroPartyLessonCell *cell = [EDJMicroPartyLessonCell cellWithTableView:tableView model:model];
        cell.model = model;
        return cell;
    }
    return nil;
}

- (UITableView *)tableView{
    if (_tableView == nil) {
        _tableView = [[UITableView alloc] initWithFrame:kScreenBounds style:UITableViewStylePlain];
        if (@available(iOS 11.0, *)) {
            _tableView.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
        } else {
            // Fallback on earlier versions
        }
        _tableView.dataSource = self;
        UIEdgeInsets insets = UIEdgeInsetsMake([EDJHomeHeaderView headerHeight], 0, kTabBarHeight, 0);
        [_tableView setContentInset:insets];
        _tableView.scrollIndicatorInsets = insets;
        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        [_tableView registerClass:[EDJMicroPartyLessonCell class] forCellReuseIdentifier:microCell];
        [_tableView registerNib:[UINib nibWithNibName:microHeaderCell bundle:nil] forCellReuseIdentifier:microHeaderCell];
        
        /// EDJMicroBuildCell
        [_tableView registerNib:[UINib nibWithNibName:buildCellNoImg bundle:nil] forCellReuseIdentifier:buildCellNoImg];
        [_tableView registerNib:[UINib nibWithNibName:buildCellOneImg bundle:nil] forCellReuseIdentifier:buildCellOneImg];
        [_tableView registerNib:[UINib nibWithNibName:buildCellThreeImg bundle:nil] forCellReuseIdentifier:buildCellThreeImg];
    }
    return _tableView;
}

@end
