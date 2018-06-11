//
//  HPBuildTableView.m
//  HBDJProj
//
//  Created by Peanut Lee on 2018/6/5.
//  Copyright © 2018年 Lee. All rights reserved.
//

#import "HPBuildTableView.h"
#import "EDJMicroBuildCell.h"
#import "EDJMicroBuildModel.h"

#import "LGDidSelectedNotification.h"

@interface HPBuildTableView ()<
UITableViewDataSource
,UITableViewDelegate>

@end

@implementation HPBuildTableView

@synthesize dataArray = _dataArray;

- (void)setDataArray:(NSArray *)dataArray{
    _dataArray = dataArray;
    [self reloadData];
}

#pragma mark - Table view data source
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.dataArray.count;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    EDJMicroBuildModel *model = _dataArray[indexPath.row];
    EDJMicroBuildCell *cell = [EDJMicroBuildCell cellWithTableView:tableView model:model];
    cell.model = model;
    return cell;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    CGFloat height = [EDJMicroBuildCell cellHeightWithModel:self.dataArray[indexPath.row]];
    return height;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    EDJMicroBuildModel *model = self.dataArray[indexPath.row];
    NSDictionary *dict = @{LGDidSelectedModelKey:model,
                           LGDidSelectedSkipTypeKey:@(LGDidSelectedSkipTypeBuildNews),
                           LGDidSelectedIndexKey:@(indexPath.row)
                           };
    [[NSNotificationCenter defaultCenter] postNotificationName:LGDidSelectedNotification object:nil userInfo:dict];
}

- (instancetype)initWithFrame:(CGRect)frame style:(UITableViewStyle)style{
    if (self = [super initWithFrame:frame style:style]) {
        self.delegate = self;
        self.dataSource = self;

        /// EDJMicroBuildCell
        [self registerNib:[UINib nibWithNibName:buildCellNoImg bundle:nil] forCellReuseIdentifier:buildCellNoImg];
        [self registerNib:[UINib nibWithNibName:buildCellOneImg bundle:nil] forCellReuseIdentifier:buildCellOneImg];
        [self registerNib:[UINib nibWithNibName:buildCellThreeImg bundle:nil] forCellReuseIdentifier:buildCellThreeImg];
        
    }
    return self;
}

@end
