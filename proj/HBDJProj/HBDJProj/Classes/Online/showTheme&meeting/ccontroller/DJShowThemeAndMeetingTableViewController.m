//
//  DJShowThemeAndMeetingTableViewController.m
//  HBDJProj
//
//  Created by Peanut Lee on 2018/7/10.
//  Copyright © 2018年 Lee. All rights reserved.
//

#import "DJShowThemeAndMeetingTableViewController.h"
#import "DJThemeMeetingsModel.h"
#import "DJOnlineUploadTableModel.h"
#import "DJShowThemeMeetingBaseCell.h"
#import "DJShowThmemeMeetingImageCell.h"
#import "DJShowThmemeMeetingNormalTextCell.h"
#import "DJShowThmemeMeetingMoreTextCell.h"

@interface DJShowThemeAndMeetingTableViewController ()
/** 是否展示全部会议内容，默认只显示三行 */
@property (assign,nonatomic) BOOL contentShowAll;

@end

@implementation DJShowThemeAndMeetingTableViewController

@synthesize dataArray = _dataArray;

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self.tableView registerClass:[DJShowThmemeMeetingNormalTextCell class] forCellReuseIdentifier:showTMNormalTextcell];
    [self.tableView registerClass:[DJShowThmemeMeetingMoreTextCell class] forCellReuseIdentifier:showTMMoreTextcell];
    [self.tableView registerClass:[DJShowThmemeMeetingImageCell class] forCellReuseIdentifier:showTMImgagecell];
    
    _contentShowAll = NO;
}

- (void)setDataArray:(NSArray *)dataArray{
    _dataArray = dataArray;
    [self.tableView reloadData];
}

#pragma mark - Table view data source
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.dataArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    DJOnlineUploadTableModel *tableModel = self.dataArray[indexPath.row];
    DJShowThemeMeetingBaseCell *cell = [tableView dequeueReusableCellWithIdentifier:[DJShowThemeMeetingBaseCell cellReuseIdWithModel:tableModel] forIndexPath:indexPath];
    cell.model = tableModel;
    
    return cell;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    DJOnlineUploadTableModel *tableModel = self.dataArray[indexPath.row];
    UITableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
    if ([cell isMemberOfClass:[DJShowThmemeMeetingMoreTextCell class]]) {
        _contentShowAll = !_contentShowAll;
        tableModel.contentShowAll = _contentShowAll;
    }
    [self.tableView reloadData];
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
