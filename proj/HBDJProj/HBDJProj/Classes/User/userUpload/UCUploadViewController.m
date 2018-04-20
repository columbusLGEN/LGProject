//
//  UCUploadViewController.m
//  HBDJProj
//
//  Created by Peanut Lee on 2018/4/20.
//  Copyright © 2018年 Lee. All rights reserved.
//

#import "UCUploadViewController.h"

@interface UCUploadViewController ()

@end

@implementation UCUploadViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"我的上传";
    
}

- (NSArray *)segmentItems{
    return @[@"党员舞台",@"思想汇报",@"述廉报告"];
}

@end
