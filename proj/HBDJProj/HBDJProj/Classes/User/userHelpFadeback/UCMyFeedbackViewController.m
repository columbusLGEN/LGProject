//
//  UCMyFeedbackViewController.m
//  HBDJProj
//
//  Created by Peanut Lee on 2018/4/20.
//  Copyright © 2018年 Lee. All rights reserved.
//

#import "UCMyFeedbackViewController.h"
#import "UCHelpFadebackTableViewCell.h"
#import "UCHelpFadebackModel.h"
#import "DJUserNetworkManager.h"

static NSString * const cellID = @"UCHelpFadebackTableViewCell";

@interface UCMyFeedbackViewController ()

@property (weak,nonatomic) IBOutlet UITableView *tableView;
@property (strong,nonatomic) NSArray *array;

@end

@implementation UCMyFeedbackViewController{
    NSInteger offset;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    _tableView.estimatedRowHeight = 1.0f;
    [_tableView registerClass:[UCHelpFadebackTableViewCell class] forCellReuseIdentifier:cellID];
  
    self.tableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        offset = 0;
        [self.tableView.mj_footer resetNoMoreData];
        [self getData];
    }];
    
    self.tableView.mj_footer = [MJRefreshAutoNormalFooter footerWithRefreshingBlock:^{
        [self getData];
    }];
    
    [self.tableView.mj_header beginRefreshing];
}

- (void)getData{
    [DJUserNetworkManager.sharedInstance frontFeedback_selectWithOffset:offset success:^(id responseObj) {
        
        if (offset == 0) {
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
            if (offset == 0) {
                arrmu = NSMutableArray.new;
            }else{
                arrmu = [NSMutableArray arrayWithArray:self.array];
            }
            
            for (NSInteger i = 0; i < array_callback.count; i++) {
                UCHelpFadebackModel *model = [UCHelpFadebackModel mj_objectWithKeyValues:array_callback[i]];
                model.showTimeLabel = YES;
                [arrmu addObject:model];
            }
            
            self.array = arrmu.copy;
            offset = self.array.count;
            [[NSOperationQueue mainQueue] addOperationWithBlock:^{
                [self.tableView reloadData];
            }];
        }
        
    } failure:^(id failureObj) {
        [self.tableView.mj_header endRefreshing];
        [self.tableView.mj_footer endRefreshing];
        
    }];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return _array.count;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    UCHelpFadebackModel *model = _array[indexPath.row];
    UCHelpFadebackTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellID];
    cell.model = model;
    return cell;
}




@end
