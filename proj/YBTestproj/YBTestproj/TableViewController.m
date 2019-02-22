//
//  TableViewController.m
//  YBTestproj
//
//  Created by Peanut Lee on 2019/2/22.
//  Copyright © 2019 Libc. All rights reserved.
//

#import "TableViewController.h"
#import "Model.h"

static NSString * const homeCell = @"homeCell";

@interface TableViewController ()


@end

@implementation TableViewController{
    NSArray *array;
}


- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self.tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:homeCell];
    
    array = [Model loadLocalPlistWithPlistName:@"home"];
    [self.tableView reloadData];
}

#pragma mark - Table view data source

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return array.count;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    Model *model = array[indexPath.row];
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:homeCell forIndexPath:indexPath];
    
    [cell.textLabel setText:model.name];
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    Model *model = array[indexPath.row];
    model.id;
    
}


@end
