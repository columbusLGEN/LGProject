//
//  TCBookDetailManagerController.m
//  TimeCollege
//
//  Created by Peanut Lee on 2019/4/29.
//  Copyright © 2019 lee. All rights reserved.
//

#import "TCBookDetailManagerController.h"
#import "TCBookDetailViewController.h"
#import "TCBookDetaileBookBottomView.h"

@interface TCBookDetailManagerController ()
@property (strong,nonatomic) TCBookDetaileBookBottomView *bottomv;
@end

@implementation TCBookDetailManagerController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self configUI];
    
}

- (void)configUI{
    
    TCBookDetailViewController *devc = [TCBookDetailViewController bookinfovc];
    [self addChildViewController:devc];
    [self.view addSubview:devc.view];
    
    if (self.detailType == 1) {
        /// 电子图书
        self.bottomv = [TCBookDetaileBookBottomView bookDetailBottomv];
        [self.view addSubview:self.bottomv];
        [self.bottomv mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.right.bottom.equalTo(self.view);
            make.height.mas_equalTo(70);
        }];
        
        [devc.view mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.right.top.equalTo(self.view);
            make.bottom.equalTo(self.bottomv.mas_top);
        }];
    }
    
    if (self.detailType == 2) {
        /// 数字教材
        [devc.view mas_makeConstraints:^(MASConstraintMaker *make) {
            make.edges.equalTo(self.view);
        }];
        
    }
}


@end
