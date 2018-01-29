//
//  UCStudentManagerVC.m
//  EasyChineseReading-ios
//
//  Created by 赵春阳 on 17/9/2.
//  Copyright © 2017年 lee. All rights reserved.
//

#import "UCStudentVC.h"

#import "ZSlideSwitch.h"

#import "UCStudentListVC.h"
#import "UCStudentManagerVC.h"

@interface UCStudentVC () <ZSlideSwitchDelegate>

@property (strong, nonatomic) NSMutableArray *arrClasss;       // 班级数组
@property (strong, nonatomic) NSMutableArray *arrTitles;       // 标题数组
@property (strong, nonatomic) NSMutableArray *viewControllers; // 班级界面数组

/* 滚动条 */
@property (strong, nonatomic) ZSlideSwitch *slideSwitch;

@end

@implementation UCStudentVC

- (void)viewDidLoad {
    [super viewDidLoad];
    [self configStudentManageView];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - 配置界面

- (void)updateSystemLanguage
{
    self.title = LOCALIZATION(@"学生管理");
}

- (void)configStudentManageView
{
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"icon_class_add_white"] style:UIBarButtonItemStylePlain target:self action:@selector(addStudent)];
    [self configHeaderView];
}

- (void)configHeaderView
{
    // 要显示的标题
    ClassModel *classInfo = [ClassModel new];
    classInfo.classId = 0;
    classInfo.className = LOCALIZATION(@"全部");
    classInfo.teacherId = [UserRequest sharedInstance].user.userId;
    
    _arrClasss = [NSMutableArray array];
    [_arrClasss addObject:classInfo];
    NSArray *array = [[CacheDataSource sharedInstance] loadCacheWithCacheKey:CacheKey_ClassesList];
    [_arrClasss addObjectsFromArray:array];
    
    // 创建需要展示的ViewController
    _viewControllers = [[NSMutableArray alloc] init];
    for (NSInteger i = 0 ; i<_arrClasss.count; i++) {
        UCStudentListVC *studentList = [UCStudentListVC new];
        [_viewControllers addObject:studentList];
    }
    // 班级名
    _arrTitles = [NSMutableArray array];
    for (NSInteger i = 0; i < _arrClasss.count; i ++) {
        ClassModel *classInfo = _arrClasss[i];
        [_arrTitles addObject:classInfo.className];
    }
    
    [self configSlideSwitchWithTitles:_arrTitles viewControllers:_viewControllers];
}

/**
 顶部班级选择条

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
    _slideSwitch.normalColor = [UIColor cm_blackColor_333333_1];
    //显示方法
    [_slideSwitch showInViewController:self];
    
    UIView *headerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 80, cHeaderHeight_44)];
    headerView.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:headerView];
    
    UIView *verLine = [[UIView alloc] initWithFrame:CGRectMake(15, 15, 3, 15)];
    verLine.backgroundColor = [UIColor cm_mainColor];
    [headerView addSubview:verLine];
    
    UILabel *lblClass = [[UILabel alloc] initWithFrame:CGRectMake(30, 10, 50, 22)];
    lblClass.text = [NSString stringWithFormat:@"%@: ", LOCALIZATION(@"班级")];
    lblClass.textColor = [UIColor cm_blackColor_333333_1];
    lblClass.font = [UIFont systemFontOfSize:15.f];
    [headerView addSubview:lblClass];
}

#pragma mark - 添加学生
- (void)addStudent
{
    NSArray *array = [[CacheDataSource sharedInstance] loadCacheWithCacheKey:CacheKey_ClassesList];
    if (array.count > 0) {
        UCStudentManagerVC *addVC = [UCStudentManagerVC loadFromStoryBoard:@"UserClass"];
        [self.navigationController pushViewController:addVC animated:YES];
    }
    else {
        [self presentFailureTips:LOCALIZATION(@"还没有班级啊")];
    }
}

#pragma mark - 选择班级
- (void)slideSwitchDidselectAtIndex:(NSInteger)index
{
    ClassModel *classInfo = _arrClasss[index];
    WeakSelf(self)
    [[ClassRequest sharedInstance] getStudentsWithClassId:[NSString stringWithFormat:@"%ld", classInfo.classId] completion:^(id object, ErrorModel *error) {
        if (error) {
            [weakself presentFailureTips:error.message];
        }
        else {
            // 获取学生数据 刷新界面
            UCStudentListVC *studentList = weakself.viewControllers[index];
            studentList.classId = classInfo.classId;
            studentList.arrDataSource = [UserModel mj_objectArrayWithKeyValuesArray:object];
            [studentList.tableView reloadData];
            studentList.emptyView.hidden = studentList.arrDataSource.count > 0;
        }
    }];
}

@end
