//
//  DJUploadThreeMeetingsTableViewController.m
//  HBDJProj
//
//  Created by Peanut Lee on 2018/7/7.
//  Copyright © 2018年 Lee. All rights reserved.
//

#import "DJUploadThreeMeetingsTableViewController.h"
#import "DJSelectMeetingTagViewController.h"

#import "DJOnlineUploadTableModel.h"

@interface DJUploadThreeMeetingsTableViewController ()<
DJSelectMeetingTagViewControllerDelegate>

@end

@implementation DJUploadThreeMeetingsTableViewController

@synthesize dataArray = _dataArray;

- (NSArray *)dataArray{
    if (!_dataArray) {
        _dataArray = [DJOnlineUploadTableModel loadLocalPlistWithPlistName:@"OLUplaodThreeMeetingsTable"];
    }
    return _dataArray;
}

/// MARK: DJSelectMeetingTagViewControllerDelegate
- (void)selectMeetingTag:(DJSelectMeetingTagViewController *)vc selectString:(NSString *)string{
    if (self.dataArray.count != 0) {
        DJOnlineUploadTableModel *firstModel = self.dataArray[0];
        firstModel.content = string;
        [self setFormDataDictValue:string indexPath:[NSIndexPath indexPathForRow:0 inSection:0]];
    }
    [self.tableView reloadData];
}

//- (void)viewDidLoad {
//    [super viewDidLoad];
//
//    // Uncomment the following line to preserve selection between presentations.
//    // self.clearsSelectionOnViewWillAppear = NO;
//
//    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
//    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
//}
//
//- (void)didReceiveMemoryWarning {
//    [super didReceiveMemoryWarning];
//    // Dispose of any resources that can be recreated.
//}
//
//#pragma mark - Table view data source
//- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
//#warning Incomplete implementation, return the number of rows
//    return 0;
//}


@end
