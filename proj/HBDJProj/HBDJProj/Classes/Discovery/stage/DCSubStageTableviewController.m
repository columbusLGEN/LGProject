//
//  DCSubStageTableviewController.m
//  HBDJProj
//
//  Created by Peanut Lee on 2018/4/28.
//  Copyright © 2018年 Lee. All rights reserved.
//

#import "DCSubStageTableviewController.h"
#import "DCSubStageBaseTableViewCell.h"
#import "DCSubStageModel.h"
#import "DCSubStageCommentsModel.h"
#import "DJDiscoveryNetworkManager.h"

@interface DCSubStageTableviewController ()
@property (assign,nonatomic) NSInteger offset;

@end

@implementation DCSubStageTableviewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self.tableView registerClass:[NSClassFromString(threeImgCell) class] forCellReuseIdentifier:threeImgCell];
    [self.tableView registerClass:[NSClassFromString(oneImgCell) class] forCellReuseIdentifier:oneImgCell];
    [self.tableView registerClass:[NSClassFromString(audioCell) class] forCellReuseIdentifier:audioCell];
    
//    NSMutableArray *arrMu = [NSMutableArray arrayWithCapacity:10];
//    for (NSInteger i = 0; i < 20; i++) {
//        DCSubStageModel *model = [DCSubStageModel new];
//        model.nick = [NSString stringWithFormat:@"王建国_%ld",i];
//        model.modelType = StageModelTypeMoreImg;
//        if (i < 3) {
//            model.modelType = StageModelTypeAImg;
//            if (!i) {
//                model.aTestImg = [UIImage imageNamed:@"ver_test_img"];
//            }else{
//                model.aTestImg = [UIImage imageNamed:@"party_history"];
//            }
//            if (i == 2) {
//                model.isVideo = YES;
//                model.modelType = StageModelTypeVideo;
//            }
//        }
//        if (i == 3) {
//            model.modelType = StageModelTypeAudio;
//            model.content = @"";
//        }
//        
//        /// 评论
//        NSMutableArray *arrM = [NSMutableArray array];
//        for (NSInteger j = 0; j < arc4random_uniform(5); j++) {
//            DCSubStageCommentsModel *commentsModel = [DCSubStageCommentsModel new];
//            commentsModel.sender = @"李楠";
//            commentsModel.content = @"我也听了这个宣讲";
//            [arrM addObject:commentsModel];
//        }
//        model.comments = arrM.copy;
//        
//        [arrMu addObject:model];
//    }
//    self.dataArray = arrMu.copy;
//    [self.tableView reloadData];
    
    self.tableView.mj_footer = [MJRefreshAutoNormalFooter footerWithRefreshingBlock:^{
        [self getData];
    }];
    
}
- (void)setDataArray:(NSArray *)dataArray{
    [super setDataArray:dataArray];
    _offset = dataArray.count;
    [self.tableView reloadData];
}

- (void)getData{
    [DJDiscoveryNetworkManager.sharedInstance frontUgc_selectmechanismWithOffset:_offset success:^(id responseObj) {
        NSArray *array = responseObj;
        if (array == nil || array.count == 0) {
            [self.tableView.mj_footer endRefreshingWithNoMoreData];
            return;
        }else{
            [self.tableView.mj_footer endRefreshing];
            
            NSMutableArray *arrmu = [NSMutableArray arrayWithArray:self.dataArray];
            for (NSInteger i = 0; i < array.count; i++) {
                DCSubStageModel *model = [DCSubStageModel mj_objectWithKeyValues:array[i]];
                [arrmu addObject:model];
            }
            self.dataArray = arrmu.copy;
            _offset = self.dataArray.count;
            [[NSOperationQueue mainQueue] addOperationWithBlock:^{
                [self.tableView reloadData];
            }];
        }
        
    } failure:^(id failureObj) {
        [self.tableView.mj_footer endRefreshing];
    }];
}

#pragma mark - Table view data source
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.dataArray.count;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    DCSubStageModel *model = self.dataArray[indexPath.row];
    DCSubStageBaseTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:[DCSubStageBaseTableViewCell cellReuseIdWithModel:model]];
    cell.model = model;
    return cell;
}
- (void)tableView:(UITableView *)tableView willDisplayCell:(DCSubStageBaseTableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath{
    DCSubStageModel *model = self.dataArray[indexPath.row];
    cell.model = model;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    DCSubStageModel *model = self.dataArray[indexPath.row];
    return model.cellHeight;
}


@end
