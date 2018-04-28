//
//  UCUploadViewController.m
//  HBDJProj
//
//  Created by Peanut Lee on 2018/4/20.
//  Copyright © 2018年 Lee. All rights reserved.
//

#import "LGSegmentViewController.h"
#import "LGSegmentView.h"

@interface LGSegmentViewController ()<
UIScrollViewDelegate,
LGSegmentViewDelegate
>

@end

@implementation LGSegmentViewController

- (void)viewDidLayoutSubviews{
    [super viewDidLayoutSubviews];
    NSLog(@"viewDidLayoutSubviews -- ");
}


- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:NO animated:YES];
}


- (void)viewDidLoad {
    [super viewDidLoad];
    [self configUI];

}
- (void)configUI{
    self.view.backgroundColor = [UIColor EDJGrayscale_F3];
    LGSegmentView *segment = [[LGSegmentView alloc] initWithSegmentItems:self.segmentItems];
    [self.view addSubview:segment];
    [segment mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.view.mas_left);
        make.right.equalTo(self.view.mas_right);
        make.height.mas_equalTo(self.segmentHeight);
        make.width.mas_equalTo(kScreenWidth);
        make.top.equalTo(self.view.mas_topMargin).offset(self.segmentTopMargin);
    }];
    segment.delegate = self;
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
    
    /// TODO: 默认只加载第一个视图,视图发生滑动或者点击2,3事件,再加载后面的视图

    [self.segmentItems enumerateObjectsUsingBlock:^(NSDictionary * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        UIViewController *vc;
        NSString *viewControllerClassString = obj[LGSegmentItemViewControllerClassKey];
        /// TODO: 类型判断,确保 viewControllerClassString 是 UIViewController 类对象或者派生类对象

        if ([obj[LGSegmentItemViewControllerInitTypeKey] isEqualToString:LGSegmentVcInitTypeStoryboard]) {
            vc = [self lgInstantiateViewControllerWithStoryboardName:UserCenterStoryboardName controllerId:viewControllerClassString];
        }else{
            vc = [[NSClassFromString(viewControllerClassString) alloc] init];
        }

        CGFloat x = kScreenWidth * idx;
        vc.view.frame = CGRectMake(x, 0, self.scrollView.bounds.size.width, self.scrollView.bounds.size.height);
        [self.scrollView addSubview:vc.view];
        [self addChildViewController:vc];
    }];
    [self.scrollView setContentSize:CGSizeMake(self.segmentItems.count * kScreenWidth, 0)];
}

#pragma mark - scroll view delegate
- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView{
    NSInteger index = scrollView.contentOffset.x / kScreenWidth;
    [_segment setFlyLocationWithIndex:index];
    [self viewSwitched:index];
}

#pragma mark - segment view delegate
- (void)segmentView:(LGSegmentView *)segmentView click:(NSInteger)click{
    CGFloat contentOffsetX = click * kScreenWidth;
    [self.scrollView setContentOffset:CGPointMake(contentOffsetX, 0) animated:YES];
    [self viewSwitched:click];
}

- (void)viewSwitched:(NSInteger)index{
    
}

- (CGFloat)segmentHeight{
    return 40;
}
- (CGFloat)segmentTopMargin{
    return marginTen;
}

@end
