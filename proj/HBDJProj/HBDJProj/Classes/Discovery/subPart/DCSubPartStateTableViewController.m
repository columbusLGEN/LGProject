//
//  DCSubPartStateTableViewController.m
//  HBDJProj
//
//  Created by Peanut Lee on 2018/4/27.
//  Copyright © 2018年 Lee. All rights reserved.
//

#import "DCSubPartStateTableViewController.h"
#import "DCSubPartStateModel.h"
#import "DCSubPartStateBaseCell.h"
#import "DCSubPartStateWithoutImgCell.h"

@interface DCSubPartStateTableViewController ()


@end

@implementation DCSubPartStateTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self.tableView registerNib:[UINib nibWithNibName:withoutImgCell bundle:nil]
         forCellReuseIdentifier:withoutImgCell];
    [self.tableView registerNib:[UINib nibWithNibName:oneImgCell bundle:nil]
         forCellReuseIdentifier:oneImgCell];
    [self.tableView registerNib:[UINib nibWithNibName:threeImgCell bundle:nil]
         forCellReuseIdentifier:threeImgCell];
    
    NSMutableArray *arrMu = [NSMutableArray arrayWithCapacity:10];
    for (NSInteger i = 0; i < 20; i++) {
        DCSubPartStateModel *model = [DCSubPartStateModel new];
        NSInteger num = arc4random_uniform(3) + 1;/// 1 2 3
        if (num == 2) {
            num -= 2;/// 2 --> 0
        }
        model.imgCount = num;
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
    DCSubPartStateModel *model = self.dataArray[indexPath.row];
    DCSubPartStateBaseCell *cell = [tableView dequeueReusableCellWithIdentifier:[DCSubPartStateBaseCell cellReuseIdWithModel:model]];
    return cell;
}

- (void)tableView:(UITableView *)tableView willDisplayCell:(DCSubPartStateBaseCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath{
    DCSubPartStateModel *model = self.dataArray[indexPath.row];
    cell.model = model;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    DCSubPartStateModel *model = self.dataArray[indexPath.row];
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
