//
//  UCUploadPyqViewController.m
//  HBDJProj
//
//  Created by Peanut Lee on 2018/8/14.
//  Copyright © 2018年 Lee. All rights reserved.
//

#import "UCUploadPyqViewController.h"
#import "UCMemberStageTransitionView.h"
#import "UCUploadViewController.h"

@interface UCUploadPyqViewController ()<
UCMemberStageTransitionViewDelegate>

@property (weak,nonatomic) UCMemberStageTransitionView *tv;

@end

@implementation UCUploadPyqViewController

- (void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    [UIView animateWithDuration:0.2 animations:^{
        [_tv setBigCloseBackgroundColor];
    }];
}

- (void)viewDidLoad {
    [super viewDidLoad];

    UCMemberStageTransitionView *tv = UCMemberStageTransitionView.memberStateTransitionView;
    tv.delegate = self;
    self.view = tv;
    _tv = tv;
    
    
}

- (void)mstViewClose:(UCMemberStageTransitionView *)mstView{
    [UIView animateWithDuration:0.2 animations:^{
        [_tv setBigCloseBackgroundColorClear];
    } completion:^(BOOL finished) {
        [self lg_dismissViewController];
    }];
}
- (void)mstView:(UCMemberStageTransitionView *)mstView action:(DJUploadPyqAction)action{
    
    UCUploadViewController *upvc = [UCUploadViewController new];
    upvc.uploadAction = action;
    LGBaseNavigationController *nav = [[LGBaseNavigationController alloc] initWithRootViewController:upvc];
    [self presentViewController:nav animated:YES completion:nil];
}




@end
