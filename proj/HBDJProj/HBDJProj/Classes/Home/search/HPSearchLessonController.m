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

@interface HPSearchLessonController ()

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
    self.tableView.estimatedRowHeight = 90;
    [self.tableView registerNib:[UINib nibWithNibName:microPartyLessonSubCell bundle:nil] forCellReuseIdentifier:microPartyLessonSubCell];
    
//    NSMutableArray *arr = [NSMutableArray array];
//    for (int i = 0; i < 20; i++) {
//        DJDataBaseModel *model = [DJDataBaseModel new];
//        [arr addObject:model];
//    }
//    self.dataArray = arr.copy;
//    [self.tableView reloadData];
    
    self.tableView.mj_footer = [MJRefreshAutoNormalFooter footerWithRefreshingTarget:self refreshingAction:@selector(getMoreLesson)];
}
- (void)getMoreLesson{
    [DJNetworkManager homeSearchWithString:_searchContent type:1 offset:offset length:1 sort:0 success:^(id responseObj) {
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


/*
// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the specified item to be editable.
    return YES;
}
*/

/*
// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    } else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }   
}
*/

/*
// Override to support rearranging the table view.
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath {
}
*/

/*
// Override to support conditional rearranging of the table view.
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the item to be re-orderable.
    return YES;
}
*/

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
