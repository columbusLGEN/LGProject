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

@interface HPPointNewsTableViewController ()

@end

@implementation HPPointNewsTableViewController

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:NO animated:YES];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    HPPointNewsHeader *header = [HPPointNewsHeader pointNewsHeader];
    /// TODO: 设置header 数据
    self.tableView.tableHeaderView = header;
    self.tableView.tableHeaderView.frame = CGRectMake(0, 0, kScreenWidth, 272);
    
    [self.tableView registerNib:[UINib nibWithNibName:buildCellNoImg bundle:nil] forCellReuseIdentifier:buildCellNoImg];
    [self.tableView registerNib:[UINib nibWithNibName:buildCellOneImg bundle:nil] forCellReuseIdentifier:buildCellOneImg];
    [self.tableView registerNib:[UINib nibWithNibName:buildCellThreeImg bundle:nil] forCellReuseIdentifier:buildCellThreeImg];
    
    NSMutableArray *arrMu = [NSMutableArray new];
    for (int i = 0; i < 20; i++) {
        EDJMicroBuildModel *model = [EDJMicroBuildModel new];
        model.showInteractionView = YES;
        NSMutableArray *imgs = [NSMutableArray new];
        int k = arc4random_uniform(3);
        if (k == 2) {
            k++;
        }
        for (int j = 0;j < k; j++) {
            [imgs addObject:@"build"];
        }
        model.imgs = imgs.copy;
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
    HPPartyBuildDetailViewController *dvc = [HPPartyBuildDetailViewController new];
    [self.navigationController pushViewController:dvc animated:YES];
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
