//
//  OLVoteDetailController.m
//  HBDJProj
//
//  Created by Peanut Lee on 2018/5/4.
//  Copyright © 2018年 Lee. All rights reserved.
//

#import "OLVoteDetailController.h"
#import "OLVoteDetailTableViewCell.h"
#import "OLVoteDetailModel.h"
#import "OLVoteDetailHeaderView.h"
#import "OLVoteDetailHeaderModel.h"
#import "OLVoteDetailFooterView.h"
#import "DJOnlineNetorkManager.h"
#import "OLVoteListModel.h"
#import "DJOnlineNetorkManager.h"
#import "OLVoteDetailBottomTimeCell.h"
#import "UCMsgModel.h"

static NSString * const normalCellID = @"OLVoteDetailNormalTableViewCell";
static NSString * const votedCellID = @"OLVoteDetailVotedTableViewCell";

@interface OLVoteDetailController ()<
OLVoteDetailFooterViewDelegate,
OLVoteDetailHeaderViewDelegate>

@property (strong,nonatomic) OLVoteDetailHeaderModel *headerModel;
@property (weak,nonatomic) OLVoteDetailHeaderView *header;
/** 是否选中某选项 */
@property (assign,nonatomic) BOOL selectedSomeItem;
/** 是否已经提交 */
@property (assign,nonatomic) BOOL commited;

@property (strong,nonatomic) NSMutableArray *optionIds;

/** 单选下 当前用户选择的选项 */
@property (strong,nonatomic) OLVoteDetailModel *currentOption;

/** 多选下 用户选择的选项 */
@property (strong,nonatomic) NSArray *userSelectOptions;
// TODO: Zup_当前多选的数量
@property (assign,nonatomic) NSInteger selectedNumber;

@end

@implementation OLVoteDetailController

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:NO animated:YES];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self.tableView registerNib:[UINib nibWithNibName:normalCellID bundle:nil] forCellReuseIdentifier:normalCellID];
    [self.tableView registerNib:[UINib nibWithNibName:votedCellID bundle:nil] forCellReuseIdentifier:votedCellID];
    [self.tableView registerClass:[OLVoteDetailBottomTimeCell class] forCellReuseIdentifier:bottomTimeCell];
    self.tableView.estimatedRowHeight = 100.0;
    
    OLVoteDetailHeaderView *header = [OLVoteDetailHeaderView headerForVoteDetail];
    _header = header;
    header.delegate = self;
    header.frame = CGRectMake(0, 0, kScreenWidth, 101);
    header.model = _headerModel;
    self.tableView.tableHeaderView = header;
    
    if (_model.votestatus == 0) {
        OLVoteDetailFooterView *footer = [OLVoteDetailFooterView footerForVoteDetail];
        footer.delegate = self;
        footer.frame = CGRectMake(0, 0, kScreenWidth, 200);
        self.tableView.tableFooterView = footer;
    }
    
    _optionIds = NSMutableArray.new;
    

}

- (void)setModel:(OLVoteListModel *)model{
    _model = model;

    /**
        header 需要
        title
        time
        单选 or 多选
        匿名 or 实名
     */
    OLVoteDetailHeaderModel *headerModel = [OLVoteDetailHeaderModel new];
    headerModel.title = model.title;
    headerModel.time = model.starttime;
    
    if (self.model.ismultiselect) {
        headerModel.voteDescripetion = @"多选(匿名投票)";
    }else{
        headerModel.voteDescripetion = @"单选(匿名投票)";
    }
    
    _headerModel = headerModel;
    if ([self voteStatusIsDone:model.votestatus]) {
        headerModel.localStatus = VoteModelStatusVoted;
    }
    
    [DJOnlineNetorkManager.sharedInstance frontVotes_selectDetailWithVoteid:model.seqid success:^(id responseObj) {
        NSArray *array = responseObj;
        if (array == nil || array.count == 0) {
            return;
        }else{
            NSMutableArray *arrMu = [NSMutableArray new];
            NSInteger voteAllCount = 0;
            for (NSInteger i = 0; i < array.count; i++) {
                OLVoteDetailModel *modelDetail = [OLVoteDetailModel mj_objectWithKeyValues:array[i]];
                modelDetail.localStatus = VoteModelStatusNormal;
                if ([self voteStatusIsDone:model.votestatus] ) {
                    modelDetail.localStatus = VoteModelStatusVoted;
                }
                voteAllCount += modelDetail.votecount;
                [arrMu addObject:modelDetail];
            }
            headerModel.totalVotesCount = voteAllCount;
            /// 赋值投票总数
            for (OLVoteDetailModel *modelDetail in arrMu) {
                modelDetail.totalVotesCount = voteAllCount;
            }
            self.dataArray = arrMu.copy;
            
            [[NSOperationQueue mainQueue] addOperationWithBlock:^{
                [self.tableView reloadData];
            }];
        }
        
        
    } failure:^(id failureObj) {
        
    }];
}


#pragma mark - Table view data source
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.dataArray.count + 1;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.row == self.dataArray.count) {
        OLVoteDetailBottomTimeCell *cell = [tableView dequeueReusableCellWithIdentifier:bottomTimeCell];
        cell.endTime = self.model.endtime;
        return cell;
    }else{
        OLVoteDetailModel *model = self.dataArray[indexPath.row];
        OLVoteDetailTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:[OLVoteDetailTableViewCell cellReuseIdWithModel:model] forIndexPath:indexPath];
        cell.model = model;
        return cell;
    }
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.row == self.dataArray.count) {
        
    }else{
        OLVoteDetailModel *currentClickModel = self.dataArray[indexPath.row];
        if (!_commited) {
            
            if (self.model.ismultiselect) {
                /// 多选分支
                _currentOption = nil;
                /// 如果该选项已经被选中
                if (currentClickModel.localStatus == VoteModelStatusSelected) {
                    
                    currentClickModel.localStatus = VoteModelStatusNormal;
                    
                }else if (currentClickModel.localStatus == VoteModelStatusNormal) {
                    // TODO: Zup_添加选项上限
                    if (_model.maxnum > 0 && _selectedNumber >= _model.maxnum) {
                        [self presentFailureTips:[NSString stringWithFormat:@"最多只能选择%ld个选项", _model.maxnum]];
                        return;
                    }
                    /// 如果该选项还未被选中
                    currentClickModel.localStatus = VoteModelStatusSelected;
                    
                }else{
                    
                }
                
                /// 循环所有选项模型，如果全部未选中，_selectedSomeItem 置为NO
                [_optionIds removeAllObjects];
                _userSelectOptions = nil;
                _selectedSomeItem = NO;
                NSMutableArray *arrmu_selectOptions = NSMutableArray.new;
                
                for (OLVoteDetailModel *model in self.dataArray) {
                    if (model.localStatus == VoteModelStatusSelected) {
                        _selectedSomeItem = YES;
                        [_optionIds addObject:[NSString stringWithFormat:@"%ld",(long)model.seqid]];
                        [arrmu_selectOptions addObject:model];
                    }
                }
                _selectedNumber = arrmu_selectOptions.count;
                _userSelectOptions = arrmu_selectOptions.copy;
                
            }else{
                /// 单选分支
                _currentOption = currentClickModel;
                _userSelectOptions = nil;
                for (OLVoteDetailModel *model in self.dataArray) {
                    if (model == currentClickModel) {
                        model.localStatus = VoteModelStatusSelected;
                        _selectedSomeItem = YES;
                        [_optionIds addObject:[NSString stringWithFormat:@"%ld",(long)model.seqid]];
                    }else{
                        model.localStatus = VoteModelStatusNormal;
                        [_optionIds removeObject:[NSString stringWithFormat:@"%ld",(long)model.seqid]];
                    }
                }
            }
            
        }else{
            
        }
    }
    
}

#pragma mark - header delegate
- (void)voteDetailHeaderReCallHeight:(OLVoteDetailHeaderView *)header{
    header.frame = CGRectMake(0, 0, kScreenWidth, [header headerHeight]);
    [self.tableView reloadData];
}

#pragma mark - footer delegate
/// MARK: 提交投票
- (void)voteFooterCommit:(OLVoteDetailFooterView *)voteFooter{
    
    if (_selectedSomeItem) {
        _commited = YES;
        
        /// 判断是否选择了某一项，如果没有选择，直接返回
        _headerModel.localStatus = VoteModelStatusVoted;
        _header.model = _headerModel;
        
        [DJOnlineNetorkManager.sharedInstance frontVotes_addWithVoteid:_model.seqid votedetailid:_optionIds.copy success:^(id responseObj) {
        
            /// 修改数据
            _model.votestatus = 1;
            if (self.model.msgModel) {
                self.model.msgModel.votestestsstatus = 1;
            }
            
            if (self.model.ismultiselect) {
                /// 多选
                /// 选项的投票数 +1 （多选）
                for (OLVoteDetailModel *detailModel in self.userSelectOptions) {
                    detailModel.votecount += 1;
                }
                
                if (_userSelectOptions.count != 0) {
                    _header.model.totalVotesCount += _userSelectOptions.count;
                }
                
            }else{
                /// 单选
                /// 选项的投票数 +1
                _currentOption.votecount += 1;
                
                _header.model.totalVotesCount += 1;
                
            }

            /// 修改所有选项的状态
            for (OLVoteDetailModel *detailModel in self.dataArray) {
                detailModel.totalVotesCount += 1;
                detailModel.localStatus = VoteModelStatusVoted;
            }
            
            self.tableView.tableFooterView = nil;

            [self.tableView reloadData];
            _selectedSomeItem = NO;

        } failure:^(id failureObj) {
            [self presentFailureTips:@"网络异常，请稍后重试"];
        }];
        
        
    }else{
        [self presentFailureTips:@"请至少选则一个选项"];
    }
}

/** 是否 已经投票 或者 投票已结束 */
- (BOOL)voteStatusIsDone:(NSInteger)status{
    return (status == 1 || status == 3);
}

@end
