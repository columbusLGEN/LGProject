//
//  OLKnowleageTestController.m
//  HBDJProj
//
//  Created by Peanut Lee on 2018/5/4.
//  Copyright © 2018年 Lee. All rights reserved.
//

#import "OLKnowleageTestController.h"
#import "OLTkcsTableViewController.h"

@interface OLKnowleageTestController ()

@end

@implementation OLKnowleageTestController

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:YES animated:YES];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
}

#pragma mark - target
- (IBAction)close:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
    
}
- (IBAction)tkClick:(UIButton *)sender {
    [self pushTkcsVcWithType:OLTkcsTypetk title:@"题库"];
}
- (IBAction)csClick:(UIButton *)sender {
    [self pushTkcsVcWithType:OLTkcsTypecs title:@"测试"];
}

#pragma mark - 私有方法
- (void)pushTkcsVcWithType:(OLTkcsType)tkcsType title:(NSString *)title{
    OLTkcsTableViewController *vc = [OLTkcsTableViewController new];
    vc.tkcsType = tkcsType;
    vc.title = title;
    [self.navigationController pushViewController:vc animated:YES];
}

@end
