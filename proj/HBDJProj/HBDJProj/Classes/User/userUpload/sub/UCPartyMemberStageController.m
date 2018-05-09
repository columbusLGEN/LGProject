//
//  UCPartyMemberStageController.m
//  HBDJProj
//
//  Created by Peanut Lee on 2018/4/23.
//  Copyright © 2018年 Lee. All rights reserved.
//

#import "UCPartyMemberStageController.h"
#import "model/UCPartyMemberStageModel.h"
#import "view/cell/UCPartyMemberStageCell.h"

@interface UCPartyMemberStageController ()
@property (strong,nonatomic) NSArray *array;
@property (assign,nonatomic) PartyMemberModelState state;

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
        model.state = PartyMemberModelStateDefault;
        [arrMu addObject:model];
    }
    _array = arrMu.copy;
    [self.tableView reloadData];
}

#pragma mark - Table view data source
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return _array.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UCPartyMemberStageModel *model = _array[indexPath.row];
    UCPartyMemberStageCell *cell = [tableView dequeueReusableCellWithIdentifier:[UCPartyMemberStageCell cellReuseIdWithModel:model]];
    
    cell.model = model;
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 220;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    UCPartyMemberStageModel *model = _array[indexPath.row];
    if (model.state == PartyMemberModelStateEditNormal) {
        model.state = PartyMemberModelStateEditSelected;
    }else{
        model.state = PartyMemberModelStateEditNormal;
    }
    [tableView reloadData];
}

/// MARK: 进入、退出编辑状态
- (void)startEdit{
    [self changeModelState:PartyMemberModelStateEditNormal];
}
- (void)endEdit{
    [self changeModelState:PartyMemberModelStateDefault];
}
- (void)changeModelState:(PartyMemberModelState)state{
    _state = state;
    [_array enumerateObjectsUsingBlock:^(UCPartyMemberStageModel *  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        obj.state = state;
    }];
    [self.tableView reloadData];
}

- (void)allSelect{
    /// 经过分析后 结论为
    /// 如果全部模型为选中状态，则 将所有模型修改为 未选中的状态
    /// 否则，将所有模型修改为选中状态
    
    /// 数组中是否有 只要有一个不是选中状态，该值就为YES
    __block BOOL modelNotSelect = NO;
    [_array enumerateObjectsUsingBlock:^(UCPartyMemberStageModel *  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        if (obj.state != PartyMemberModelStateEditSelected) {
            modelNotSelect = YES;
        }
    }];
    
    if (modelNotSelect) {
        /// 表示，数组中有 未被选中的 模型
        [_array enumerateObjectsUsingBlock:^(UCPartyMemberStageModel *  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            obj.state = PartyMemberModelStateEditSelected;
        }];
    }else{
        /// 表示，数组中所有模型均已经被选中
        [_array enumerateObjectsUsingBlock:^(UCPartyMemberStageModel *  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            obj.state = PartyMemberModelStateEditNormal;
        }];
    }
    [self.tableView reloadData];
}

@end
