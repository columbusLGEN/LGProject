//
//  TCBookDiscussViewController.m
//  TimeCollege
//
//  Created by Peanut Lee on 2019/4/25.
//  Copyright © 2019 lee. All rights reserved.
//

#import "TCBookDiscussViewController.h"
#import "TCInputDiscussView.h"
#import "TCBookDiscussTableViewCell.h"

static NSString *disCell = @"TCBookDiscussTableViewCell";

@interface TCBookDiscussViewController ()

@end

@implementation TCBookDiscussViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self configUI];
    
}

- (void)configUI{
    self.tableView.estimatedRowHeight = 100.0f;
    [self.tableView registerNib:[UINib nibWithNibName:disCell bundle:nil] forCellReuseIdentifier:disCell];
    
    TCInputDiscussView *commitv = [TCInputDiscussView inputDiscussv];
    commitv.frame = CGRectMake(0, 0, Screen_Width, 220);
    self.tableView.tableHeaderView = commitv;
    
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 30;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    TCBookDiscussTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:disCell forIndexPath:indexPath];
    cell.model = [NSObject new];
    return cell;
}

@end
