//
//  UCPartyMemberStageController.m
//  HBDJProj
//
//  Created by Peanut Lee on 2018/4/23.
//  Copyright © 2018年 Lee. All rights reserved.
//

#import "UCPartyMemberStageController.h"
#import "model/UCPartyMemberStageModel.h"
#import "view/UCPartyMemberStageCell.h"

@interface UCPartyMemberStageController ()
@property (strong,nonatomic) NSArray *array;

@end

@implementation UCPartyMemberStageController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self configUI];
}
- (void)configUI{

    NSMutableArray *arrMu = [NSMutableArray array];
    for (int i = 0; i < 10; i++) {
        UCPartyMemberStageModel *model = [UCPartyMemberStageModel new];
        [arrMu addObject:model];
    }
    _array = arrMu.copy;
    [self.tableView reloadData];
}

#pragma mark - Table view data source

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return _array.count;/// count 有值
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UCPartyMemberStageModel *model = _array[indexPath.row];
    UCPartyMemberStageCell *cell = [tableView dequeueReusableCellWithIdentifier:[UCPartyMemberStageCell cellReuseIdWithModel:model]];
    
    cell.model = model;
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 236;
}




@end
