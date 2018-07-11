//
//  OLMindReportViewController.m
//  HBDJProj
//
//  Created by Peanut Lee on 2018/5/3.
//  Copyright © 2018年 Lee. All rights reserved.
//

#import "OLMindReportViewController.h"
#import "OLMindReportTableViewCell.h"
#import "OLMindReportModel.h"

#import "DJUploadThemePartyDayTableViewController.h"/// 上传数据
#import "DJShowThemeAndMeetingTableViewController.h"/// 展示数据

@interface OLMindReportViewController ()

@end

@implementation OLMindReportViewController


- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:NO animated:YES];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self configUI];
    
}

#pragma mark - target
- (void)createContent{
    /// 创建主题党日
    DJUploadThemePartyDayTableViewController *olupvc = [[DJUploadThemePartyDayTableViewController alloc] init];
    [self.navigationController pushViewController:olupvc animated:YES];
}

#pragma mark - delegate
/// MARK: tablview 代理、数据源
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.dataArray.count;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    OLMindReportModel *model = self.dataArray[indexPath.row];
    OLMindReportTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellID forIndexPath:indexPath];
    cell.model = model;
    return cell;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 100;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    DJThemeMeetingsModel *detailModel = DJThemeMeetingsModel.new;
    detailModel.meetTag = @"党小组会议";
    detailModel.title = @"测试主题";
    detailModel.time = @"20180711";
    detailModel.location = @"国贸大厦";
    detailModel.host = @"王建国";
    detailModel.presents = @"王建国，张建军，刘国庆";
    detailModel.absents = @"赵铁柱，李大庆，党小伟";
    detailModel.meetContent = @"央视财经《央视财经评论》）日前，国务院办公厅转发商务部等20个部门《关于扩大进口 促进对外贸易平衡发展的意见》。《意见》从四个方面提出政策举措：一是优化进口结构，促进生产消费升级；二是优化国际市场布局；三是积极发挥多渠道促进作用；四是改善贸易自由化便利化条件。其中，在优化进口结构方面，提出了四个方向，包括：支持关系民生的产品进口、积极发展服务贸易、增加有助于转型发展的技术装备进口、增加农产品和资源性产品进口。";
    detailModel.imageUrls = @"http://pic5.photophoto.cn/20071228/0034034901778224_b.jpg,http://img4.imgtn.bdimg.com/it/u=3797629993,3212912695&fm=27&gp=0.jpg,http://pic33.photophoto.cn/20141117/0005018399944269_b.jpg,http://f8.topitme.com/8/0d/dd/1131049236b4ddd0d8o.jpg,http://pic34.photophoto.cn/20150113/0006019095934688_b.jpg,http://www.sinaimg.cn/qc/photo_auto/chezhan/2012/50/13/51/66426_src.jpg,http://pic3.16pic.com/00/07/65/16pic_765230_b.jpg,http://pic33.photophoto.cn/20141214/0005018393247763_b.jpg";

    NSArray *dataArray = [detailModel tableModelsWithType:self.fromType];
    
    /// 进入详情页面
    /// 区分 三会一课或者主题党日
    DJShowThemeAndMeetingTableViewController *vc = DJShowThemeAndMeetingTableViewController.new;
    vc.dataArray = dataArray;
    [self.navigationController pushViewController:vc animated:YES];
}

#pragma mark - config UI
- (void)configUI{
    
    UIBarButtonItem *item_create = [[UIBarButtonItem alloc] initWithTitle:@"创建" style:UIBarButtonItemStyleDone target:self action:@selector(createContent)];
    self.navigationItem.rightBarButtonItem = item_create;
    
    [self.tableView registerNib:[UINib nibWithNibName:cellID bundle:nil] forCellReuseIdentifier:cellID];
    
    NSString *title;
    switch (_listType) {
        case OnlineModelTypeThemePartyDay:
            title = @"主题党日";
            break;
        case OnlineModelTypeThreeMeetings:
            title = @"三会一课";
            break;
        default:
            break;
    }
    
    NSMutableArray *arrMu = [NSMutableArray new];
    for (NSInteger i = 0; i < 20; i++) {
        OLMindReportModel *model = [OLMindReportModel new];
        model.title = title;
        model.author = @"常小江";
        model.testTime = @"2018-01-01";
        [arrMu addObject:model];
    }
    self.dataArray = arrMu.copy;
    [self.tableView reloadData];
}


@end
