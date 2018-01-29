//
//  UCRecommendDetailVC.m
//  EasyChineseReading-ios
//
//  Created by 赵春阳 on 2017/9/14.
//  Copyright © 2017年 lee. All rights reserved.
//

#import "UCRecommendDetailVC.h"

#import "UCRecommendDetailStudentTableViewCell.h"
#import "UCRecommendDetailDescribeTableViewCell.h"
#import "UCRecommendDetailBooksTableViewCell.h"
#import "UCRecommendDescTableViewCell.h"
#import "UCImpowerDetailDescribeTableViewCell.h"

#import "ECRBookInfoViewController.h"

#define kRDStudentCell  NSStringFromClass([UCRecommendDetailStudentTableViewCell class])
#define kRDDescribeCell NSStringFromClass([UCRecommendDetailDescribeTableViewCell class])
#define kRDBooksCell    NSStringFromClass([UCRecommendDetailBooksTableViewCell class])
#define kRDDescCell     NSStringFromClass([UCRecommendDescTableViewCell class])
#define kIDDescribeCell NSStringFromClass([UCImpowerDetailDescribeTableViewCell class])

@interface UCRecommendDetailVC () <UITableViewDelegate, UITableViewDataSource>

@property (strong, nonatomic) UITableView *tableView;

@property (strong, nonatomic) NSArray *arrBooks; // 图书数组
@property (strong, nonatomic) NSArray *arrUsers; // 用户数组

@end

@implementation UCRecommendDetailVC

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self configRecommendDetailView];
    
    // 根据类型获取数据
    _recommendType == ENUM_RecommendTypeRecommend ? [self getRecommendDetail] : [self getImpowerDetail];
}

#pragma mark - 配置界面

- (void)updateSystemLanguage
{
    self.title = _recommendType == ENUM_RecommendTypeRecommend ? LOCALIZATION(@"推荐阅读") : LOCALIZATION(@"授权阅读");
    if (_recommendType == ENUM_RecommendTypeImpower && !_hiddenUsers) {
        self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:LOCALIZATION(@"取消授权") style:UIBarButtonItemStylePlain target:self action:@selector(cancelImpowerHandle)];
    }
}

- (void)configRecommendDetailView
{
    _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, Screen_Width, Screen_Height - cHeaderHeight_64) style:UITableViewStylePlain];
    _tableView.delegate = self;
    _tableView.dataSource = self;
    _tableView.rowHeight = UITableViewAutomaticDimension;
    _tableView.estimatedRowHeight = 100;
    _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    
    UIView *footer = [UIView new];
    footer.backgroundColor = [UIColor whiteColor];
    _tableView.tableFooterView = footer;
    
    [self.view addSubview:_tableView];
    
    [_tableView registerNib:[UINib nibWithNibName:kRDDescribeCell bundle:nil] forCellReuseIdentifier:kRDDescribeCell];
    [_tableView registerNib:[UINib nibWithNibName:kRDStudentCell  bundle:nil] forCellReuseIdentifier:kRDStudentCell];
    [_tableView registerNib:[UINib nibWithNibName:kRDDescCell     bundle:nil] forCellReuseIdentifier:kRDDescCell];
    [_tableView registerNib:[UINib nibWithNibName:kRDBooksCell    bundle:nil] forCellReuseIdentifier:kRDBooksCell];
    [_tableView registerNib:[UINib nibWithNibName:kIDDescribeCell bundle:nil] forCellReuseIdentifier:kIDDescribeCell];
}

/** 取消授权 */
- (void)cancelImpowerHandle
{
    [self showWaitTips];
    WeakSelf(self)
    NSInteger type = [UserRequest sharedInstance].user.userType == ENUM_UserTypeTeacher ? 1 : 0;
    [[ClassRequest sharedInstance] cancelImpowerWithGrantBatchId:_impower.grantbatchId type:type completion:^(id object, ErrorModel *error) {
        StrongSelf(self)
        [self dismissTips];
        if (error) {
            [self presentFailureTips:error.message];
        }
        else {
            [self presentSuccessTips:LOCALIZATION(@"取消授权成功")];
            self.cancelImpower(_impower);
            [self.navigationController popViewControllerAnimated:YES];
        }
    }];
}

#pragma mark - 获取数据

/** 获取推荐详情 */
- (void)getRecommendDetail
{
    [self showWaitTips];
    WeakSelf(self)
    [[ClassRequest sharedInstance] getRecommendDetailWithShareBatchId:_recommend.shareBatchId completion:^(id object, ErrorModel *error) {
        StrongSelf(self)
        [self dismissTips];
        if (error) {
            [self presentFailureTips:error.message];
        }
        else {
            NSArray *array = [NSDictionary mj_objectArrayWithKeyValuesArray:object];
            self.arrBooks = [BookModel mj_objectArrayWithKeyValuesArray:array.firstObject[@"books"]];
            self.arrUsers = [UserModel mj_objectArrayWithKeyValuesArray:array.firstObject[@"users"]];
            [self.tableView reloadData];
        }
    }];
}

/** 获取授权详情 */
- (void)getImpowerDetail
{
    [self showWaitTips];
    WeakSelf(self)
    [[ClassRequest sharedInstance] getImpowerDetailWithGrantBatchId:_impower.grantbatchId completion:^(id object, ErrorModel *error) {
        StrongSelf(self)
        [self dismissTips];
        if (error) {
            [self presentFailureTips:error.message];
        }
        else {
            NSArray *array = [NSDictionary mj_objectArrayWithKeyValuesArray:object];
            self.arrBooks = [BookModel mj_objectArrayWithKeyValuesArray:array.firstObject[@"books"]];
            self.arrUsers = [UserModel mj_objectArrayWithKeyValuesArray:array.firstObject[@"users"]];
            [self.tableView reloadData];
        }
    }];
}

#pragma mark - UITableViewDataSource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return _hiddenUsers ? 2 : 4;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (0 == section || 2 == section) {
        return 1;
    }
    else if (1 == section) {
        return self.arrBooks.count;
    }
    else {
        return self.arrUsers.count + 1;
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (0 == indexPath.section) {
        if (_recommendType == ENUM_RecommendTypeRecommend) {
            UCRecommendDetailDescribeTableViewCell *descCell = [tableView dequeueReusableCellWithIdentifier:kRDDescribeCell];
            descCell.data = _recommend;
            return descCell;
        }
        else {
            UCImpowerDetailDescribeTableViewCell *descCell = [tableView dequeueReusableCellWithIdentifier:kIDDescribeCell];
            descCell.data = _impower;
            return descCell;
        }
    }
    else if (1 == indexPath.section) {
        UCRecommendDetailBooksTableViewCell *bookCell = [tableView dequeueReusableCellWithIdentifier:kRDBooksCell];
        bookCell.data = _arrBooks[indexPath.row];
        return bookCell;
    }
    else if (2 == indexPath.section) {
        UCRecommendDescTableViewCell *descCell = [tableView dequeueReusableCellWithIdentifier:kRDDescCell];
        return descCell;
    }
    else {
        UCRecommendDetailStudentTableViewCell *userCell = [tableView dequeueReusableCellWithIdentifier:kRDStudentCell];
        userCell.lblNumber.text = [NSString stringWithFormat:@"%02ld", indexPath.row];
        userCell.data = indexPath.row == 0 ? @"header" : _arrUsers[indexPath.row - 1];
        return userCell;
    }
}

#pragma mark - UITableViewDelegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (1 == indexPath.section) {
        BookModel *book = _arrBooks[indexPath.row];
        UIStoryboard *board = [UIStoryboard storyboardWithName:@"BookInfo" bundle:nil];
        ECRBookInfoViewController *bivc = [board instantiateViewControllerWithIdentifier:@"ECRBookInfoViewController"];
        bivc.viewControllerPushWay = ECRBaseControllerPushWayPush;
        bivc.bookId = book.bookId;
        [self.navigationController pushViewController:bivc animated:YES];
    }
}

#pragma mark - 属性

- (NSArray *)arrBooks
{
    if (_arrBooks == nil) {
        _arrBooks = [NSArray array];
    }
    return _arrBooks;
}

@end
