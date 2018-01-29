//
//  UCImpowerManagerVC.m
//  EasyChineseReading-ios
//
//  Created by 赵春阳 on 2017/10/12.
//  Copyright © 2017年 retech. All rights reserved.
//

#import "UCImpowerManagerVC.h"

#import "ZSlideSwitch.h"
#import "UCRStudentsShopCarView.h"

#import "UCImpowerTeacherVC.h"
#import "UCImpowerStudentVC.h"
#import "UCImpowerDescribeVC.h"

#import "UClassMessageVC.h"

@interface UCImpowerManagerVC () <ZSlideSwitchDelegate, UCRStudentsShopCarViewDelegate>

@property (strong, nonatomic) UCRStudentsShopCarView *shopCarView;  // 购物车
@property (strong, nonatomic) ZSlideSwitch *slideSwitch;
@property (strong, nonatomic) UCImpowerTeacherVC *teacherList; // 教师

@property (strong, nonatomic) UIButton *btnL;
@property (strong, nonatomic) UIButton *btnR;

@property (strong, nonatomic) UIView *viewClass; // 班级

@property (strong, nonatomic) NSArray *arrTeachers;                 // 教师
@property (strong, nonatomic) NSMutableArray *arrClasses;           // 班级
@property (strong, nonatomic) NSMutableArray *arrSelectedStudent;   // 选择的学生
@property (strong, nonatomic) NSMutableArray *arrSelectedTeacher;   // 选择的教师
@property (strong, nonatomic) NSMutableArray *arrViewControllers;   // 控制器

@property (assign, nonatomic) ENUM_UserType selectedType; // 选择授权的人物的类型

@end

@implementation UCImpowerManagerVC

- (void)viewDidLoad {
    [super viewDidLoad];
    
    _arrTeachers = [[CacheDataSource sharedInstance] loadCacheWithCacheKey:CacheKey_TeacherList];
    _arrClasses  = [[CacheDataSource sharedInstance] loadCacheWithCacheKey:CacheKey_ClassesList];
    
    if ([UserRequest sharedInstance].user.userType == ENUM_UserTypeOrganization) {
        [self configImpowerHeader];
    }
    else {
        _selectedType = ENUM_UserTypeStudent;
        [self configStudentView];
    }
    [self configShopCarView];
}

#pragma mark 配置授权人员

- (void)updateSystemLanguage
{
    self.title = _toMessage ? LOCALIZATION(@"站内信") : LOCALIZATION(@"授权阅读");
    self.view.backgroundColor = [UIColor whiteColor];
}

- (void)configImpowerHeader
{
    UIView *topView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, Screen_Width, cHeaderHeight_54)];
    topView.backgroundColor = [UIColor whiteColor];
    
    _btnL = [[UIButton alloc] initWithFrame:CGRectMake(15, 10, 80, cHeaderHeight_54 - 2*10)];
    [_btnL setTitle:LOCALIZATION(@"教师") forState:UIControlStateNormal];
    [_btnL setTitleColor:[UIColor cm_blackColor_333333_1] forState:UIControlStateNormal];
    [_btnL setTitleColor:[UIColor cm_mainColor] forState:UIControlStateSelected];
    [_btnL setBackgroundColor:[UIColor whiteColor]];
    [_btnL addTarget:self action:@selector(selectedTeacher) forControlEvents:UIControlEventTouchUpInside];
    [_btnL setSelected:YES];
    
    _btnR = [[UIButton alloc] initWithFrame:CGRectMake(15*2 + 80, 10, 80, cHeaderHeight_54 - 2*10)];
    [_btnR setTitle:LOCALIZATION(@"学生") forState:UIControlStateNormal];
    [_btnR setTitleColor:[UIColor cm_blackColor_333333_1] forState:UIControlStateNormal];
    [_btnR setTitleColor:[UIColor cm_mainColor] forState:UIControlStateSelected];
    [_btnR setBackgroundColor:[UIColor whiteColor]];
    [_btnR addTarget:self action:@selector(selecteStudent) forControlEvents:UIControlEventTouchUpInside];
    
    _btnL.layer.borderColor   = [UIColor cm_mainColor].CGColor;
    _btnL.layer.borderWidth   = 1.f;
    _btnL.layer.cornerRadius  = _btnL.height/2;
    _btnL.layer.masksToBounds = YES;
    
    _btnR.layer.borderColor   = [UIColor cm_lineColor_D9D7D7_1].CGColor;
    _btnR.layer.borderWidth   = 1.f;
    _btnR.layer.cornerRadius  = _btnR.height/2;
    _btnR.layer.masksToBounds = YES;
    
    [topView addSubview:_btnL];
    [topView addSubview:_btnR];
    
    [self.view addSubview:topView];
    
    [self configStudentView];
    [self configTeacherView];
    
    _selectedType = ENUM_UserTypeTeacher;
}

#pragma mark - 配置购物车

- (void)configShopCarView
{
    CGFloat shopCarY = [IPhoneVersion deviceVersion] == iphoneX ? Screen_Height - cHeaderHeight_54 - cFooterHeight_83 : Screen_Height - cHeaderHeight_54 - cHeaderHeight_64;
    _shopCarView  = [[UCRStudentsShopCarView alloc] initWithFrame:CGRectMake(0, shopCarY, CGRectGetWidth(self.view.bounds), cHeaderHeight_54) inView:self.view];
    _shopCarView.delegate = self;
    [self.view addSubview:_shopCarView];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(updateWithNotification:) name:kNotificationRemoveSelectedStudent object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(updateWithNotification:) name:kNotificationRemoveSelectedTeacher object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(removeAllStudents)       name:kNotificationRemoveAllStudents     object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(removeAllStudents)       name:kNotificationRemoveAllTeachers     object:nil];
}

#pragma mark - 选择学生或教师

- (void)selectedTeacher
{
    [_btnL setSelected:YES];
    [_btnR setSelected:NO];
    
    _btnL.layer.borderColor = [UIColor cm_mainColor].CGColor;
    _btnR.layer.borderColor = [UIColor cm_lineColor_D9D7D7_1].CGColor;
    
    _selectedType = ENUM_UserTypeTeacher;
    [self updateRecommendStudentView];
    [self.view bringSubviewToFront:_teacherList.view];
    [self.view bringSubviewToFront:_shopCarView];
}

- (void)selecteStudent
{
    [_btnL setSelected:NO];
    [_btnR setSelected:YES];
    
    _btnL.layer.borderColor = [UIColor cm_lineColor_D9D7D7_1].CGColor;
    _btnR.layer.borderColor = [UIColor cm_mainColor].CGColor;
    
    _selectedType = ENUM_UserTypeStudent;
    [self updateRecommendStudentView];

    [self.view bringSubviewToFront:_slideSwitch];
    [self.view bringSubviewToFront:_viewClass];
    [self.view bringSubviewToFront:_shopCarView];
}

#pragma mark - 配置学生教师列表

- (void)configTeacherView {
    
    _teacherList = [UCImpowerTeacherVC new];
    _teacherList.arrDataSource = _arrTeachers;
    _teacherList.view.frame = CGRectMake(0, cHeaderHeight_54, Screen_Width, self.view.height - cHeaderHeight_54);
    
    WeakSelf(self)
    _teacherList.reloadTeacherBlock = ^(NSArray *arrTeacher){
        [weakself.arrSelectedTeacher removeAllObjects];
        [weakself.arrSelectedTeacher addObjectsFromArray:arrTeacher];
        [weakself updateRecommendStudentView];
    };

    [self addChildViewController:_teacherList];
    [self.view addSubview:_teacherList.view];
}

- (void)configStudentView {
    // 要显示的标题
    _arrViewControllers = [NSMutableArray array];
    _arrSelectedTeacher = [NSMutableArray array];
    // 初始化选择的学生
    _arrSelectedStudent = [NSMutableArray array];
    // 创建需要展示的ViewController
    NSMutableArray *arrTitles = [NSMutableArray array];
    
    for (NSInteger i = 0; i < _arrClasses.count; i ++) {
        ClassModel *classInfo = _arrClasses[i];
        [arrTitles addObject:classInfo.className];
        
        UCImpowerStudentVC *studentList = [UCImpowerStudentVC new];
        studentList.arrSelectedStudent = self.arrSelectedStudent;
        [_arrViewControllers addObject:studentList];
        WeakSelf(self)
        studentList.reloadStudentBlock = ^{
            [weakself updateRecommendStudentView];
        };
    }
    if (arrTitles.count > 0 && _arrViewControllers.count > 0) {
        [self configSlideSwitchWithTitles:arrTitles viewControllers:_arrViewControllers];
    }
}

/**
 选中了学生, 顶部班级选择条

 @param titles 班级名
 @param viewControllers 班级对应的学生列表控制器
 */
- (void)configSlideSwitchWithTitles:(NSArray *)titles viewControllers:(NSArray *)viewControllers
{
    BOOL isOrganization = [UserRequest sharedInstance].user.userType == ENUM_UserTypeOrganization;

    //创建滚动视图
    _slideSwitch = [[ZSlideSwitch alloc] initWithFrame:CGRectMake(0, isOrganization ? cHeaderHeight_54 : 0, Screen_Width, self.view.height - cHeaderHeight_44 - (isOrganization ? cHeaderHeight_54 : 0)) titles:titles viewControllers:viewControllers canScroll:YES needCenter:NO];
    //设置代理
    _slideSwitch.delegate = self;
    //设置按钮选中和未选中状态的标题颜色
    _slideSwitch.selectedColor = [UIColor cm_mainColor];
    _slideSwitch.normalColor = [UIColor cm_blackColor_333333_1];
    //显示方法
    [_slideSwitch showInViewController:self];
    
    _viewClass = [[UIView alloc] initWithFrame:CGRectMake(0, isOrganization ? cHeaderHeight_54 : 0, 80, cHeaderHeight_44)];
    _viewClass.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:_viewClass];
    
    UIView *verLine = [[UIView alloc] initWithFrame:CGRectMake(15, 15, 3, 15)];
    verLine.backgroundColor = [UIColor cm_mainColor];
    [_viewClass addSubview:verLine];
    
    UILabel *lblClass = [[UILabel alloc] initWithFrame:CGRectMake(30, 10, 50, 22)];
    lblClass.text = [NSString stringWithFormat:@"%@: ", LOCALIZATION(@"班级")];
    lblClass.textColor = [UIColor cm_blackColor_333333_1];
    lblClass.font = [UIFont systemFontOfSize:15.f];
    [_viewClass addSubview:lblClass];
}

#pragma mark - 通知方法

/** 删除选中的 */
- (void)updateWithNotification:(NSNotification *)notification
{
    UserModel *user = notification.object;
    user.isSelected = NO;
    if (_selectedType == ENUM_UserTypeTeacher) {
        if ([_arrSelectedTeacher containsObject:user]) {
            [_arrSelectedTeacher removeObject:user];
        }
        [self fk_postNotification:kNotificationRemoveSelectedTeacher_2 object:notification.object];
    }
    else {
        if ([_arrSelectedStudent containsObject:user]) {
            [_arrSelectedStudent removeObject:user];
        }
        [self fk_postNotification:kNotificationRemoveSelectedStudent_2 object:notification.object];
    }
    [self updateRecommendStudentView];
}

/** 删除全部选中的 */
- (void)removeAllStudents
{
    if (_selectedType == ENUM_UserTypeTeacher) {
        for (NSInteger i = 0; i < _arrSelectedTeacher.count; i ++) {
            UserModel *user = _arrSelectedTeacher[i];
            user.isSelected = NO;
        }
        [_arrSelectedTeacher removeAllObjects];
        [self fk_postNotification:kNotificationRemoveAllTeachers_2];
    }
    else {
        for (NSInteger i = 0; i < _arrSelectedStudent.count; i ++) {
            UserModel *user = _arrSelectedStudent[i];
            user.isSelected = NO;
        }
        [_arrSelectedStudent removeAllObjects];
        [self fk_postNotification:kNotificationRemoveAllStudents_2];
    }
    [self updateRecommendStudentView];
}

#pragma mark - 下一步

- (void)nextStep
{
    if (_toMessage) {
        UClassMessageVC *message = [UClassMessageVC new];
        message.arrUsers = _selectedType == ENUM_UserTypeTeacher ? _arrSelectedTeacher : _arrSelectedStudent;
        [self.navigationController pushViewController:message animated:YES];
    }
    else {
        UCImpowerDescribeVC *impowerDescVC = [[UCImpowerDescribeVC alloc] init];
        impowerDescVC.arrBooks = _arrBooks;
        impowerDescVC.arrUsers = _selectedType == ENUM_UserTypeTeacher ? _arrSelectedTeacher : _arrSelectedStudent;
        [self.navigationController pushViewController:impowerDescVC animated:YES];
    }
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

#pragma mark - 更新选中界面

- (void)updateRecommendStudentView {
    if (_selectedType == ENUM_UserTypeTeacher) {
        _shopCarView.studentSelectedView.objects = _arrSelectedTeacher;
        _shopCarView.userType = ENUM_UserTypeTeacher;
        //设置高度。
        [_shopCarView updateFrame:_shopCarView.studentSelectedView];
        [_shopCarView.studentSelectedView.tableView reloadData];
        //设置选中的数量
        [_shopCarView setSelectedBooksNumber:_arrSelectedTeacher.count];
    }
    else if (_selectedType == ENUM_UserTypeStudent){
        _shopCarView.studentSelectedView.objects = _arrSelectedStudent;
        _shopCarView.userType = ENUM_UserTypeStudent;
        //设置高度。
        [_shopCarView updateFrame:_shopCarView.studentSelectedView];
        [_shopCarView.studentSelectedView.tableView reloadData];
        //设置选中的数量
        [_shopCarView setSelectedBooksNumber:_arrSelectedStudent.count];
    }
}

#pragma mark - SlideSwitchDelegate

/** 选择班级 */
- (void)slideSwitchDidselectAtIndex:(NSInteger)index {
    ClassModel *classInfo = _arrClasses[index];
    UCImpowerStudentVC *studentList = _arrViewControllers[index];
    studentList.classId = classInfo.classId;
}

@end
