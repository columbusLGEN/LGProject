//
//  UCPersonInfoViewController.m
//  HBDJProj
//
//  Created by Peanut Lee on 2018/4/12.
//  Copyright © 2018年 Lee. All rights reserved.
//

#import "UCPersonInfoViewController.h"
#import "UCPersonInfoModel.h"
#import "UCPersonInfoTableViewCell.h"

@interface UCPersonInfoViewController ()
@property (strong,nonatomic) NSArray *array;

@end

@implementation UCPersonInfoViewController

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:NO animated:YES];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    NSMutableArray *arr = [NSMutableArray arrayWithCapacity:10];
    for (int i = 0;i < 11; i++) {
        UCPersonInfoModel *model = [UCPersonInfoModel new];
        if (i == 0 || i == 5) {
            model.iconUrl = @"11";
        }
        if (i == 3) {
            model.itemName = @"密码";
        }else{
            model.itemName = @"其他";
        }
        [arr addObject:model];
    }
    _array = arr.copy;
    [self.tableView reloadData];
}

#pragma mark - Table view data source

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {

    return _array.count;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UCPersonInfoModel *model = _array[indexPath.row];
    UCPersonInfoTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:[UCPersonInfoTableViewCell cellReuseIdWithModel:model]];
    cell.model = model;
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    UCPersonInfoModel *model = _array[indexPath.row];
    if (model.canChangePwd) {
        /// 修改密码
        [self lgPushViewControllerWithStoryboardName:UserCenterStoryboardName controllerId:@"EDJModifiPwdViewController" animated:YES];
    }
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender{
    ///  
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
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
