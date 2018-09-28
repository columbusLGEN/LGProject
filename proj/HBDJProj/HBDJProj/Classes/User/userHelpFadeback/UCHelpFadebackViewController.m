//
//  UCHelpFadebackViewController.m
//  HBDJProj
//
//  Created by Peanut Lee on 2018/4/20.
//  Copyright © 2018年 Lee. All rights reserved.
//

#import "UCHelpFadebackViewController.h"
#import "UCHelpFadebackTableViewCell.h"
#import "UCHelpFadebackModel.h"
#import "DJUserNetworkManager.h"

static NSString * const cellID = @"UCHelpFadebackTableViewCell";

@interface UCHelpFadebackViewController ()<
UITableViewDelegate,
UITableViewDataSource
>
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (weak, nonatomic) IBOutlet UIButton *myFadeback;
@property (weak, nonatomic) IBOutlet UIButton *writeFadeback;
@property (strong,nonatomic) NSArray *array;

@end

@implementation UCHelpFadebackViewController{
    NSInteger offset;
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:NO animated:YES];
    
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self uiConfig];
}

- (IBAction)writeFadeback:(id)sender {
    
}
- (IBAction)myFadeback:(id)sender {
    
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

#pragma mark - Navigation
// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}

- (void)uiConfig{
    
    [_myFadeback setBackgroundColor:[UIColor EDJMainColor]];
    [_writeFadeback setTitleColor:[UIColor EDJMainColor] forState:UIControlStateNormal];
    [_writeFadeback cutBorderWithBorderWidth:1 borderColor:[UIColor EDJGrayscale_F3] cornerRadius:0];
    
    UIEdgeInsets btnImgInsets = UIEdgeInsetsMake(0, -10, 0, 0);
    [_writeFadeback setImageEdgeInsets:btnImgInsets];
    [_myFadeback setImageEdgeInsets:btnImgInsets];
    
    _tableView.estimatedRowHeight = 100.0f;
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
    [DJUserNetworkManager.sharedInstance frontFeedback_selectIndexWithOffset:offset success:^(id responseObj) {
        
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
//                model.showTimeLabel = 
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

@end
