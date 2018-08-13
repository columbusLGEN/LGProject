//
//  OLTkcsTableViewController.m
//  HBDJProj
//
//  Created by Peanut Lee on 2018/5/4.
//  Copyright © 2018年 Lee. All rights reserved.
//

#import "OLTkcsTableViewController.h"
#import "OLTkcsTableViewCell.h"
#import "OLTkcsModel.h"
#import "DJOnlineNetorkManager.h"
#import "OLExamViewController.h"
#import "OLTestResultViewController.h"
#import "DJTestScoreListTableViewController.h"

@interface OLTkcsTableViewController ()

@property (assign,nonatomic) NSInteger offset;

@end

@implementation OLTkcsTableViewController

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:NO animated:YES];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.tableView.rowHeight = 57;
    [self.tableView registerNib:[UINib nibWithNibName:cellID bundle:nil] forCellReuseIdentifier:cellID];
    
    _offset = 0;
    [self getNetDataWithOffset:_offset];
    
    self.tableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        _offset = 0;
        [self getNetDataWithOffset:_offset];
        [self.tableView.mj_footer resetNoMoreData];
    }];
    self.tableView.mj_footer = [MJRefreshAutoNormalFooter footerWithRefreshingBlock:^{
        [self getNetDataWithOffset:_offset];
    }];
}

- (void)getNetDataWithOffset:(NSInteger)offset{
    if (self.tkcsType == OLTkcsTypetk) {
        _portName = @"Title";
    }else{
        _portName = @"Tests";
    }
    [DJOnlineNetorkManager.sharedInstance frontSubjects_selectWithPortName:_portName offset:offset success:^(id responseObj) {
        
        NSArray *array = responseObj;
        
        BOOL arrIsNull = (array == nil || array.count == 0);
        
        if (offset == 0) {
            [self.tableView.mj_header endRefreshing];
        }else{
            if (arrIsNull) {
                [self.tableView.mj_footer endRefreshingWithNoMoreData];
            }else{
                [self.tableView.mj_footer endRefreshing];
            }
        }
        
        if (arrIsNull) {
            return;
        }else{
            NSMutableArray *arrmu;
            if (offset == 0) {
                arrmu = NSMutableArray.new;
            }else{
                arrmu = [NSMutableArray arrayWithArray:self.dataArray];
            }
            
            for (NSInteger i = 0; i < array.count; i++) {
                OLTkcsModel *model = [OLTkcsModel mj_objectWithKeyValues:array[i]];
                model.tkcsType = _tkcsType;
                [arrmu addObject:model];
            }
            self.dataArray = arrmu.copy;
            _offset = self.dataArray.count;
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
    OLTkcsModel *model = self.dataArray[indexPath.row];
    OLTkcsTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellID forIndexPath:indexPath];
    cell.model = model;
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    OLTkcsModel *model = self.dataArray[indexPath.row];
    
    if (self.tkcsType == OLTkcsTypetk) {
        [self testvcWithType:_tkcsType model:model];
    }
    
    if (self.tkcsType == OLTkcsTypecs) {
        switch (model.teststatus) {
            case 0:{/// 进行中
                [self testvcWithType:_tkcsType model:model];
            }
                break;
            case 1:{/// 已答题
                /// 进入个人成绩页面
                OLTestResultViewController *trvc = (OLTestResultViewController *)[self lgInstantiateViewControllerWithStoryboardName:OnlineStoryboardName controllerId:@"OLTestResultViewController"];
                trvc.pushWay = LGBaseViewControllerPushWayPush;
                trvc.model = model;
                
                [self.navigationController pushViewController:trvc animated:YES];
            }
                break;
            case 3:{/// 已结束
                DJTestScoreListTableViewController *vc = DJTestScoreListTableViewController.new;
                vc.model = model;
                [self.navigationController pushViewController:vc animated:YES];
                
            }
                break;
                
            default:
                break;
        }
        
    }

}

- (void)testvcWithType:(OLTkcsType)type model:(OLTkcsModel *)model{
    /// 进入答题页面
    OLExamViewController *vc = OLExamViewController.new;
    vc.tkcsType = type;
    vc.portName = _portName;
    NSLog(@"测试题模型: %@",model);
    vc.model = model;
    [self.navigationController pushViewController:vc animated:YES];
}


@end
