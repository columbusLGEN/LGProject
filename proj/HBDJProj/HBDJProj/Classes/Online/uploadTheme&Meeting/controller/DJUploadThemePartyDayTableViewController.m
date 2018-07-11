//
//  DJUploadThemePartyDayTableViewController.m
//  HBDJProj
//
//  Created by Peanut Lee on 2018/7/7.
//  Copyright © 2018年 Lee. All rights reserved.
//

#import "DJUploadThemePartyDayTableViewController.h"
#import "DJOnlineUploadTableModel.h"

@interface DJUploadThemePartyDayTableViewController ()

@end

@implementation DJUploadThemePartyDayTableViewController

@synthesize dataArray = _dataArray;

- (NSArray *)dataArray{
    if (!_dataArray) {
        _dataArray = [DJOnlineUploadTableModel loadLocalPlistWithPlistName:@"OLUplaodThemeTable"];
//        NSLog(@"_dataarray: %@",_dataArray);
    }
    return _dataArray;
}

//- (void)viewDidLoad {
//    [super viewDidLoad];
//    
//
//}

#pragma mark - Table view data source
//- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
//    return [super tableView:tableView numberOfRowsInSection:section];
//}
//- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
//    return [super tableView:tableView cellForRowAtIndexPath:indexPath];
//}


@end
