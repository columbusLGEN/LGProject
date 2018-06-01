//
//  HPMicroLessonTableViewController.m
//  HBDJProj
//
//  Created by Peanut Lee on 2018/6/1.
//  Copyright © 2018年 Lee. All rights reserved.
//

#import "HPMicroLessonTableViewController.h"
#import "EDJMicroPartyLessonSubCell.h"
#import "EDJMicroPartyLessionSubModel.h"

@interface HPMicroLessonTableViewController ()

@end

@implementation HPMicroLessonTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.tableView.rowHeight = 120;
    [self.tableView registerNib:[UINib nibWithNibName:microPartyLessonSubCell bundle:nil] forCellReuseIdentifier:microPartyLessonSubCell];
    NSMutableArray *arr = [NSMutableArray array];
    for (int i = 0; i < 20; i++) {
        EDJMicroPartyLessionSubModel *model = [EDJMicroPartyLessionSubModel new];
        [arr addObject:model];
    }
    self.dataArray = arr.copy;
    [self.tableView reloadData];
}

#pragma mark - Table view data source
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.dataArray.count;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    EDJMicroPartyLessionSubModel *model = self.dataArray[indexPath.row];
    EDJMicroPartyLessonSubCell *cell = [tableView dequeueReusableCellWithIdentifier:microPartyLessonSubCell forIndexPath:indexPath];
    cell.model = model;
    return cell;
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
