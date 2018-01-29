//
//  ECRSortTableViewController.m
//  EasyChineseReading-ios
//
//  Created by lee on 2017/8/30.
//  Copyright © 2017年 lee. All rights reserved.
//

static NSString *reuserID = @"ECRSortTableViewCell";
//static CGFloat sortCellH = 40;//MARK: 筛选条件行高

#import "ECRSortTableViewController.h"
#import "ECRMoreRowModel.h"
#import "ECRSortTableViewCell.h"
#import "UIImage+LEEImageExtension.h"
#import "ECRClassSortModel.h"

@interface ECRSortTableViewController ()<
ECRSortTableViewCellDelegate
>

@end

@implementation ECRSortTableViewController

- (void)setDataArray:(NSArray *)dataArray{
    _dataArray = dataArray;
    [self.tableView reloadData];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setupUI];
}

- (void)setupUI{
    [self.tableView registerClass:[ECRSortTableViewCell class] forCellReuseIdentifier:reuserID];
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.tableView.scrollEnabled = NO;
}

#pragma mark - ECRSortTableViewCellDelegate
- (void)stbCell:(ECRSortTableViewCell *)cell classModel:(ECRClassSortModel *)classModel indexPath:(NSIndexPath *)indexPath{
    ECRMoreRowModel *rowModel = self.dataArray[indexPath.row];
//    if ([self.delegate respondsToSelector:@selector(stbController:classModel:rowModel:)]) {
//        [self.delegate stbController:self classModel:classModel rowModel:rowModel];
//    }
    if ([self.delegate respondsToSelector:@selector(stbController:classModel:rowModel:indexPath:)]) {
        [self.delegate stbController:self classModel:classModel rowModel:rowModel indexPath:indexPath];
    }
    
    [self.tableView reloadData];
}
- (void)stbCell:(ECRSortTableViewCell *)cell classModel:(ECRClassSortModel *)classModel indexPath:(NSIndexPath *)indexPath rowSelectedModelId:(NSInteger)rowSelectedModelId{
//    NSLog(@"rowselid -- %ld",rowSelectedModelId);
}
#pragma mark - Table view data source
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return _dataArray.count ? _dataArray.count : 0;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    ECRSortTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:reuserID forIndexPath:indexPath];
    cell.bookListType = self.bookListType;
    cell.delegate = self;
    ECRMoreRowModel *model;
    if (self.dataArray) {
        model = self.dataArray[indexPath.row];
    }
    model.indexPath = indexPath;
    cell.model = model;// 先执行
    cell.indexPath = indexPath;
    if (indexPath.row == (self.dataArray.count - 1)) {// 最后一行添加分割线
    }
    return cell;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return self.sortCellH;
}

- (CGFloat)sortCellH{
    if ([[ECRMultiObject sharedInstance] userInterfaceIdiom] == UIUserInterfaceIdiomPad) {
        return 46;
    }else{
        return 40;
    }
}

@end



