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

@property (strong,nonatomic) OLVoteDetailModel *currentOption;

@end

@implementation OLVoteDetailController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self.tableView registerNib:[UINib nibWithNibName:normalCellID bundle:nil] forCellReuseIdentifier:normalCellID];
    [self.tableView registerNib:[UINib nibWithNibName:votedCellID bundle:nil] forCellReuseIdentifier:votedCellID];
    [self.tableView registerClass:[OLVoteDetailBottomTimeCell class] forCellReuseIdentifier:bottomTimeCell];
    self.tableView.estimatedRowHeight = 1.0;
    
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
    
    /// TODO: 如果是已经投票的数据
//    1.commited = YES      //
//    2.显示正确的 cell 样式  //
//    3.新增footer显示时间   //
    NSLog(@"viewdidload: ");
}

- (void)setModel:(OLVoteListModel *)model{
    _model = model;
    NSLog(@"setmodel: ");
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
    headerModel.voteDescripetion = @"单选(匿名投票)";
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
        _currentOption = currentClickModel;
        if (!_commited) {
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
            
            _currentOption.votecount += 1;
            for (OLVoteDetailModel *detailModel in self.dataArray) {
                detailModel.totalVotesCount += 1;
                detailModel.localStatus = VoteModelStatusVoted;
            }
            _header.model.totalVotesCount += 1;
            
            self.tableView.tableFooterView = nil;
            
            [self.tableView reloadData];
            _selectedSomeItem = NO;
            
        } failure:^(id failureObj) {
            [self presentFailureTips:@"网络异常，请稍后重试"];
        }];
        
        
    }else{
        NSLog(@"您未选中任何选项 -- ");
    }
}

/** 是否 已经投票 或者 投票已结束 */
- (BOOL)voteStatusIsDone:(NSInteger)status{
    return (status == 1 || status == 3);
}

@end
