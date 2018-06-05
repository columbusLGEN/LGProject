//
//  HPMicrolessonView.m
//  HBDJProj
//
//  Created by Peanut Lee on 2018/6/4.
//  Copyright © 2018年 Lee. All rights reserved.
//

#import "HPMicrolessonView.h"
#import "EDJMicroBuildModel.h"
#import "EDJMicroPartyLessonCell.h"

static NSString * const microCell = @"EDJMicroPartyLessonCell";
static NSString * const microHeaderCell = @"EDJMicroPartyLessonHeaderCell";

@interface HPMicrolessonView ()<
UITableViewDataSource
,UITableViewDelegate>


@end

@implementation HPMicrolessonView

- (void)setDataArray:(NSArray *)dataArray{
    _dataArray = dataArray;
    [self reloadData];
}

#pragma mark - Table view data source
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.dataArray.count;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    EDJMicroBuildModel *model = self.dataArray[indexPath.row];
    EDJMicroPartyLessonCell *cell = [EDJMicroPartyLessonCell cellWithTableView:tableView model:model];
    cell.model = model;
    return cell;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    CGFloat height = [EDJMicroPartyLessonCell cellHeightWithModel:self.dataArray[indexPath.row]];
    NSLog(@"zhuanjiheight -- %f -- %ld",height,indexPath.row);
    return height;
}

- (instancetype)initWithFrame:(CGRect)frame style:(UITableViewStyle)style{
    if (self = [super initWithFrame:frame style:style]) {
        self.delegate = self;
        self.dataSource = self;
        
        [self registerClass:[EDJMicroPartyLessonCell class] forCellReuseIdentifier:microCell];
        [self registerNib:[UINib nibWithNibName:microHeaderCell bundle:nil] forCellReuseIdentifier:microHeaderCell];
//        self.header = [STRefreshHeader headerWithRefreshingBlock:^(STRefreshHeader *header) {
//            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(3 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
//                [header endRefreshing];
//            });
//        }];
    }
    return self;
}

@end
