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
#import "EDJMicroLessionAlbumModel.h"
#import "DJMediaDetailTransAssist.h"
#import "DJHomeSearchAlbumCell.h"
#import "HPAlbumTableViewController.h"

@interface HPSearchLessonController ()
@property (strong,nonatomic) DJMediaDetailTransAssist *transAssist;

@end

@implementation HPSearchLessonController{
    NSInteger offset;
}

@synthesize dataArray = _dataArray;

- (void)setDataArray:(NSArray *)dataArray{
    _dataArray = dataArray;
//    offset = dataArray.count - self.albumCount;
    offset = dataArray.count;
    [[NSOperationQueue mainQueue] addOperationWithBlock:^{
        [self.tableView reloadData];
    }];
}

- (void)viewDidLoad{
    [super viewDidLoad];
    
    offset = 0;
//    self.tableView.rowHeight = homeMicroLessonSubCellBaseHeight * rateForMicroLessonCellHeight();
    
    [self.tableView registerNib:[UINib nibWithNibName:microPartyLessonSubCell bundle:nil] forCellReuseIdentifier:microPartyLessonSubCell];
    [self.tableView registerNib:[UINib nibWithNibName:homeSearchAlbumCell bundle:nil] forCellReuseIdentifier:homeSearchAlbumCell];
    
    self.tableView.mj_footer = [MJRefreshAutoNormalFooter footerWithRefreshingTarget:self refreshingAction:@selector(getMoreLesson)];
}
- (void)getMoreLesson{
    [DJHomeNetworkManager homeSearchWithString:_searchContent type:1 offset:offset length:10 sort:0 success:^(id responseObj) {
        
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
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 2;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (section == 0) {
        return self.albumModels.count;
    }else{
        return self.dataArray.count;
    }
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {

    if (indexPath.section == 0) {
        EDJMicroLessionAlbumModel *model = self.albumModels[indexPath.row];
        DJHomeSearchAlbumCell *cell = [tableView dequeueReusableCellWithIdentifier:homeSearchAlbumCell forIndexPath:indexPath];
        cell.model = model;
        return cell;
    }else{
        DJDataBaseModel *model = self.dataArray[indexPath.row];
        EDJMicroPartyLessonSubCell *cell = [tableView dequeueReusableCellWithIdentifier:microPartyLessonSubCell forIndexPath:indexPath];
        cell.model = model;
        return cell;
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.section == 0) {
        return 50;
    }else{
        return homeMicroLessonSubCellBaseHeight * rateForMicroLessonCellHeight();
    }
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    UIView *view = UIView.new;
    view.backgroundColor = UIColor.EDJGrayscale_F3;
    return view;
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    if (section == 0) {
        return 0;
    }else{
        return 8;
    }
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.section == 0) {
        /// 进入专辑列表
        EDJMicroLessionAlbumModel *albumModel = self.albumModels[indexPath.row];
        HPAlbumTableViewController *album = [HPAlbumTableViewController new];
        albumModel.classid = albumModel.seqid;
        album.albumModel = albumModel;
        [self.navigationController pushViewController:album animated:YES];
    }else{
        DJDataBaseModel *lesson = self.dataArray[indexPath.row];
        [self.transAssist mediaDetailWithModel:lesson baseVc:self dataSyncer:self.dataSyncer];
    }
}

- (DJMediaDetailTransAssist *)transAssist{
    if (!_transAssist) {
        _transAssist = [DJMediaDetailTransAssist new];
    }
    return _transAssist;
}

@end
