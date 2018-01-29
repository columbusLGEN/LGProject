//
//  UTaskSystemVC.m
//  EasyChineseReading-ios
//
//  Created by 赵春阳 on 2017/9/11.
//  Copyright © 2017年 lee. All rights reserved.
//

#import "UTaskSystemVC.h"

#import "UTaskCollectionViewCell.h"

static CGFloat const kCellSpace = 20.f;

@interface UTaskSystemVC () <UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout>

@property (strong, nonatomic) UICollectionView *collectionView;
@property (strong, nonatomic) UICollectionViewFlowLayout *layout;

@property (strong, nonatomic) NSArray        *arrTasks;        // 全部任务
@property (strong, nonatomic) NSMutableArray *arrEveryDayTask; // 日常任务
@property (strong, nonatomic) NSMutableArray *arrLongTimeTask; // 成就任务

@property (strong, nonatomic) TaskModel *task;              // 正在获取积分的任务
@property (assign, nonatomic) ENUM_TaskType taskType;       // 任务类别

@property (strong, nonatomic) ZSegment *segment;            // 顶部选择条

@end

@implementation UTaskSystemVC

- (void)viewDidLoad {
    [super viewDidLoad];
    [self configSystemTaskView];
    [self getTasks];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)updateSystemLanguage
{
    [_collectionView reloadData];
}

#pragma mark - 配置界面

- (void)configSystemTaskView
{
    _arrLongTimeTask = [NSMutableArray array];
    _arrEveryDayTask = [NSMutableArray array];
    _arrTasks        = [NSArray array];
    
    _taskType = ENUM_TaskTypeEveryDay;
    
    [self.view addSubview:self.collectionView];
    
    UIView *segmentBackground = [[UIView alloc] initWithFrame:CGRectMake(0, 0, Screen_Width, cHeaderHeight_44)];
    segmentBackground.backgroundColor = [UIColor cm_grayColor__F1F1F1_1];
    [self.view addSubview:segmentBackground];
    
    UIView *line = [[UIView alloc] initWithFrame:CGRectMake(0, cHeaderHeight_44 - 1, segmentBackground.width, 1)];
    line.backgroundColor = [UIColor cm_lineColor_D9D7D7_1];
    [segmentBackground addSubview:line];
    
    _segment = [[ZSegment alloc] initWithFrame:CGRectMake(0, 0, Screen_Width*3/4, cHeaderHeight_44) leftTitle:LOCALIZATION(@"日常任务") rightTitle:LOCALIZATION(@"我的成就") selectedColor:[UIColor cm_mainColor] sliderColor:[UIColor cm_grayColor__F1F1F1_1] verLineColor:[UIColor cm_grayColor__F1F1F1_1] diamondColor:[UIColor cm_mainColor]];
    _segment.backgroundColor = [UIColor cm_grayColor__F1F1F1_1];
    [self.view addSubview:_segment];

    WeakSelf(self)
    _segment.selectedLeft = ^{
        StrongSelf(self)
        self.taskType = ENUM_TaskTypeEveryDay;
        [self.collectionView reloadData];
    };
    _segment.selectedRight = ^{
        StrongSelf(self)
        self.taskType = ENUM_TaskTypeLongTime;
        [self.collectionView reloadData];
    };
    
}

#pragma mark - 获取数据

- (void)getTasks
{
    [self showWaitTips];
    WeakSelf(self)
    [[TaskRequest sharedInstance] getTaskListWithCompletion:^(id object, ErrorModel *error) {
        StrongSelf(self)
        [self dismissTips];
        if (error)
            [self presentSuccessTips:error.message];
        else
            self.arrTasks = [TaskModel mj_objectArrayWithKeyValuesArray:object];
    }];
}

- (void)setArrTasks:(NSArray *)arrTasks
{
    WeakSelf(self)
    [arrTasks enumerateObjectsUsingBlock:^(TaskModel *task, NSUInteger idx, BOOL * _Nonnull stop) {
        StrongSelf(self)
        if (task.taskTimes == 0)
            [self.arrEveryDayTask addObject:task];
        else
            [self.arrLongTimeTask addObject:task];
        
        if (idx == arrTasks.count - 1)
            [self.collectionView reloadData];
    }];
}

#pragma mark - collectionView data source

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return _taskType == ENUM_TaskTypeEveryDay ? _arrEveryDayTask.count : _arrLongTimeTask.count;
}

- (__kindof UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    UTaskCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:NSStringFromClass([UTaskCollectionViewCell class]) forIndexPath:indexPath];
    cell.data = _taskType == ENUM_TaskTypeEveryDay ? _arrEveryDayTask[indexPath.row] : _arrLongTimeTask[indexPath.row];
    return cell;
}

#pragma mark - collectionView delegate

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    TaskModel *task = _taskType == ENUM_TaskTypeEveryDay ? _arrEveryDayTask[indexPath.row] : _arrLongTimeTask[indexPath.row];
    // 如果任务已完成且未领取积分，点击领取积分
    if (task.status == ENUM_TaskStatusTypeDone)
        [self getTaskAwardWithTask:task index:indexPath.row];
}

/**
 获取任务积分

 @param task  任务
 @param index 位置
 */
- (void)getTaskAwardWithTask:(TaskModel *)task index:(NSInteger)index
{
    if (task.status == ENUM_TaskStatusTypeDone) {
        _task = task;
        WeakSelf(self)
        [[TaskRequest sharedInstance] getTaskAwardWithTask:_task completion:^(id object, ErrorModel *error) {
            if (error)
                [weakself presentFailureTips:error.message];
            else
                [weakself getIntegralSuccessWithTask:_task index:index];
        }];
    }
}

/**
 获取积分成功后，更新界面

 @param task  任务
 @param index 位置
 */
- (void)getIntegralSuccessWithTask:(TaskModel *)task index:(NSInteger)index
{
    NSIndexPath *indexPath = [NSIndexPath indexPathForRow:index inSection:0];
    UTaskCollectionViewCell *cell = (UTaskCollectionViewCell *)[_collectionView cellForItemAtIndexPath:indexPath];
    task.status = ENUM_TaskStatusTypeGetIntegral;
    [cell getTaskIntegral];
}

#pragma mark - 属性

- (UICollectionView *)collectionView
{
    if (_collectionView == nil) {
        CGFloat navHeight = [IPhoneVersion deviceVersion] == iphoneX ? cHeaderHeight_88 : cHeaderHeight_64;
        _collectionView = [[UICollectionView alloc] initWithFrame:CGRectMake(0, cHeaderHeight_44, Screen_Width, self.view.height - cHeaderHeight_44 - navHeight - kCellSpace) collectionViewLayout:self.layout];
        
        _collectionView.delegate = self;
        _collectionView.dataSource = self;
        
        _collectionView.backgroundColor = [UIColor whiteColor];
        
        [_collectionView registerNib:[UINib nibWithNibName:NSStringFromClass([UTaskCollectionViewCell class]) bundle:nil] forCellWithReuseIdentifier:NSStringFromClass([UTaskCollectionViewCell class])];
    }
    return _collectionView;
}

- (UICollectionViewFlowLayout *)layout
{
    if (_layout == nil) {
        _layout = [[UICollectionViewFlowLayout alloc] init];
        
        _layout.minimumLineSpacing      = kCellSpace;
        _layout.minimumInteritemSpacing = kCellSpace;
        _layout.sectionInset            = UIEdgeInsetsMake(kCellSpace, kCellSpace, kCellSpace, kCellSpace);
        NSInteger number = isPad ? 4 : 2;
        _layout.itemSize                = CGSizeMake((Screen_Width - kCellSpace*(number + 1))/number, (Screen_Width - kCellSpace*(number + 1))/number);
    }
    return _layout;
}

@end
