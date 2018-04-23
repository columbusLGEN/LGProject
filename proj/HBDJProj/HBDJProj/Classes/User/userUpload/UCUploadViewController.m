//
//  UCUploadViewController.m
//  HBDJProj
//
//  Created by Peanut Lee on 2018/4/20.
//  Copyright © 2018年 Lee. All rights reserved.
//

#import "UCUploadViewController.h"
#import "UCPartyMemberStageController.h"

@interface UCUploadViewController ()

@end

@implementation UCUploadViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = @"我的上传";
    
    [self.segmentItems enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        
        UCPartyMemberStageController *vc = (UCPartyMemberStageController *)[self lgInstantiateViewControllerWithStoryboardName:UserCenterStoryboardName controllerId:@"UCPartyMemberStageController"];
        CGFloat x = kScreenWidth * idx;
        vc.view.frame = CGRectMake(x, 0, self.scrollView.bounds.size.width, self.scrollView.bounds.size.height);
        [self.scrollView addSubview:vc.view];
    }];
    [self.scrollView setContentSize:CGSizeMake(self.segmentItems.count * kScreenWidth, 0)];
}

- (NSArray *)segmentItems{
    return @[@"党员舞台",@"思想汇报",@"述廉报告"];
}

@end
