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

#import "LGDidSelectedNotification.h"

static NSString * const microCell = @"EDJMicroPartyLessonCell";
static NSString * const microHeaderCell = @"EDJMicroPartyLessonHeaderCell";

@interface HPMicrolessonView ()<
UITableViewDataSource
,UITableViewDelegate>

@end

@implementation HPMicrolessonView

/// 如果想要重写父类属性的setter，需要添加该行代码
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
    EDJMicroBuildModel *model = self.dataArray[indexPath.row];
    EDJMicroPartyLessonCell *cell = [EDJMicroPartyLessonCell cellWithTableView:tableView model:model];
    cell.model = model;
    return cell;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    CGFloat height = [EDJMicroPartyLessonCell cellHeightWithModel:self.dataArray[indexPath.row]];
    return height;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    EDJMicroBuildModel *model = nil;
    if (indexPath.row == 0) {
        NSLog(@"头部专辑 -- ");
        /// TODO: 如何从头部2选1？
    }else{
        NSLog(@"其他专辑 -- ");
        model = self.dataArray[indexPath.row];
    }
    NSDictionary *dict = @{LGDidSelectedModelKey:model?model:[NSObject new],
                           LGDidSelectedSkipTypeKey:@(LGDidSelectedSkipTypeMicrolessonAlbum)
                           };
    [[NSNotificationCenter defaultCenter] postNotificationName:LGDidSelectedNotification object:nil userInfo:dict];
}

- (instancetype)initWithFrame:(CGRect)frame style:(UITableViewStyle)style{
    if (self = [super initWithFrame:frame style:style]) {
        self.delegate = self;
        self.dataSource = self;
        
        [self registerClass:[EDJMicroPartyLessonCell class] forCellReuseIdentifier:microCell];
        [self registerNib:[UINib nibWithNibName:microHeaderCell bundle:nil] forCellReuseIdentifier:microHeaderCell];
        
    }
    return self;
}

@end
