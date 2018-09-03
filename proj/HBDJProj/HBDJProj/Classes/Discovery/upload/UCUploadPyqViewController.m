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
#import "DJRecordVoiceViewController.h"

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

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:YES animated:YES];
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
    
    if (action == DJUPloadPyqActionAudio) {
        DJRecordVoiceViewController *video = DJRecordVoiceViewController.new;
        video.pushWay = LGBaseViewControllerPushWayModal;
//        LGBaseNavigationController *nav = [[LGBaseNavigationController alloc] initWithRootViewController:video];
//        [self presentViewController:nav animated:YES completion:nil];
        [self.navigationController pushViewController:video animated:YES];
    }else{
        UCUploadViewController *upvc = [UCUploadViewController new];
        upvc.uploadAction = action;
        upvc.pushWay = LGBaseViewControllerPushWayModal;
//        LGBaseNavigationController *nav = [[LGBaseNavigationController alloc] initWithRootViewController:upvc];
//        [self presentViewController:nav animated:YES completion:nil];
        [self.navigationController pushViewController:upvc animated:YES];
    }
    
}




@end
