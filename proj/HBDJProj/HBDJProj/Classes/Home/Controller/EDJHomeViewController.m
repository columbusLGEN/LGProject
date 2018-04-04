//
//  EDJHomeViewController.m
//  HBDJProj
//
//  Created by Peanut Lee on 2018/4/2.
//  Copyright © 2018年 Lee. All rights reserved.
//

#import "EDJHomeViewController.h"
#import "EDJHomeController.h"
#import "EDJHomeHeaderView.h"
#import <MJRefresh.h>

static NSString * const testCell = @"testCell";

@interface EDJHomeViewController ()<
UIPageViewControllerDelegate,
EDJHomeNavDelelgate,
UITableViewDelegate,
UITableViewDataSource
>

@property (strong,nonatomic) UITableView *tableView;
@property (weak,nonatomic) EDJHomeHeaderView *header;
@property (strong,nonatomic) EDJHomeController *homeController;
@property (strong,nonatomic) UIPageViewController *pageViewController;

@property (assign,nonatomic) NSInteger pengdinIndex;
@property (assign,nonatomic) NSInteger currentIndex;/// --> 用作切换分页

@property (strong,nonatomic) NSMutableArray *microPLArray;//

@end

@implementation EDJHomeViewController

- (void)loadView{
    [super loadView];
    [self.navigationController setNavigationBarHidden:YES animated:NO];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    _microPLArray = [NSMutableArray array];
    for (int i = 0; i < 10; i++) {
        [_microPLArray addObject:@"a"];
    }
    [self.view addSubview:self.tableView];
    [self.tableView reloadData];
    
    /// frame
    CGFloat headerHeight = [self headerHeight];
    CGRect headerFrame = CGRectMake(0, - headerHeight, kScreenWidth,headerHeight);
    
    /// header
    EDJHomeHeaderView *header = [[EDJHomeHeaderView alloc] initWithFrame:headerFrame];
    header.imgURLStrings = @[
                             @"https://goss.vcg.com/creative/vcg/800/version23/VCG21gic13374057.jpg",
                             @"http://dl.bizhi.sogou.com/images/2013/12/19/458657.jpg",
                             @"https://goss3.vcg.com/creative/vcg/800/version23/VCG21gic19568254.jpg"];
    header.nav.delegate = self;
    _header = header;
    [self.tableView addSubview:_header];
    
}

#pragma mark - data source
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return _microPLArray.count;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:testCell];
    [cell.textLabel setText:[NSString stringWithFormat:@"%@_%ld",_microPLArray[indexPath.row],indexPath.row]];
    return cell;
}


#pragma mark - nav delegate

/// MARK: lazy load
- (UITableView *)tableView{
    if (_tableView == nil) {
        _tableView = [[UITableView alloc] initWithFrame:self.view.bounds style:UITableViewStylePlain];
        _tableView.dataSource = self;
        _tableView.delegate = self;
        [_tableView setContentInset:UIEdgeInsetsMake([self headerHeight], 0, 0, 0)];
        [_tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:testCell];
    }
    return _tableView;
}

- (CGFloat)headerHeight{
    return [EDJHomeHeaderView headerHeight];
}
@end
