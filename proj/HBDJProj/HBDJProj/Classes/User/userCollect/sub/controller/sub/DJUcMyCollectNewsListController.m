//
//  DJUcMyCollectNewsListController.m
//  HBDJProj
//
//  Created by Peanut Lee on 2018/8/29.
//  Copyright © 2018年 Lee. All rights reserved.
//

#import "DJUcMyCollectNewsListController.h"
#import "EDJMicroBuildCell.h"
#import "EDJMicroBuildModel.h"
#import "DJMediaDetailTransAssist.h"

@interface DJUcMyCollectNewsListController ()
@property (strong,nonatomic) DJMediaDetailTransAssist *transAssist;

@end

@implementation DJUcMyCollectNewsListController{
    NSInteger offset;
}

- (void)setDataArray:(NSArray *)dataArray{
    [super setDataArray:dataArray];
    
    offset = dataArray.count;
    [self.tableView.mj_footer resetNoMoreData];
    [[NSOperationQueue mainQueue] addOperationWithBlock:^{
        [self.tableView reloadData];
    }];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    /// EDJMicroBuildCell
    [self.tableView registerNib:[UINib nibWithNibName:buildCellNoImg bundle:nil] forCellReuseIdentifier:buildCellNoImg];
    [self.tableView registerNib:[UINib nibWithNibName:buildCellOneImg bundle:nil] forCellReuseIdentifier:buildCellOneImg];
    [self.tableView registerNib:[UINib nibWithNibName:buildCellThreeImg bundle:nil] forCellReuseIdentifier:buildCellThreeImg];
    
    NSMutableArray *arrmu = NSMutableArray.new;
    for (NSInteger i = 0; i < 20; i++) {
        EDJMicroBuildModel *model = EDJMicroBuildModel.new;
        if (i == 0) {
            model.cover = @"https://timgsa.baidu.com/timg?image&quality=80&size=b9999_10000&sec=1535603406067&di=61e585c1a31ef30586dda25962ea79d8&imgtype=jpg&src=http%3A%2F%2Fimg0.imgtn.bdimg.com%2Fit%2Fu%3D749865265%2C4035234656%26fm%3D214%26gp%3D0.jpg";
        }else if (i == 1) {
            model.cover = @"";
        }else if ((i % 2 == 0)) {
            model.cover = @"https://timgsa.baidu.com/timg?image&quality=80&size=b9999_10000&sec=1535603406067&di=61e585c1a31ef30586dda25962ea79d8&imgtype=jpg&src=http%3A%2F%2Fimg0.imgtn.bdimg.com%2Fit%2Fu%3D749865265%2C4035234656%26fm%3D214%26gp%3D0.jpg,https://timgsa.baidu.com/timg?image&quality=80&size=b9999_10000&sec=1535603406067&di=61e585c1a31ef30586dda25962ea79d8&imgtype=jpg&src=http%3A%2F%2Fimg0.imgtn.bdimg.com%2Fit%2Fu%3D749865265%2C4035234656%26fm%3D214%26gp%3D0.jpg,https://timgsa.baidu.com/timg?image&quality=80&size=b9999_10000&sec=1535603406067&di=61e585c1a31ef30586dda25962ea79d8&imgtype=jpg&src=http%3A%2F%2Fimg0.imgtn.bdimg.com%2Fit%2Fu%3D749865265%2C4035234656%26fm%3D214%26gp%3D0.jpg";
        }
        model.title = @"我的收藏新闻列表测试我的收藏新闻列表测试我的收藏新闻列表测试我的收藏新闻列表测试";
        model.source = @"新华社";
        [arrmu addObject:model];
    }
    self.dataArray = arrmu.copy;
    [self.tableView reloadData];
    
    
//    self.tableView.mj_footer = [MJRefreshAutoNormalFooter footerWithRefreshingBlock:^{
//        [self getData];
//    }];
}

- (void)getData{
    
}

#pragma mark - Table view data source
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.dataArray.count;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    EDJMicroBuildModel *model = self.dataArray[indexPath.row];
    EDJMicroBuildCell *cell = [EDJMicroBuildCell cellWithTableView:tableView model:model];
    cell.collectModel = model;
    
    return cell;
}

- (void)tableView:(UITableView *)tableView willDisplayCell:(EDJMicroBuildCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath{
    EDJMicroBuildModel *model = self.dataArray[indexPath.row];
    cell.model = model;
}


- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    CGFloat height = [EDJMicroBuildCell cellHeightWithModel:self.dataArray[indexPath.row]];
    return height;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    /// 编辑状态
    DJUcMyCollectModel *model = self.dataArray[indexPath.row];
    model.select = !model.select;
    
//    EDJMicroBuildModel *model = self.dataArray[indexPath.row];
//    [self.transAssist skipWithType:2 model:model baseVc:self];
    
}

- (DJMediaDetailTransAssist *)transAssist{
    if (!_transAssist) {
        _transAssist = [DJMediaDetailTransAssist new];
    }
    return _transAssist;
}

@end
