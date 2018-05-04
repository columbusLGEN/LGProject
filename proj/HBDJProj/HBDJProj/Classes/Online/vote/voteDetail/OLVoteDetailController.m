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

static NSString * const normalCellID = @"OLVoteDetailNormalTableViewCell";
static NSString * const votedCellID = @"OLVoteDetailVotedTableViewCell";

@interface OLVoteDetailController ()<
OLVoteDetailFooterViewDelegate>
@property (weak,nonatomic) OLVoteDetailHeaderModel *headerModel;
@property (weak,nonatomic) OLVoteDetailHeaderView *header;
/** 是否选中某选项 */
@property (assign,nonatomic) BOOL selectedSomeItem;
/** 是否已经提交 */
@property (assign,nonatomic) BOOL commited;

@end

@implementation OLVoteDetailController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self.tableView registerNib:[UINib nibWithNibName:normalCellID bundle:nil] forCellReuseIdentifier:normalCellID];
    [self.tableView registerNib:[UINib nibWithNibName:votedCellID bundle:nil] forCellReuseIdentifier:votedCellID];

    NSMutableArray *arrMu = [NSMutableArray new];
    for (NSInteger i = 0; i < 4; i++) {
        OLVoteDetailModel *model = [OLVoteDetailModel new];
        model.status = VoteModelStatusNormal;
        [arrMu addObject:model];
    }
    self.dataArray = arrMu.copy;
    [self.tableView reloadData];
    
    /// testcode
    OLVoteDetailHeaderModel *headerModel = [OLVoteDetailHeaderModel new];
    _headerModel = headerModel;
    headerModel.status = VoteModelStatusNormal;
    headerModel.title = @"2017年十大党建活动评选";
    headerModel.testTime = @"2018-01-01";
    headerModel.voteDescripetion = @"单选(匿名投票)";
    
    OLVoteDetailHeaderView *header = [OLVoteDetailHeaderView headerForVoteDetail];
    _header = header;
    header.model = headerModel;
    header.frame = CGRectMake(0, 0, kScreenWidth, 101);
    self.tableView.tableHeaderView = header;
    
    OLVoteDetailFooterView *footer = [OLVoteDetailFooterView footerForVoteDetail];
    footer.delegate = self;
    footer.frame = CGRectMake(0, 0, kScreenWidth, 200);
    self.tableView.tableFooterView = footer;
}

#pragma mark - Table view data source
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.dataArray.count;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    OLVoteDetailModel *model = self.dataArray[indexPath.row];
    OLVoteDetailTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:[OLVoteDetailTableViewCell cellReuseIdWithModel:model] forIndexPath:indexPath];
    cell.model = model;
    
    return cell;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    OLVoteDetailModel *model = self.dataArray[indexPath.row];
    return [OLVoteDetailTableViewCell cellHeightWithModel:model];
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    if (!_commited) {
        [self.dataArray enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            OLVoteDetailModel *model = obj;
            if (idx == indexPath.row) {
                model.status = VoteModelStatusSelected;
                _selectedSomeItem = YES;
            }else{
                model.status = VoteModelStatusNormal;
            }
        }];
        [tableView reloadData];
    }else{
        NSLog(@"已经提交 -- ");
    }
    
}

#pragma mark - footer delegate
- (void)voteFooterCommit:(OLVoteDetailFooterView *)voteFooter{
    
    if (_selectedSomeItem) {
        _commited = YES;
        
        /// 判断是否选择了某一项，如果没有选择，直接返回
        _headerModel.status = VoteModelStatusVoted;
        _header.model = _headerModel;
        
        /// 切换 模型状态
        [self.dataArray enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            OLVoteDetailModel *model = obj;
            model.status = VoteModelStatusVoted;
        }];
        self.tableView.tableFooterView = nil;
        
        [self.tableView reloadData];
        _selectedSomeItem = NO;
    }else{
        NSLog(@"您未选中任何选项 -- ");
    }
}


/*
// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the specified item to be editable.
    return YES;
}
*/

/*
// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    } else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }   
}
*/

/*
// Override to support rearranging the table view.
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath {
}
*/

/*
// Override to support conditional rearranging of the table view.
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the item to be re-orderable.
    return YES;
}
*/

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
