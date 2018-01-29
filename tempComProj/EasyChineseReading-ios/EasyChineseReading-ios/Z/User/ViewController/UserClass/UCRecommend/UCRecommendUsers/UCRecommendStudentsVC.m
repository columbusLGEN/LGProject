//
//  UCRecommendStudentsVC.m
//  EasyChineseReading-ios
//
//  Created by 赵春阳 on 2017/9/14.
//  Copyright © 2017年 lee. All rights reserved.
//

#import "UCRecommendStudentsVC.h"

#import "UCRStudentsShopCarView.h"
#import "ZSlideSwitch.h"

#import "UCRecommendDescribeVC.h"
#import "UCRecommendStudentListVC.h"

@interface UCRecommendStudentsVC () <UCRStudentsShopCarViewDelegate, ZSlideSwitchDelegate>

@property (strong, nonatomic) ZSlideSwitch *slideSwitch;

@property (strong, nonatomic) UCRStudentsShopCarView *shopCarView;  // 购物车

@property (strong, nonatomic) NSArray *arrClasss; // 班级
@property (strong, nonatomic) NSMutableArray *arrSelectedStudent;   // 选择的学生
@property (strong, nonatomic) NSMutableArray *arrViewControllers;   // 控制器

@end

@implementation UCRecommendStudentsVC

- (void)viewDidLoad {
    [super viewDidLoad];
    [self configStudentManageView];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

#pragma mark - 配置界面

- (void)updateSystemLanguage
{
    self.title = LOCALIZATION(@"推荐阅读");
}

- (void)configStudentManageView
{
    _arrClasss = [[CacheDataSource sharedInstance] loadCacheWithCacheKey:CacheKey_ClassesList];
    
    [self configHeaderView];
    [self configShopCarView];
}

- (void)configHeaderView
{
    // 要显示的标题
    _arrViewControllers = [NSMutableArray array];
    // 初始化选择的学生
    _arrSelectedStudent = [NSMutableArray array];
    // 创建需要展示的ViewController
    NSMutableArray *arrTitles = [NSMutableArray array];
    // 循环班级数组, 获取列表与标题
    for (NSInteger i = 0 ; i < _arrClasss.count; i++) {
        ClassModel *classInfo = _arrClasss[i];
        [arrTitles addObject:classInfo.className];
        
        UCRecommendStudentListVC *studentList = [UCRecommendStudentListVC new];
        studentList.arrSelectedStudent = self.arrSelectedStudent;
        [_arrViewControllers addObject:studentList];
        studentList.reloadBlock = ^() {
            [self updateRecommendStudentView];
        };
    }
    
    if (arrTitles.count > 0 && _arrViewControllers.count > 0) {
        [self configSlideSwitchWithTitles:arrTitles viewControllers:_arrViewControllers];
    }
}

/**
 推荐顶部班级选择条

 @param titles 班级名
 @param viewControllers 班级对应的学生列表控制器
 */
- (void)configSlideSwitchWithTitles:(NSArray *)titles viewControllers:(NSArray *)viewControllers
{
    //创建滚动视图
    _slideSwitch = [[ZSlideSwitch alloc] initWithFrame:CGRectMake(0, 0, Screen_Width, self.view.height - cHeaderHeight_44) titles:titles viewControllers:viewControllers canScroll:YES needCenter:NO];
    //设置代理
    _slideSwitch.delegate = self;
    //设置按钮选中和未选中状态的标题颜色
    _slideSwitch.selectedColor = [UIColor cm_mainColor];
    _slideSwitch.normalColor   = [UIColor cm_blackColor_333333_1];
    //显示方法
    [_slideSwitch showInViewController:self];
    
    UIView *headerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 80, cHeaderHeight_44)];
    headerView.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:headerView];
    
    UIView *verLine = [[UIView alloc] initWithFrame:CGRectMake(15, 15, 3, 15)];
    verLine.backgroundColor = [UIColor cm_mainColor];
    [headerView addSubview:verLine];
    
    UILabel *lblClass = [[UILabel alloc] initWithFrame:CGRectMake(30, 10, 50, 22)];
    lblClass.text = [NSString stringWithFormat:@"%@: ",LOCALIZATION(@"班级")];
    lblClass.textColor = [UIColor cm_blackColor_333333_1];
    lblClass.font = [UIFont systemFontOfSize:15.f];
    [headerView addSubview:lblClass];
}

/** 配置购物车 */
- (void)configShopCarView
{
    CGFloat shopCarY = [IPhoneVersion deviceVersion] == iphoneX ? Screen_Height - cHeaderHeight_54 - cFooterHeight_83 : Screen_Height - cHeaderHeight_54 - cHeaderHeight_64;
    _shopCarView = [[UCRStudentsShopCarView alloc] initWithFrame:CGRectMake(0, shopCarY, CGRectGetWidth(self.view.bounds), cHeaderHeight_54) inView:self.view];
    _shopCarView.delegate = self;
    [self.view addSubview:_shopCarView];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(updateWithNotification:) name:kNotificationRemoveSelectedStudent object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(removeAllStudents) name:kNotificationRemoveAllStudents object:nil];
}

#pragma mark - 选择班级
- (void)slideSwitchDidselectAtIndex:(NSInteger)index {
    ClassModel *classInfo = _arrClasss[index];
    // 获取学生数据 刷新界面
    UCRecommendStudentListVC *studentList = _arrViewControllers[index];
    studentList.classId = classInfo.classId;
}

#pragma mark - 通知方法

/** 删除选中的学生 */
- (void)updateWithNotification:(NSNotification *)notification
{
    UserModel *user = notification.object;
    user.isSelected = NO;

    if ([_arrSelectedStudent containsObject:user]) {
        [_arrSelectedStudent removeObject:user];
    }
    
    [self fk_postNotification:kNotificationRemoveSelectedStudent_2 object:notification.object];
    [self updateRecommendStudentView];
}

/** 删除全部选中的学生 */
- (void)removeAllStudents
{
//    [_arrSelectedStudent removeAllObjects];
//    [self updateRecommendStudentView];
//
    for (NSInteger i = 0; i < _arrSelectedStudent.count; i ++) {
        UserModel *user = _arrSelectedStudent[i];
        user.isSelected = NO;
    }
    [_arrSelectedStudent removeAllObjects];

    [self fk_postNotification:kNotificationRemoveAllStudents_2];
    [self updateRecommendStudentView];
}

#pragma mark - 下一步

- (void)nextStep
{
    UCRecommendDescribeVC *recommendDescribeVC = [[UCRecommendDescribeVC alloc] init];
    recommendDescribeVC.arrBooks = _arrBooks;
    recommendDescribeVC.arrUsers = _arrSelectedStudent;
    [self.navigationController pushViewController:recommendDescribeVC animated:YES];
}

#pragma mark - 设置购物车动画

- (void)animationDidFinish
{
    [UIView animateWithDuration:0.1 animations:^{
        _shopCarView.btnShowSelectedStudents.transform = CGAffineTransformMakeScale(0.8, 0.8);
    } completion:^(BOOL finished) {
        [UIView animateWithDuration:0.1 animations:^{
            _shopCarView.btnShowSelectedStudents.transform = CGAffineTransformMakeScale(1, 1);
        } completion:^(BOOL finished) {
            
        }];
    }];
}

#pragma mark - 更新购物车

- (void)updateRecommendStudentView {
    
    _shopCarView.studentSelectedView.objects = _arrSelectedStudent;
    //设置高度。
    [_shopCarView updateFrame:_shopCarView.studentSelectedView];
    [_shopCarView.studentSelectedView.tableView reloadData];
    //设置选中的数量
    [_shopCarView setSelectedBooksNumber:_arrSelectedStudent.count];
    //重新设置数据源
    UCRecommendStudentListVC *studentList = _arrViewControllers[self.slideSwitch.selectedIndex];
    [studentList.tableView reloadData];
}

@end
