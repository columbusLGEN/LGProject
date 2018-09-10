//
//  UCMyQuestionViewController.m
//  HBDJProj
//
//  Created by Peanut Lee on 2018/4/23.
//  Copyright © 2018年 Lee. All rights reserved.
//

#import "UCMyQuestionViewController.h"
#import "UCQuestionModel.h"
#import "UCQuestionTableViewCell.h"
#import "DJUserNetworkManager.h"
#import "LGSocialShareManager.h"
#import "LGAlertControllerManager.h"
#import "DJUserInteractionMgr.h"

static NSString * const cellID = @"UCQuestionTableViewCell";

@interface UCMyQuestionViewController ()<
UITableViewDelegate,
UITableViewDataSource,
UCQuestionTableViewCellDelegate>
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (strong,nonatomic) NSArray *array;
@end

@implementation UCMyQuestionViewController{
    NSInteger offset;
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:NO animated:YES];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self configUI];
    
}

- (void)configUI{
    
    self.title = @"我的提问";
    
    _tableView.estimatedRowHeight = 1.0f;
    [_tableView registerNib:[UINib nibWithNibName:cellID bundle:nil] forCellReuseIdentifier:cellID];
    
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
    [DJUserNetworkManager.sharedInstance frontQuestionanswer_selectWithOffset:offset success:^(id responseObj) {
        
        if (offset == 0) {
            // 2.tableview
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
                UCQuestionModel *model = [UCQuestionModel mj_objectWithKeyValues:array_callback[i]];
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
    UCQuestionModel *model = _array[indexPath.row];
    UCQuestionTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellID];
    cell.indexPath = indexPath;
    cell.delegate = self;
    cell.collectModel = model;
    return cell;
}

#pragma mark - UCQuestionTableViewCellDelegate
- (void)qaCellshowAllClickWith:(NSIndexPath *)indexPath{
    [self.tableView reloadRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationNone];
}

// 点赞
- (void)qaCellLikeWithModel:(UCQuestionModel *)model sender:(UIButton *)sender{
    sender.userInteractionEnabled = NO;
    [DJUserInteractionMgr.sharedInstance likeCollectWithModel:model collect:NO type:DJDataPraisetypeQA success:^(NSInteger cbkid, NSInteger cbkCount) {
        sender.userInteractionEnabled = YES;
    } failure:^(id failureObj) {
        sender.userInteractionEnabled = YES;
        [self presentFailureTips:@"点赞失败，请稍后重试"];
    }];
}
// 收藏
- (void)qaCellCollectWithModel:(UCQuestionModel *)model sender:(UIButton *)sender{
    sender.userInteractionEnabled = NO;
    
    [DJUserInteractionMgr.sharedInstance likeCollectWithModel:model collect:YES type:DJDataPraisetypeQA success:^(NSInteger cbkid, NSInteger cbkCount) {
        
        sender.userInteractionEnabled = YES;
        
    } failure:^(id failureObj) {
        sender.userInteractionEnabled = YES;
        [self presentFailureTips:@"收藏失败，请稍后重试"];
    }];
    
}
// 分享
- (void)qaCellShareWithModel:(UCQuestionModel *)model sender:(UIButton *)sender{
    
    NSDictionary *param = @{LGSocialShareParamKeyWebPageUrl:model.shareUrl?model.shareUrl:@"",
                            LGSocialShareParamKeyTitle:model.question?model.question:@"",
                            LGSocialShareParamKeyDesc:model.answer?model.answer:@"",
                            LGSocialShareParamKeyThumbUrl:model.thumbnail?model.thumbnail:@"",
                            LGSocialShareParamKeyVc:self};
    
    [[LGSocialShareManager new] showShareMenuWithParam:param shareType:DJShareTypeQA];
}

@end
