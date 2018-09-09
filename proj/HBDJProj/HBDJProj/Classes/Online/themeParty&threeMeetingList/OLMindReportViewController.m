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

    NSArray *dataArray = [model tableModelsWithType:0];
    
    /// 进入详情页面
    DJShowThemeAndMeetingTableViewController *vc = DJShowThemeAndMeetingTableViewController.new;
    vc.tmOrTd = 3;
    vc.dataArray = dataArray;
    vc.title = model.title;
    [self.navigationController pushViewController:vc animated:YES];
}

#pragma mark - config UI
- (void)configUI{
    self.title = @"主题党日";
    if (DJUser.sharedInstance.ismanager) {
        UIBarButtonItem *item_create = [[UIBarButtonItem alloc] initWithTitle:@"创建" style:UIBarButtonItemStyleDone target:self action:@selector(createContent)];
        self.navigationItem.rightBarButtonItem = item_create;
    }
    
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
