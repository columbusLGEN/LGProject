//
//  UTaskVC.m
//  EasyChineseReading-ios
//
//  Created by 赵春阳 on 17/8/30.
//  Copyright © 2017年 lee. All rights reserved.
//

#import "UserTaskVC.h"

#import "UTaskSystemVC.h"
#import "UTaskReadingVC.h"

@interface UserTaskVC ()

@property (strong, nonatomic) UTaskReadingVC *taskReadVC; /** 读书任务 */
@property (strong, nonatomic) UTaskSystemVC  *systemVC;   /** 系统任务 */

@property (strong, nonatomic) ZSegment *segment;          // 顶部选择条

@end

@implementation UserTaskVC

- (void)viewDidLoad {
    [super viewDidLoad];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:NO animated:YES];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)updateSystemLanguage
{
    self.title = LOCALIZATION(@"我的任务");
    
    _segment = [[ZSegment alloc] initWithFrame:CGRectMake(0, 0, Screen_Width, cHeaderHeight_44) leftTitle:LOCALIZATION(@"系统任务") rightTitle:LOCALIZATION(@"班级任务")];
    [self.view addSubview:_segment];
    
    WeakSelf(self)
    _segment.selectedLeft = ^{
        [weakself.view bringSubviewToFront:weakself.systemVC.view];
    };
    _segment.selectedRight = ^{
        [weakself.view bringSubviewToFront:weakself.taskReadVC.view];
    };
    
    [self configReadingTask];
    [self configSystemTask];
}

#pragma mark - 展示系统任务 读书任务

/* 系统任务 */
- (void)configSystemTask {

    _systemVC = [UTaskSystemVC new];
    _systemVC.view.frame = CGRectMake(0, cHeaderHeight_44, Screen_Width, self.view.height - 2*cHeaderHeight_44);

    [self addChildViewController:_systemVC];
    [self.view addSubview:_systemVC.view];
}

/* 读书任务 */
- (void)configReadingTask {
    _taskReadVC = [UTaskReadingVC new];
    _taskReadVC.view.frame = CGRectMake(0, cHeaderHeight_44, Screen_Width, self.view.height - 2*cHeaderHeight_44);
    
    [self addChildViewController:_taskReadVC];
    [self.view addSubview:_taskReadVC.view];
}

@end
