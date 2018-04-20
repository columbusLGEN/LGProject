//
//  UCUploadViewController.m
//  HBDJProj
//
//  Created by Peanut Lee on 2018/4/20.
//  Copyright © 2018年 Lee. All rights reserved.
//

#import "LGSegmentViewController.h"
#import "LGSegmentView.h"

@interface LGSegmentViewController ()<UIScrollViewDelegate>
@property (weak,nonatomic) LGSegmentView *segment;
@property (weak,nonatomic) UIScrollView *scrollView;

@end

@implementation LGSegmentViewController

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:NO animated:YES];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self uiConfig];
    
}
- (void)uiConfig{
    self.view.backgroundColor = [UIColor EDJGrayscale_F3];
    CGFloat segmentHeight = 40;
    LGSegmentView *segment = [[LGSegmentView alloc] initWithSegmentItems:self.segmentItems];
    [self.view addSubview:segment];
    [segment mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.view.mas_left);
        make.right.equalTo(self.view.mas_right);
        make.height.mas_equalTo(segmentHeight);
        make.width.mas_equalTo(kScreenWidth);
        make.top.equalTo(self.view.mas_topMargin).offset(marginTen);
    }];
    _segment = segment;
    
    UIScrollView *scrollView = [UIScrollView new];
    scrollView.delegate = self;
    scrollView.pagingEnabled = YES;
    [self.view addSubview:scrollView];
    [scrollView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.view.mas_left);
        make.right.equalTo(self.view.mas_right);
        make.bottom.equalTo(self.view.mas_bottom);
        make.top.equalTo(segment.mas_bottom).offset(marginTen);
    }];
    _scrollView = scrollView;
    
    [self.segmentItems enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        UIView *test = [[UIView alloc] initWithFrame:CGRectMake(idx * kScreenWidth, 0, kScreenWidth, kScreenHeight - 2 * marginTen - segmentHeight)];
        test.backgroundColor = [UIColor randomColor];
        [self.scrollView addSubview:test];
    }];
    [scrollView setContentSize:CGSizeMake(self.segmentItems.count * kScreenWidth, 0)];
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView{
    
}
- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView{
    NSInteger index = scrollView.contentOffset.x / kScreenWidth;
    NSLog(@"index -- %ld",index);
    [_segment setFlyLocationWithIndex:index];
}


/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/



@end
