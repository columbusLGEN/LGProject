//
//  LGSwitchViewController.m
//  HBDJProj
//
//  Created by Peanut Lee on 2018/8/28.
//  Copyright © 2018年 Lee. All rights reserved.
//

#import "LGSwitchViewController.h"
#import "LGSegmentScrollView.h"

@interface LGSwitchViewController ()<
UIScrollViewDelegate,
LGSegmentScrollViewDelegate
>

@end

@implementation LGSwitchViewController

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
    
    NSMutableArray *itemTitles = NSMutableArray.new;
    for (NSInteger i = 0; i < self.segmentItems.count; i++) {
        NSString *itemName = self.segmentItems[i][LGSegmentItemNameKey];
        [itemTitles addObject:itemName];
    }
    
    LGSegmentScrollView *segment = [[LGSegmentScrollView alloc] initWithSegmentItems:itemTitles.copy frame:CGRectZero];
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
    scrollView.bounces = NO;
    scrollView.showsHorizontalScrollIndicator = NO;
    [self.view addSubview:scrollView];
    [scrollView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.view.mas_left);
        make.right.equalTo(self.view.mas_right);
        make.bottom.equalTo(self.view.mas_bottom);
        make.top.equalTo(segment.mas_bottom).offset(marginTen);
    }];
    _scrollView = scrollView;
    
    /// TODO: 默认只加载第一个视图,视图发生滑动或者点击2,3事件,再加载后面的视图
    
    for (NSInteger idx = 0; idx < self.segmentItems.count; idx++) {
        NSDictionary *obj = self.segmentItems[idx];
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
    }
    
    [self.scrollView setContentSize:CGSizeMake(self.segmentItems.count * kScreenWidth, 0)];
    
}

#pragma mark - scroll view delegate
- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView{
    NSInteger index = scrollView.contentOffset.x / kScreenWidth;
    [_segment setFlyLocationWithIndex:index];
    [self viewSwitched:index];
}

#pragma mark - segment view delegate
- (void)segmentView:(LGSegmentScrollView *)segmentView index:(NSInteger)index{
    CGFloat contentOffsetX = index * kScreenWidth;
    [self.scrollView setContentOffset:CGPointMake(contentOffsetX, 0) animated:YES];
    [self viewSwitched:index];
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
