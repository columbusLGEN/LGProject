//
//  DJSearchWorkPlantformListViewController.m
//  HBDJProj
//
//  Created by Peanut Lee on 2018/8/11.
//  Copyright © 2018年 Lee. All rights reserved.
//

#import "DJSearchWorkPlantformListViewController.h"
#import "DJSearchWorkPlantformCell.h"

@interface DJSearchWorkPlantformListViewController ()

@end

@implementation DJSearchWorkPlantformListViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self.tableView registerNib:[UINib nibWithNibName:searchWPCell bundle:nil] forCellReuseIdentifier:searchWPCell];

    
}


#pragma mark - Table view data source
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.dataArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    DJSearchWorkPlantformCell *cell = [tableView dequeueReusableCellWithIdentifier:searchWPCell forIndexPath:indexPath];
    
    return cell;
}



@end
