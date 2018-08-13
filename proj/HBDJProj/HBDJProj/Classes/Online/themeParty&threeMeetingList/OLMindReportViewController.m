//
//  OLMindReportViewController.m
//  HBDJProj
//
//  Created by Peanut Lee on 2018/5/3.
//  Copyright © 2018年 Lee. All rights reserved.
//

#import "OLMindReportViewController.h"
#import "OLMindReportTableViewCell.h"
#import "DJThemeMeetingsModel.h"

#import "DJUploadThemePartyDayTableViewController.h"/// 上传数据
#import "DJShowThemeAndMeetingTableViewController.h"/// 展示数据

#import "DJOnlineNetorkManager.h"

@interface OLMindReportViewController ()<DJOnlineUplaodTableViewControllerDelegate>
@property (assign,nonatomic) NSInteger offset;

@end

@implementation OLMindReportViewController

/// TODO: 限制用户权限，只有机构管理员才显示 上传 功能

- (void)viewDidLoad {
    [super viewDidLoad];
    [self configUI];
    _offset = 0;
    [self getNetDataWithOffset:_offset];
}

- (void)getNetDataWithOffset:(NSInteger)offset{
    
    if (offset == 0) {
        [self.tableView.mj_footer resetNoMoreData];
    }
    
    [DJOnlineNetorkManager.sharedInstance frontThemesWithOffset:offset length:10 success:^(id responseObj) {
        NSArray *array = responseObj;
        BOOL arrayIsNull = (array == nil || array.count == 0);
        
        if (offset == 0) {
            [self.tableView.mj_header endRefreshing];
        }else{
            if (arrayIsNull) {
                [self.tableView.mj_footer endRefreshingWithNoMoreData];
            }else{
                [self.tableView.mj_footer endRefreshing];
            }
        }
        
        if (arrayIsNull) {
            return;
        }else{
            NSMutableArray *mutabelArray;
            if (offset == 0) {
                mutabelArray = NSMutableArray.new;
            }else{
                mutabelArray = [NSMutableArray arrayWithArray:self.dataArray];
            }
            
            for (NSInteger i = 0; i < array.count; i++) {
                NSDictionary *dict = array[i];
                DJThemeMeetingsModel  *model = [DJThemeMeetingsModel mj_objectWithKeyValues:dict];
                [mutabelArray addObject:model];
            }
            self.dataArray = mutabelArray.copy;
            _offset = self.dataArray.count;
            [[NSOperationQueue mainQueue] addOperationWithBlock:^{
                [self.tableView reloadData];
            }];
        }
    } failure:^(id failureObj) {
        [self presentFailureTips:@"网络异常或者数据为空"];
        if (offset == 0) {
            [self.tableView.mj_header endRefreshing];
        }else{
            [self.tableView.mj_footer endRefreshing];
        }
    }];


}


#pragma mark - target
- (void)createContent{
    
    /// 创建主题党日
    DJUploadThemePartyDayTableViewController *olupvc = [[DJUploadThemePartyDayTableViewController alloc] init];
    olupvc.delegate = self;
    [self.navigationController pushViewController:olupvc animated:YES];
}

#pragma mark - delegate
- (void)threeMeetingOrThemeUploadDone{
    _offset = 0;
    [self getNetDataWithOffset:_offset];
}

/// MARK: tablview 代理、数据源
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.dataArray.count;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    DJThemeMeetingsModel *model = self.dataArray[indexPath.row];
    OLMindReportTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellID forIndexPath:indexPath];
    cell.model = model;
    return cell;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 100;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    DJThemeMeetingsModel *model = self.dataArray[indexPath.row];
//    DJThemeMeetingsModel *model = DJThemeMeetingsModel.new;
//    model.meetTag = @"党小组会议";
//    model.title = @"测试主题";
//    model.date = @"20180711";
//    model.address = @"国贸大厦";
//    model.organizer = @"王建国";
//    model.attendusers = @"王建国，张建军，刘国庆";
//    model.absentusers = @"赵铁柱，李大庆，党小伟";
//    model.introduction = @"央视财经《央视财经评论》）日前，国务院办公厅转发商务部等20个部门《关于扩大进口 促进对外贸易平衡发展的意见》。《意见》从四个方面提出政策举措：一是优化进口结构，促进生产消费升级；二是优化国际市场布局；三是积极发挥多渠道促进作用；四是改善贸易自由化便利化条件。其中，在优化进口结构方面，提出了四个方向，包括：支持关系民生的产品进口、积极发展服务贸易、增加有助于转型发展的技术装备进口、增加农产品和资源性产品进口。";
//    model.fileurl = @"http://pic5.photophoto.cn/20071228/0034034901778224_b.jpg,http://img4.imgtn.bdimg.com/it/u=3797629993,3212912695&fm=27&gp=0.jpg,http://pic33.photophoto.cn/20141117/0005018399944269_b.jpg,http://f8.topitme.com/8/0d/dd/1131049236b4ddd0d8o.jpg,http://pic34.photophoto.cn/20150113/0006019095934688_b.jpg,http://www.sinaimg.cn/qc/photo_auto/chezhan/2012/50/13/51/66426_src.jpg,http://pic3.16pic.com/00/07/65/16pic_765230_b.jpg,http://pic33.photophoto.cn/20141214/0005018393247763_b.jpg";

    NSArray *dataArray = [model tableModelsWithType:0];
    
    /// 进入详情页面
    DJShowThemeAndMeetingTableViewController *vc = DJShowThemeAndMeetingTableViewController.new;
    vc.dataArray = dataArray;
    vc.title = model.title;
    [self.navigationController pushViewController:vc animated:YES];
}

#pragma mark - config UI
- (void)configUI{
    self.title = @"主题党日";
    UIBarButtonItem *item_create = [[UIBarButtonItem alloc] initWithTitle:@"创建" style:UIBarButtonItemStyleDone target:self action:@selector(createContent)];
    self.navigationItem.rightBarButtonItem = item_create;
    
    [self.tableView registerNib:[UINib nibWithNibName:cellID bundle:nil] forCellReuseIdentifier:cellID];
    
    /// 下拉刷新
    self.tableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        _offset = 0;
        [self getNetDataWithOffset:_offset];
    }];
    /// 上拉刷新
    self.tableView.mj_footer = [MJRefreshAutoNormalFooter footerWithRefreshingBlock:^{
        [self getNetDataWithOffset:_offset];
    }];
    
}


- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:NO animated:YES];
}

@end
