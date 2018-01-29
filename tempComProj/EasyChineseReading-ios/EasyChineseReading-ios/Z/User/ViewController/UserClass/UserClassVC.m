//
//  UClassVC.m
//  EasyChineseReading-ios
//
//  Created by 赵春阳 on 17/8/30.
//  Copyright © 2017年 lee. All rights reserved.
//

#import "UserClassVC.h"

#import "UClassTableViewCell.h"
#import "UClassHeaderCollectionViewCell.h"
#import "UClassFooterCollectionViewCell.h"
#import "EmptyView.h"

#import "UClassManagerVC.h"
#import "UClassMessageListVC.h"
#import "UCRecommendListVC.h"
#import "UCStudentVC.h"
#import "UCReadDetailVC.h"
#import "ECRBookInfoViewController.h"

static CGFloat const kHeaderCollectionHeight = 128; // 顶部操作 collection 高度
static CGFloat const kHeaderCollecionCellSpace = 0; // 操作 collectionCell 间隙

@interface UserClassVC ()<UITableViewDataSource, UITableViewDelegate, UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout>

@property (weak, nonatomic) IBOutlet UITableView      *tableView;
@property (weak, nonatomic) IBOutlet UICollectionView *headerCollectionView; // 操作
@property (weak, nonatomic) IBOutlet UICollectionView *footerCollectionView; // 推荐阅读

@property (weak, nonatomic) IBOutlet UIView *viewLine;          // headerCollection tableView 分割线
@property (weak, nonatomic) IBOutlet UIView *viewLineBottom;    // tableView 底部分割线

@property (weak, nonatomic) IBOutlet UILabel *lblDesc; // 为你推荐
@property (weak, nonatomic) IBOutlet UIView  *verLine;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *heightFooterConstraint;

@property (strong, nonatomic) UICollectionViewFlowLayout *headerLayout; // 操作布局
@property (strong, nonatomic) UICollectionViewFlowLayout *footerLayout; // 推荐布局

@property (strong, nonatomic) NSArray *arrClasses;   // 班级
@property (strong, nonatomic) NSArray *arrHandles;   // 操作
@property (strong, nonatomic) NSArray *arrTeachers;  // 教师
@property (strong, nonatomic) NSMutableArray *arrRecommend; // 推荐阅读

@property (strong, nonatomic) EmptyView *emptyView; // 没有班级

@property (assign, nonatomic) CGFloat footerCellWidth;  // 为你推荐 cell宽度
@property (assign, nonatomic) CGFloat footerCellHeight; // 为你推荐 cell高度
@property (assign, nonatomic) CGFloat footerCellSpace;  // 为你推荐 cell间距
@property (assign, nonatomic) NSInteger footerCollectionNum; // 为你推荐 cell数量

@end

@implementation UserClassVC

- (void)viewDidLoad {
    [super viewDidLoad];

    [self configClassView];
    [self configTableView];
    [self configCollectionView];
    [self getMyClasssInfo];
    [self getTeachers];
    [self getRecommendBooks];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:NO animated:YES];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

#pragma mark - 配置界面

- (void)updateSystemLanguage
{
    self.title = LOCALIZATION(@"我的班级");
    self.lblDesc.text = LOCALIZATION(@"为你推荐");
    [_tableView reloadData];
    [_headerCollectionView reloadData];
    [_footerCollectionView reloadData];
}

- (void)configTableView
{
    [self.tableView registerNib:[UINib nibWithNibName:NSStringFromClass([UClassTableViewCell class]) bundle:nil] forCellReuseIdentifier:NSStringFromClass([UClassTableViewCell class])];
    
    UIView *view = [UIView new];
    view.backgroundColor = [UIColor whiteColor];
    self.tableView.tableFooterView = view;
    self.tableView.rowHeight = UITableViewAutomaticDimension;
    self.tableView.estimatedRowHeight = 100.f;
}

- (void)configCollectionView
{
    _footerCollectionNum = isPad ? cCollectionNum_Pad : cCollectionNum_Phone;
    _footerCellSpace     = isPad ? cCollectionSpace_Pad : cCollectionSpace_Phone;
    _footerCellWidth     = (Screen_Width - (_footerCollectionNum + 1)*_footerCellSpace)/_footerCollectionNum;
    _footerCellHeight    = _footerCellWidth*cCollectionScale;
    _heightFooterConstraint.constant = _footerCellHeight + 65.f; // 65 是footerCell中封面距离底部的高度
    
    _headerCollectionView.scrollEnabled = NO;
    _footerCollectionView.scrollEnabled = NO;
    
    _headerCollectionView.showsVerticalScrollIndicator = NO;
    _footerCollectionView.showsVerticalScrollIndicator = NO;
    
    _headerCollectionView.showsHorizontalScrollIndicator = NO;
    _footerCollectionView.showsHorizontalScrollIndicator = NO;
    
    _headerCollectionView.collectionViewLayout = self.headerLayout;
    _footerCollectionView.collectionViewLayout = self.footerLayout;
    
    [_headerCollectionView registerNib:[UINib nibWithNibName:NSStringFromClass([UClassHeaderCollectionViewCell class]) bundle:nil] forCellWithReuseIdentifier:NSStringFromClass([UClassHeaderCollectionViewCell class])];
    [_footerCollectionView registerNib:[UINib nibWithNibName:NSStringFromClass([UClassFooterCollectionViewCell class]) bundle:nil] forCellWithReuseIdentifier:NSStringFromClass([UClassFooterCollectionViewCell class])];
}

- (void)configClassView
{
    _verLine.backgroundColor = [UIColor cm_mainColor];
    
    if (_arrClasses.count == 0) {
        _emptyView = [EmptyView loadFromNibWithFrame:CGRectMake(0, _tableView.y, Screen_Width, self.view.height - cHeaderHeight_64 - kHeaderCollectionHeight - _footerCollectionView.height)];
        [_emptyView updateEmptyViewWithType:ENUM_EmptyResultTypeClass Image:nil desc:[UserRequest sharedInstance].user.userType == ENUM_UserTypeTeacher ? LOCALIZATION(@"机构未分配班级") : nil subDesc:nil];
        [self.view addSubview:_emptyView];
    }

    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"icon_class_message_white"] style:UIBarButtonItemStylePlain target:self action:@selector(messageManage)];

    _viewLineBottom.backgroundColor = [UIColor cm_lineColor_D9D7D7_1];
    _viewLine.backgroundColor       = [UIColor cm_lineColor_D9D7D7_1];
    _verLine.backgroundColor        = [UIColor cm_mainColor];
    
    _lblDesc.textColor = [UIColor cm_blackColor_333333_1];
    _lblDesc.font      = [UIFont systemFontOfSize:cFontSize_16];
    
    WeakSelf(self)
    [self fk_observeNotifcation:kNotificationUpdateClasses usingBlock:^(NSNotification *note) {
        StrongSelf(self)
        self.arrClasses = [[CacheDataSource sharedInstance] loadCacheWithCacheKey:CacheKey_ClassesList];
        self.emptyView.hidden = self.arrClasses.count > 0;
        [self.tableView reloadData];
    }];
}

#pragma mark - 获取数据
// 获取的班级信息
- (void)getMyClasssInfo
{
    [self showWaitTips];
    WeakSelf(self)
    [[ClassRequest sharedInstance] getClassesWithUserType:[UserRequest sharedInstance].user.userType Completion:^(id object, ErrorModel *error) {
        StrongSelf(self)
        [self dismissTips];
        if (error) {
            [self presentFailureTips:error.message];
        }
        else {
            self.arrClasses = [ClassModel mj_objectArrayWithKeyValuesArray:object];
            [[CacheDataSource sharedInstance] setCache:self.arrClasses withCacheKey:CacheKey_ClassesList];
            self.emptyView.hidden = self.arrClasses.count > 0;
            [self.tableView reloadData];
        }
    }];
}
// 获取教师的信息
- (void)getTeachers
{
    WeakSelf(self)
    [[ClassRequest sharedInstance] getTeachersWithCompletion:^(id object, ErrorModel *error) {
        StrongSelf(self)
        if (error) {
            [self presentFailureTips:error.message];
        }
        else {
            self.arrTeachers = [UserModel mj_objectArrayWithKeyValuesArray:object];
            [[CacheDataSource sharedInstance] setCache:_arrTeachers withCacheKey:CacheKey_TeacherList];
        }
    }];
}

// 获取推荐的图书
- (void)getRecommendBooks
{
    WeakSelf(self)
    [[ClassRequest sharedInstance] getRecommedToMeCompletion:^(id object, ErrorModel *error) {
        StrongSelf(self)
        if (error) {
            [self presentFailureTips:error.message];
        }
        else {
            self.arrRecommend = [BookModel mj_objectArrayWithKeyValuesArray:object];
            if (self.arrRecommend.count > 0) {
                [self.footerCollectionView reloadData];
            }
        }
    }];
}

#pragma mark - UITableViewDataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return _arrClasses.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UClassTableViewCell *classCell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([UClassTableViewCell class])];
    classCell.data = _arrClasses[indexPath.row];
    return classCell;
}

#pragma mark - UITableViewDelegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (_arrClasses.count > 0) {
        ClassModel *classInfo = _arrClasses[indexPath.row];
        [tableView deselectRowAtIndexPath:indexPath animated:YES];
        UCReadDetailVC *readDetail = [[UCReadDetailVC alloc] init];
        readDetail.classInfo = classInfo;
        [self.navigationController pushViewController:readDetail animated:YES];
    }
}

#pragma mark - UICollectionViewDataSource

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    if ([collectionView isEqual:_headerCollectionView])
        return self.arrHandles.count;
    else
        return _arrRecommend.count >= _footerCollectionNum ? _footerCollectionNum : _arrRecommend.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    if ([collectionView isEqual:_headerCollectionView]) {
        UClassHeaderCollectionViewCell *headerCell = [collectionView dequeueReusableCellWithReuseIdentifier:NSStringFromClass([UClassHeaderCollectionViewCell class]) forIndexPath:indexPath];
        headerCell.data = _arrHandles[indexPath.row];
        return headerCell;
    }
    else {
        UClassFooterCollectionViewCell *footerCell = [collectionView dequeueReusableCellWithReuseIdentifier:NSStringFromClass([UClassFooterCollectionViewCell class]) forIndexPath:indexPath];
        footerCell.data = _arrRecommend[indexPath.row];
        return footerCell;
    }
}

#pragma mark - UICollectionViewDelegate

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    if ([collectionView isEqual:_headerCollectionView]) {
        ECRBaseViewController *VC = [[NSClassFromString(_arrHandles[indexPath.row][@"class"]) alloc] init];
        VC.data = self.arrClasses;
        [self.navigationController pushViewController:VC animated:YES];
    }
    else {
        BookModel *book = _arrRecommend[indexPath.row];
        UIStoryboard *board = [UIStoryboard storyboardWithName:@"BookInfo" bundle:nil];
        ECRBookInfoViewController *bivc = [board instantiateViewControllerWithIdentifier:@"ECRBookInfoViewController"];
        bivc.viewControllerPushWay = ECRBaseControllerPushWayPush;
        bivc.bookId = book.bookId;
        [self.navigationController pushViewController:bivc animated:YES];
    }
}

#pragma mark - 发送站内信

- (void)messageManage
{
    [self pushToViewControllerWithClassName:NSStringFromClass([UClassMessageListVC class])];
}

#pragma mark - 属性

- (NSArray *)arrHandles
{
    if (_arrHandles == nil) {
        if ([UserRequest sharedInstance].user.userType == ENUM_UserTypeOrganization) {
            _arrHandles = @[@{@"index": @"2", @"action": LOCALIZATION(@"教师管理"), @"icon": @"icon_class_manage_teacher", @"class": @"UCTeacherListVC"},
                            @{@"index": @"0", @"action": LOCALIZATION(@"班级管理"), @"icon": @"icon_class_manage_class"  , @"class": @"UClassManagerVC"},
                            @{@"index": @"1", @"action": LOCALIZATION(@"学生管理"), @"icon": @"icon_class_manage_student", @"class": @"UCStudentVC"},
                            @{@"index": @"3", @"action": LOCALIZATION(@"推荐阅读"), @"icon": @"icon_class_recommend"     , @"class": @"UCRecommendManageVC"}];
        }
        else if ([UserRequest sharedInstance].user.userType == ENUM_UserTypeTeacher) {
            _arrHandles = @[@{@"index": @"2", @"action": LOCALIZATION(@"推荐阅读"), @"icon": @"icon_class_recommend", @"class": @"UCRecommendManageVC"}];
        }
    }
    return _arrHandles;
}

- (UICollectionViewFlowLayout *)headerLayout
{
    if (_headerLayout == nil) {
        _headerLayout = [[UICollectionViewFlowLayout alloc] init];
        _headerLayout.minimumLineSpacing = kHeaderCollecionCellSpace;
        _headerLayout.minimumInteritemSpacing = kHeaderCollecionCellSpace;
        _headerLayout.sectionInset = UIEdgeInsetsZero;
        
        CGFloat itemWidth = Screen_Width / 4;
        _headerLayout.itemSize = CGSizeMake(itemWidth, kHeaderCollectionHeight);
    }
    return _headerLayout;
}

- (UICollectionViewFlowLayout *)footerLayout
{
    if (_footerLayout == nil) {
        _footerLayout = [[UICollectionViewFlowLayout alloc] init];
        _footerLayout.minimumLineSpacing      = isPad ? cCollectionSpace_Pad : cCollectionSpace_Phone;
        _footerLayout.minimumInteritemSpacing = isPad ? cCollectionSpace_Pad : cCollectionSpace_Phone;
        _footerLayout.sectionInset = UIEdgeInsetsMake(0, _footerCellSpace, 0, _footerCellSpace);
        _footerLayout.itemSize = CGSizeMake(_footerCellWidth, _heightFooterConstraint.constant);
    }
    return _footerLayout;
}

@end
