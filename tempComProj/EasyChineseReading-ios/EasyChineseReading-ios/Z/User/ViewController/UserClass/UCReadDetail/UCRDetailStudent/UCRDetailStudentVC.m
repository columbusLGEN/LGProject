//
//  UCRDetailStudentVC.m
//  EasyChineseReading-ios
//
//  Created by 赵春阳 on 17/9/2.
//  Copyright © 2017年 lee. All rights reserved.
//

#import "UCRDetailStudentVC.h"

#import "UCRDetailStudentHeaderView.h"
#import "UCRDetailStudentTableViewCell.h"

static CGFloat kHeaderViewHeight = 300.f;

@interface UCRDetailStudentVC () <UITableViewDelegate, UITableViewDataSource>

@property (strong, nonatomic) UITableView *tableView;
@property (strong, nonatomic) UCRDetailStudentHeaderView *headerView;

@end

@implementation UCRDetailStudentVC

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = LOCALIZATION(@"阅读情况");

    [self configHeaderView];
    [self configTableView];
    [self getReadDetail];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - 配置界面

- (void)configHeaderView
{
    _headerView = [UCRDetailStudentHeaderView loadFromNibWithFrame:CGRectMake(0, 0, Screen_Width, kHeaderViewHeight)];
    [self.view addSubview:_headerView];
}

- (void)configTableView
{
    _tableView =[[UITableView alloc] initWithFrame:CGRectMake(0, kHeaderViewHeight - 64, Screen_Width, self.view.height - kHeaderViewHeight - cHeaderHeight_44) style:UITableViewStylePlain];
    _tableView.delegate = self;
    _tableView.dataSource = self;
    _tableView.showsVerticalScrollIndicator = NO;
    _tableView.rowHeight = UITableViewAutomaticDimension;
    _tableView.estimatedRowHeight = 100;
    
    UIView *footer = [UIView new];
    footer.backgroundColor = [UIColor whiteColor];
    _tableView.tableFooterView = footer;
    
    [self.view addSubview:_tableView];
    
    [_tableView registerNib:[UINib nibWithNibName:NSStringFromClass([UCRDetailStudentTableViewCell class]) bundle:nil] forCellReuseIdentifier:NSStringFromClass([UCRDetailStudentTableViewCell class])];
}

#pragma mark - 获取学生阅读详情

- (void)getReadDetail
{
    [self showWaitTips];
    WeakSelf(self)
    [[ClassRequest sharedInstance] getReadingProgressWithStudentId:_student.userId completion:^(id object, ErrorModel *error) {
        StrongSelf(self)
        [self dismissTips];
        if (error) {
            [self presentFailureTips:error.message];
        }
        else {
            NSArray *arr = [NSDictionary mj_objectArrayWithKeyValuesArray:object];
            if (arr.count > 0) {
                NSArray *array = @[arr.firstObject[@"readHistory"]];
                self.student.readHistory = array;
                self.student.historyBook = arr.firstObject[@"historyBook"];
                self.headerView.data = self.student;
            }
            [self.tableView reloadData];
        }
    }];
}

#pragma mark - UITableViewDataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return _student.historyBook.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UCRDetailStudentTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([UCRDetailStudentTableViewCell class])];
    cell.data = _student.historyBook[indexPath.row];
    return cell;
}

@end
