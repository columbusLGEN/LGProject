//
//  TCScoolBookrackViewController.m
//  TimeCollege
//
//  Created by Peanut Lee on 2019/4/15.
//  Copyright © 2019 lee. All rights reserved.
//

#import "TCScoolBookrackViewController.h"
#import "TCSchoolBookTableViewController.h"
#import "LGSegmentScrollView.h"

@interface TCScoolBookrackViewController ()<LGSegmentScrollViewDelegate>

@end

@implementation TCScoolBookrackViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self configUI];
    
}

/** 搜索 */
- (void)searchMyBookrack{
    
}

- (void)segmentView:(LGSegmentScrollView *)segmentView index:(NSInteger)index{
    if (index == 0) {
        /// 数字教材
        NSLog(@"数字教材");
    }
    if (index == 1) {
        /// 电子图书
        NSLog(@"电子图书");
        
    }
}

- (void)configUI{
    self.title = @"学校书橱";
    
    /// 搜索按钮
    UIBarButtonItem *right = [UIBarButtonItem.alloc initWithImage:[UIImage imageNamed:@"icon_search_white"] style:UIBarButtonItemStyleDone target:self action:@selector(searchMyBookrack)];
    self.navigationItem.rightBarButtonItem = right;
    
    /// channel view 频道视图
    /// 切换频道时，主视图中 顶部的分类信息数据发生变化
    LGSegmentScrollView *channelView = [LGSegmentScrollView.alloc initWithSegmentItems:@[@"数字教材",@"电子图书"] frame:CGRectZero];
    channelView.delegate = self;
    [self.view addSubview:channelView];
    
    /// 上阴影
    UIImageView *shadowTop = [UIImageView.alloc initWithImage:[UIImage imageNamed:@"cyan_fade_down"]];
    [self.view addSubview:shadowTop];
    /// 下阴影
    UIImageView *shadowBottom = [UIImageView.alloc initWithImage:[UIImage imageNamed:@"cyan_fade_down"]];
    [self.view addSubview:shadowBottom];
    
    /// 主视图
    TCSchoolBookTableViewController *sbvc = TCSchoolBookTableViewController.new;
    [self.view addSubview:sbvc.view];
    [self addChildViewController:sbvc];
    
    [channelView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.top.equalTo(self.view);
        make.height.mas_equalTo(40);
    }];
    [shadowTop mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(self.view);
        make.top.equalTo(channelView.mas_bottom);
        make.height.mas_equalTo(10);
    }];
    [shadowBottom mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(self.view);
        make.bottom.equalTo(self.view);
        make.height.mas_equalTo(10);
    }];
    
    [sbvc.view mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(self.view);
        make.top.equalTo(shadowTop.mas_bottom);
        make.bottom.equalTo(shadowBottom.mas_top);
    }];
    
}


@end
