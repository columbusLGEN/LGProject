//
//  DJUcMyCollectLessonListController.m
//  HBDJProj
//
//  Created by Peanut Lee on 2018/8/29.
//  Copyright © 2018年 Lee. All rights reserved.
//

#import "DJUcMyCollectLessonListController.h"
#import "DJUcMyCollectLessonCell.h"
#import "DJUcMyCollectLessonModel.h"

@interface DJUcMyCollectLessonListController ()

@end

@implementation DJUcMyCollectLessonListController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.tableView.rowHeight = homeMicroLessonSubCellBaseHeight * rateForMicroLessonCellHeight();
    [self.tableView registerClass:[DJUcMyCollectLessonCell class] forCellReuseIdentifier:mclCell];
    
    NSMutableArray *arrmu = NSMutableArray.new;
    for (NSInteger i = 0;i < 20 ; i++) {
        DJUcMyCollectLessonModel *model = DJUcMyCollectLessonModel.new;
        model.title = @"测试标题测试标题测试标题测试标题测试标题测试标题测试标题测试标题";
        model.createdDate = @"2018-08-31";
        model.cover = @"http://c.hiphotos.baidu.com/image/pic/item/8694a4c27d1ed21b3c778fdda06eddc451da3f4f.jpg";
        model.playcount = 3333;
        [arrmu addObject:model];
    }
    self.dataArray = arrmu.copy;
    [self.tableView reloadData];
}

#pragma mark - Table view data source
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.dataArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    DJUcMyCollectLessonModel *model = self.dataArray[indexPath.row];
    DJUcMyCollectLessonCell *cell = [tableView dequeueReusableCellWithIdentifier:mclCell forIndexPath:indexPath];
    cell.collectModel = model;
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    /// 编辑状态
    DJUcMyCollectModel *model = self.dataArray[indexPath.row];
    model.select = !model.select;
}

///// 继承自父类的方法
//- (void)startEdit{
//    for (DJUcMyCollectLessonModel *model in self.dataArray) {
//        model.edit = YES;
//    }
//    [self.tableView reloadData];
//}
//- (void)endEdit{
//    for (DJUcMyCollectLessonModel *model in self.dataArray) {
//        model.edit = NO;
//    }
//    [self.tableView reloadData];
//}
//- (void)allSelect{
//    /// 全选判定条件
//    /// 如果全部是选中状态，则取消全部选中状态；否则全部选中
//    
//    /// 判断是否全部选中
//    BOOL allAlreadySelect = YES;
//    for (DJUcMyCollectLessonModel *model in self.dataArray) {
//        if (!model.select) {
//            allAlreadySelect = NO;
//            break;
//        }
//    }
//    
//    BOOL select;
//    if (allAlreadySelect) {
//        select = NO;
//    }else{
//        select = YES;
//    }
//    
//    for (DJUcMyCollectLessonModel *model in self.dataArray) {
//        model.select = select;
//    }
//    [self.tableView reloadData];
//}


@end
