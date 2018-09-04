//
//  HPSearchLessonController
//  HBDJProj
//
//  Created by Peanut Lee on 2018/6/1.
//  Copyright © 2018年 Lee. All rights reserved.
//

#import "HPSearchLessonController.h"
#import "EDJMicroPartyLessonSubCell.h"
#import "DJDataBaseModel.h"

#import "DJMediaDetailTransAssist.h"

@interface HPSearchLessonController ()
@property (strong,nonatomic) DJMediaDetailTransAssist *transAssist;

@end

@implementation HPSearchLessonController{
    NSInteger offset;
}

@synthesize dataArray = _dataArray;

- (void)setDataArray:(NSArray *)dataArray{
    _dataArray = dataArray;
    offset = dataArray.count;
    [[NSOperationQueue mainQueue] addOperationWithBlock:^{
        [self.tableView reloadData];
    }];
}

- (void)viewDidLoad{
    [super viewDidLoad];
    
    offset = 0;
    self.tableView.rowHeight = homeMicroLessonSubCellBaseHeight * rateForMicroLessonCellHeight();
    [self.tableView registerNib:[UINib nibWithNibName:microPartyLessonSubCell bundle:nil] forCellReuseIdentifier:microPartyLessonSubCell];
    
    self.tableView.mj_footer = [MJRefreshAutoNormalFooter footerWithRefreshingTarget:self refreshingAction:@selector(getMoreLesson)];
}
- (void)getMoreLesson{
    [DJHomeNetworkManager homeSearchWithString:_searchContent type:1 offset:offset length:1 sort:0 success:^(id responseObj) {
        NSLog(@"homesearch_loadmore_lesson: %@",responseObj);
        NSArray *array = (NSArray *)responseObj;
        NSMutableArray *arrayMutable = [NSMutableArray arrayWithArray:self.dataArray];
        [array enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            DJDataBaseModel *model = [DJDataBaseModel mj_objectWithKeyValues:obj];
            [arrayMutable addObject:model];
        }];
        self.dataArray = arrayMutable.copy;
        [[NSOperationQueue mainQueue] addOperationWithBlock:^{
            [self.tableView.mj_footer endRefreshing];
            [self.tableView reloadData];
        }];
    } failure:^(id failureObj) {
        NSLog(@"homesearch_loadmore_lesson_failure -- %@",failureObj);
        
    }];
}

#pragma mark - Table view data source
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.dataArray.count;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    DJDataBaseModel *model = self.dataArray[indexPath.row];
    EDJMicroPartyLessonSubCell *cell = [tableView dequeueReusableCellWithIdentifier:microPartyLessonSubCell forIndexPath:indexPath];
    cell.model = model;
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    DJDataBaseModel *lesson = self.dataArray[indexPath.row];
    [self.transAssist mediaDetailWithModel:lesson baseVc:self];
}

- (DJMediaDetailTransAssist *)transAssist{
    if (!_transAssist) {
        _transAssist = [DJMediaDetailTransAssist new];
    }
    return _transAssist;
}

@end
