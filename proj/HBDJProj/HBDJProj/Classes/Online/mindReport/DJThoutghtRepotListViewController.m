//
//  DJThoutghtRepotListViewController.m
//  HBDJProj
//
//  Created by Peanut Lee on 2018/7/11.
//  Copyright © 2018年 Lee. All rights reserved.
//

#import "DJThoutghtRepotListViewController.h"
#import "DJThoutghtRepotListModel.h"
#import "DJThoutghtRepotListTableViewCell.h"
#import "UCUploadViewController.h"

@interface DJThoutghtRepotListViewController ()

@end

@implementation DJThoutghtRepotListViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self.tableView registerNib:[UINib nibWithNibName:thoughtRepotrListCell bundle:nil] forCellReuseIdentifier:thoughtRepotrListCell];
    self.tableView.rowHeight = 100;
    
    NSMutableArray *arrMu = [NSMutableArray new];
    for (NSInteger i = 0; i < 20; i++) {
        DJThoutghtRepotListModel *model = [DJThoutghtRepotListModel new];
        model.title = @"思想汇报/述职述廉";
        model.author = @"党小伟";
        model.time = @"2018-04-11";
        [arrMu addObject:model];
    }
    self.dataArray = arrMu.copy;
    [self.tableView reloadData];
    
    UIBarButtonItem *create = [UIBarButtonItem.alloc initWithTitle:@"创建" style:UIBarButtonItemStyleDone target:self action:@selector(create)];
    self.navigationItem.rightBarButtonItem = create;
}
- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:NO animated:YES];
}

#pragma mark - target
- (void)create{
    UCUploadViewController *upvc = UCUploadViewController.new;
    upvc.uploadType = UploadTyleMindReport;
    upvc.pushWay = LGBaseViewControllerPushWayModal;
    LGBaseNavigationController *nav = [LGBaseNavigationController.alloc initWithRootViewController:upvc];
    [self presentViewController:nav animated:YES completion:nil];
}

#pragma mark - Table view data source
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.dataArray.count;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    DJThoutghtRepotListModel *model = self.dataArray[indexPath.row];
    DJThoutghtRepotListTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:thoughtRepotrListCell forIndexPath:indexPath];
    cell.model = model;
    
    return cell;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
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
