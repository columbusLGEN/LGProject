//
//  DCQuestionCommunityViewController.m
//  HBDJProj
//
//  Created by Peanut Lee on 2018/4/27.
//  Copyright © 2018年 Lee. All rights reserved.
//

#import "DCQuestionCommunityViewController.h"
#import "UCQuestionTableViewCell.h"

static NSString * const cellID = @"UCQuestionTableViewCell";

@interface DCQuestionCommunityViewController ()
@property (strong,nonatomic) NSArray *array;

@end

@implementation DCQuestionCommunityViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self.tableView registerNib:[UINib nibWithNibName:cellID bundle:nil] forCellReuseIdentifier:cellID];
    NSMutableArray *arr = [NSMutableArray new];
    for (int i = 0; i < 5; i++) {
        UCQuestionModel *model = [UCQuestionModel new];
        [arr addObject:model];
    }
    _array = arr.copy;
    [self.tableView reloadData];
}

#pragma mark - Table view data source
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return _array.count;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    UCQuestionModel *model = _array[indexPath.row];
    UCQuestionTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellID];
    cell.model = model;
    return cell;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 187;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
}

@end
