//
//  HPPointNewsTableViewController.m
//  HBDJProj
//
//  Created by Peanut Lee on 2018/4/28.
//  Copyright © 2018年 Lee. All rights reserved.
//

#import "HPPointNewsTableViewController.h"
#import "HPPartyBuildDetailViewController.h"
#import "HPPointNewsHeader.h"
#import "EDJMicroBuildCell.h"
#import "EDJMicroBuildModel.h"
#import "EDJHomeImageLoopModel.h"

@interface HPPointNewsTableViewController ()

@end

@implementation HPPointNewsTableViewController

- (void)setModel:(EDJHomeImageLoopModel *)model{
    HPPointNewsHeader *header = (HPPointNewsHeader *)self.tableView.tableHeaderView;
    header.model = model;
    
    [DJHomeNetworkManager homeChairmanPoineNewsClassid:model.seqid offset:0 length:10 sort:1 success:^(id responseObj) {
        NSArray *array = responseObj;
        NSMutableArray *arrmu = [NSMutableArray array];
        [array enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            EDJMicroBuildModel *model = [EDJMicroBuildModel mj_objectWithKeyValues:obj];
            [arrmu addObject:model];
        }];
        self.dataArray = arrmu.copy;
        [[NSOperationQueue mainQueue] addOperationWithBlock:^{
            [self.tableView reloadData];
        }];
    } failure:^(id failureObj) {
        NSLog(@"homeChairmanPoineNewsClassid -- %@",failureObj);
        
    }];
    
    
}


- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:NO animated:YES];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    HPPointNewsHeader *header = [HPPointNewsHeader pointNewsHeader];
    self.tableView.tableHeaderView = header;
    self.tableView.tableHeaderView.frame = CGRectMake(0, 0, kScreenWidth, 233);
    
    [self.tableView registerNib:[UINib nibWithNibName:buildCellNoImg bundle:nil] forCellReuseIdentifier:buildCellNoImg];
    [self.tableView registerNib:[UINib nibWithNibName:buildCellOneImg bundle:nil] forCellReuseIdentifier:buildCellOneImg];
    [self.tableView registerNib:[UINib nibWithNibName:buildCellThreeImg bundle:nil] forCellReuseIdentifier:buildCellThreeImg];
    
}

#pragma mark - Table view data source
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.dataArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    EDJMicroBuildModel *model = self.dataArray[indexPath.row];
    EDJMicroBuildCell *cell = [EDJMicroBuildCell cellWithTableView:tableView model:model];
    cell.model = model;
    return cell;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    EDJMicroBuildModel *model = self.dataArray[indexPath.row];
    return [EDJMicroBuildCell cellHeightWithModel:model];
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    EDJMicroBuildModel *model = self.dataArray[indexPath.row];
    [HPPartyBuildDetailViewController buildVcPushWith:model baseVc:self];
//    HPPartyBuildDetailViewController *dvc = [HPPartyBuildDetailViewController new];
//    dvc.coreTextViewType = LGCoreTextViewTypePoint;
//    [self.navigationController pushViewController:dvc animated:YES];
}



@end
//    NSMutableArray *arrMu = [NSMutableArray new];
//    for (int i = 0; i < 20; i++) {
//        EDJMicroBuildModel *model = [EDJMicroBuildModel new];
//        model.showInteractionView = YES;
//        NSMutableArray *imgs = [NSMutableArray new];
//        int k = arc4random_uniform(3);
//        if (k == 2) {
//            k++;
//        }
//        for (int j = 0;j < k; j++) {
//            [imgs addObject:@"build"];
//        }
//        model.imgs = imgs.copy;
//        [arrMu addObject:model];
//    }
//    self.dataArray = arrMu.copy;
//    [self.tableView reloadData];
