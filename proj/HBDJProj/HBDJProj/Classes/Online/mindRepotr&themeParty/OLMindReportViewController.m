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

#import "DJUploadThemePartyDayTableViewController.h"

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
