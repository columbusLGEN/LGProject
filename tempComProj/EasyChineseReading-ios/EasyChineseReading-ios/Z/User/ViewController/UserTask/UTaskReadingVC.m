//
//  UTaskReadingVC.m
//  EasyChineseReading-ios
//
//  Created by 赵春阳 on 2017/9/11.
//  Copyright © 2017年 lee. All rights reserved.
//

#import "UTaskReadingVC.h"

#import "UTaskRecommendTableViewCell.h"
#import "UTaskImpowerTableViewCell.h"

#import "UCRecommendDetailVC.h"

@interface UTaskReadingVC () <UITableViewDelegate, UITableViewDataSource>

@property (strong, nonatomic) UITableView *tableView;
/* 数据 */
@property (strong, nonatomic) NSMutableArray *arrRecommend;     // 推荐阅读
@property (strong, nonatomic) NSMutableArray *arrImpower;       // 授权阅读

@property (assign, nonatomic) NSInteger currentRecommendPage;   // 当前推荐页
@property (assign, nonatomic) NSInteger currentImpowerPage;     // 当前授权页

@property (assign, nonatomic) ENUM_RecommendType recommendType; // 任务类别

@property (strong, nonatomic) ZSegment *segment;                // 顶部选择条
@property (strong, nonatomic) EmptyView *emptyView;             // 阅读任务为空

@end

@implementation UTaskReadingVC

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self configReadingTaskView];
    [self configTableView];
    [self configEmptyView];
    [self configMJRefresh];
    [self getFirstPageRecommendTask];
    [self getFirstPageImpowerTask];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)configReadingTaskView
{
    UIView *segmentBackground = [[UIView alloc] initWithFrame:CGRectMake(0, 0, Screen_Width, cHeaderHeight_44)];
    segmentBackground.backgroundColor = [UIColor cm_grayColor__F1F1F1_1];
    [self.view addSubview:segmentBackground];
    
    UIView *line = [[UIView alloc] initWithFrame:CGRectMake(0, cHeaderHeight_44 - 1, segmentBackground.width, 1)];
    line.backgroundColor = [UIColor cm_lineColor_D9D7D7_1];
    [segmentBackground addSubview:line];
    
    _segment = [[ZSegment alloc] initWithFrame:CGRectMake(0, 0, Screen_Width*3/4, cHeaderHeight_44) leftTitle:LOCALIZATION(@"阅读任务") rightTitle:LOCALIZATION(@"已获授权") selectedColor:[UIColor cm_mainColor] sliderColor:[UIColor cm_grayColor__F1F1F1_1] verLineColor:[UIColor cm_grayColor__F1F1F1_1] diamondColor:[UIColor cm_mainColor]];
    _segment.backgroundColor = [UIColor cm_grayColor__F1F1F1_1];
    [self.view addSubview:_segment];
    
    WeakSelf(self)
    _segment.selectedLeft = ^{
        StrongSelf(self)
        self.recommendType = ENUM_RecommendTypeRecommend;
        self.emptyView.hidden = self.arrRecommend.count > 0;
        [self.tableView reloadData];
    };
    _segment.selectedRight = ^{
        StrongSelf(self)
        self.recommendType = ENUM_RecommendTypeImpower;
        self.emptyView.hidden = self.arrImpower.count > 0;
        [self.tableView reloadData];
    };
}

- (void)configTableView
{
    _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, cHeaderHeight_44, self.view.width, self.view.height - cHeaderHeight_44) style:UITableViewStylePlain];
    _tableView.delegate = self;
    _tableView.dataSource = self;
    _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    _tableView.rowHeight = UITableViewAutomaticDimension;
    _tableView.estimatedRowHeight = 100;
    
    [_tableView registerNib:[UINib nibWithNibName:NSStringFromClass([UTaskRecommendTableViewCell class]) bundle:nil] forCellReuseIdentifier:NSStringFromClass([UTaskRecommendTableViewCell class])];
    [_tableView registerNib:[UINib nibWithNibName:NSStringFromClass([UTaskImpowerTableViewCell class]) bundle:nil] forCellReuseIdentifier:NSStringFromClass([UTaskImpowerTableViewCell class])];
    [self.view addSubview:_tableView];
}

- (void)configEmptyView
{
    _emptyView = [EmptyView loadFromNibWithFrame:CGRectMake(0, cHeaderHeight_44, Screen_Width, self.view.height - cHeaderHeight_44)];
    [_emptyView updateEmptyViewWithType:ENUM_EmptyResultTypeData Image:nil desc:nil subDesc:nil];
    [self.view addSubview:_emptyView];
}

- (void)configMJRefresh
{
    WeakSelf(self)
    self.tableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        StrongSelf(self)
        _recommendType == ENUM_RecommendTypeRecommend ? [self getFirstPageRecommendTask] : [self getFirstPageImpowerTask];
    }];
    
    self.tableView.mj_footer = [MJRefreshBackFooter footerWithRefreshingBlock:^{
        StrongSelf(self)
        _recommendType == ENUM_RecommendTypeRecommend ? [self getRecommendTaskDataWithPage:_currentRecommendPage] : [self getImpowerTaskDateWithPage:_currentImpowerPage];
    }];
}

#pragma mark - 获取数据
/** 首页推荐阅读 */
- (void)getFirstPageRecommendTask
{
    _currentRecommendPage = 0;
    WeakSelf(self)
    [[TaskRequest sharedInstance] getRecommendListWithPage:_currentRecommendPage length:cListNumber_10 completion:^(id object, ErrorModel *error) {
        StrongSelf(self)
        [self.tableView.mj_header endRefreshing];
        if (error) {
            [self presentFailureTips:error.message];
        }
        else {
            self.arrRecommend = [ReadTaskModel mj_objectArrayWithKeyValuesArray:object];
            if (self.arrRecommend.count > 0) {
                self.currentRecommendPage += 1;
            }
            [self.tableView reloadData];
            self.emptyView.hidden = self.arrRecommend.count > 0;
        }
    }];
}
/** 更多推荐阅读 */
- (void)getRecommendTaskDataWithPage:(NSInteger)page
{
    WeakSelf(self)
    [[TaskRequest sharedInstance] getRecommendListWithPage:page length:cListNumber_10 completion:^(id object, ErrorModel *error) {
        StrongSelf(self)
        [self.tableView.mj_footer endRefreshing];
        if (error) {
            [self presentFailureTips:error.message];
        }
        else {
            NSArray *array = [ReadTaskModel mj_objectArrayWithKeyValuesArray:object];
            if (array.count > 0) {
                self.currentRecommendPage += 1;
                [self.arrRecommend addObjectsFromArray:array];
            }
            [self.tableView reloadData];
        }
    }];
}
/** 首页授权阅读 */
- (void)getFirstPageImpowerTask
{
    _currentImpowerPage = 0;
    WeakSelf(self)
    [[TaskRequest sharedInstance] getImpowerListWithPage:_currentImpowerPage length:cListNumber_10 completion:^(id object, ErrorModel *error) {
        StrongSelf(self)
        [self.tableView.mj_header endRefreshing];
        if (error) {
            [self presentFailureTips:error.message];
        }
        else {
            self.arrImpower = [ReadTaskModel mj_objectArrayWithKeyValuesArray:object];
            self.emptyView.hidden = self.arrImpower.count > 0;
            if (self.arrImpower.count > 0) {
                self.currentImpowerPage += 1;
            }
            [self.tableView reloadData];
        }
    }];
}
/** 更多授权阅读 */
- (void)getImpowerTaskDateWithPage:(NSInteger)page
{
    WeakSelf(self)
    [[TaskRequest sharedInstance] getImpowerListWithPage:page length:cListNumber_10 completion:^(id object, ErrorModel *error) {
        StrongSelf(self)
        [self.tableView.mj_footer endRefreshing];
        if (error) {
            [self presentFailureTips:error.message];
        }
        else {
            NSArray *array = [ReadTaskModel mj_objectArrayWithKeyValuesArray:object];
            if (array.count > 0) {
                self.currentImpowerPage += 1;
                [self.arrImpower addObjectsFromArray:array];
            }
            [self.tableView reloadData];
        }
    }];
}

#pragma mark - UITableViewDataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return _recommendType == ENUM_RecommendTypeRecommend ? _arrRecommend.count : _arrImpower.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if ( _recommendType == ENUM_RecommendTypeRecommend) {
        UTaskRecommendTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([UTaskRecommendTableViewCell class])];
        cell.data = _arrRecommend[indexPath.row];
        return cell;
    }
    else {
        UTaskImpowerTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([UTaskImpowerTableViewCell class])];
        cell.data = _arrImpower[indexPath.row];
        return cell;
    }
}

#pragma mark - UITableViewDelegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    ReadTaskModel *readTask = _recommendType == ENUM_RecommendTypeRecommend ? _arrRecommend[indexPath.row] : _arrImpower[indexPath.row];

    UCRecommendDetailVC *detailVC = [[UCRecommendDetailVC alloc] init];
    detailVC.recommendType        = _recommendType;
    detailVC.userType             = [UserRequest sharedInstance].user.userType;
    detailVC.hiddenUsers          = YES;

    RecommendModel *recommend = [RecommendModel new];
    recommend.shareBatchId    = readTask.recommendId;
    recommend.content         = readTask.content;
    recommend.createTime      = readTask.createTime;
    recommend.bookNum         = readTask.bookNum;
    detailVC.recommend        = recommend;
    
    ImpowerModel *impower = [ImpowerModel new];
    impower.grantbatchId  = readTask.grantbatchId;
    impower.content       = readTask.content;
    impower.createTime    = readTask.createTime;
    impower.bookNum       = readTask.bookNum;
    impower.endTime       = readTask.endTime;
    impower.startTime     = readTask.startTime;
    detailVC.impower      = impower;
    
    [self.navigationController pushViewController:detailVC animated:YES];
}

#pragma mark - 属性

- (NSMutableArray *)arrRecommend
{
    if (_arrRecommend == nil) {
        _arrRecommend = [NSMutableArray array];
    }
    return _arrRecommend;
}

- (NSMutableArray *)arrImpower
{
    if (_arrImpower == nil) {
        _arrImpower = [NSMutableArray array];
    }
    return _arrImpower;
}

@end
