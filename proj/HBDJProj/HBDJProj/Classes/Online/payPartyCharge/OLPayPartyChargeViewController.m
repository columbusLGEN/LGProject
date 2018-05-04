//
//  OLPayPartyChargeViewController.m
//  HBDJProj
//
//  Created by Peanut Lee on 2018/5/3.
//  Copyright © 2018年 Lee. All rights reserved.
//

#import "OLPayPartyChargeViewController.h"
#import "OLPayPartyChargeTableViewCell.h"
#import "OLPayPartyChargeModel.h"

@interface OLPayPartyChargeViewController ()

@end

@implementation OLPayPartyChargeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self.tableView registerNib:[UINib nibWithNibName:cellID bundle:nil] forCellReuseIdentifier:cellID];
    
    NSMutableArray *arrMu = [NSMutableArray new];
    for (NSInteger i = 0; i < 20; i++) {
        OLPayPartyChargeModel *model = [OLPayPartyChargeModel new];
        model.testTime = [NSString stringWithFormat:@"2017年%ld月",i + arc4random_uniform(3)];
        model.isPay = (arc4random_uniform(2) == 1);
        [arrMu addObject:model];
    }
    self.dataArray = arrMu.copy;
    [self.tableView reloadData];
    self.tableView.rowHeight = 57;
}

#pragma mark - data source
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.dataArray.count;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    OLPayPartyChargeModel *model = self.dataArray[indexPath.row];
    OLPayPartyChargeTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellID forIndexPath:indexPath];
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
