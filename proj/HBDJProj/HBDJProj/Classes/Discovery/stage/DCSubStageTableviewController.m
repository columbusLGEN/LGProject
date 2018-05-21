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

@interface DCSubStageTableviewController ()

@end

@implementation DCSubStageTableviewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self.tableView registerClass:[NSClassFromString(threeImgCell) class] forCellReuseIdentifier:threeImgCell];
    [self.tableView registerClass:[NSClassFromString(oneImgCell) class] forCellReuseIdentifier:oneImgCell];
    [self.tableView registerClass:[NSClassFromString(audioCell) class] forCellReuseIdentifier:audioCell];
    
    NSMutableArray *arrMu = [NSMutableArray arrayWithCapacity:10];
    for (NSInteger i = 0; i < 20; i++) {
        DCSubStageModel *model = [DCSubStageModel new];
        model.nick = [NSString stringWithFormat:@"王建国_%ld",i];
        model.modelType = StageModelTypeMoreImg;
        if (i < 3) {
            model.modelType = StageModelTypeAImg;
            if (!i) {
                model.aTestImg = [UIImage imageNamed:@"ver_test_img"];
            }else{
                model.aTestImg = [UIImage imageNamed:@"party_history"];
            }
            if (i == 2) {
                model.isVideo = YES;
                model.modelType = StageModelTypeVideo;
            }
        }
        if (i == 3) {
            model.modelType = StageModelTypeAudio;
            model.content = @"";
        }
        
        /// 评论
        NSMutableArray *arrM = [NSMutableArray array];
        for (NSInteger j = 0; j < arc4random_uniform(5); j++) {
            DCSubStageCommentsModel *commentsModel = [DCSubStageCommentsModel new];
            commentsModel.sender = @"李楠";
            commentsModel.content = @"我也听了这个宣讲";
            [arrM addObject:commentsModel];
        }
        model.comments = arrM.copy;
        
        [arrMu addObject:model];
    }
    self.dataArray = arrMu.copy;
    [self.tableView reloadData];
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
