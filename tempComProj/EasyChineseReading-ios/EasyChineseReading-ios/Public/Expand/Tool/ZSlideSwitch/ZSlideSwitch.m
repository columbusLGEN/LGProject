//
//  ZSlideSwitch.m
//  EasyChineseReading-ios
//
//  Created by 赵春阳 on 17/9/2.
//  Copyright © 2017年 lee. All rights reserved.
//

#import "ZSlideSwitch.h"

#import "ZSlideSegment.h"

@interface ZSlideSwitch ()<UIPageViewControllerDelegate, UIPageViewControllerDataSource, UIScrollViewDelegate, ZSlideSegmentDelegate>
{    
    ZSlideSegment *_segment;
    UIPageViewController *_pageVC;
}
@end

@implementation ZSlideSwitch

-(instancetype)initWithFrame:(CGRect)frame titles:(NSArray <NSString *>*)titles viewControllers:(NSArray <UIViewController *>*)viewControllers{
    return [self initWithFrame:frame titles:titles viewControllers:viewControllers canScroll:NO needCenter:NO];
}

-(instancetype)initWithFrame:(CGRect)frame titles:(NSArray <NSString *>*)titles viewControllers:(NSArray <UIViewController *>*)viewControllers canScroll:(BOOL)canScroll needCenter:(BOOL)needCenter{
    if (self = [super initWithFrame:frame]) {
        [self buildUI];
        self.arrTitles = titles;
        self.arrViewControllers = viewControllers;
        _segment.canScroll = canScroll;
        _segment.needCenter = needCenter;
    }
    return self;
}


- (void)buildUI {
    self.backgroundColor = [UIColor whiteColor];
    [self addSubview:[UIView new]];
    //添加分段选择器
    _segment = [[ZSlideSegment alloc] init];
    _segment.frame = CGRectMake(0, 0, self.width, cHeaderHeight_44);
    _segment.delegate = self;
    [self addSubview:_segment];
    
    //添加分页滚动视图控制器
    _pageVC = [[UIPageViewController alloc] initWithTransitionStyle:UIPageViewControllerTransitionStyleScroll navigationOrientation:UIPageViewControllerNavigationOrientationHorizontal options:nil];
    _pageVC.view.frame = CGRectMake(0, cHeaderHeight_44, Screen_Width, self.height - cHeaderHeight_44);
    _pageVC.delegate = self;
    _pageVC.dataSource = self;
    [self addSubview:_pageVC.view];
    
    //设置ScrollView代理
    for (UIScrollView *scrollView in _pageVC.view.subviews) {
        if ([scrollView isKindOfClass:[UIScrollView class]]) {
            scrollView.delegate = self;
        }
    }
}

- (void)showInViewController:(UIViewController *)viewController {
    [viewController addChildViewController:_pageVC];
    [viewController.view addSubview:self];
}

- (void)showInNavigationController:(UINavigationController *)navigationController {
    [navigationController.topViewController.view addSubview:self];
    [navigationController.topViewController addChildViewController:_pageVC];
    navigationController.topViewController.navigationItem.titleView = _segment;
    _pageVC.view.frame = self.bounds;
    _segment.backgroundColor = [UIColor whiteColor];
}

- (void)willMoveToSuperview:(UIView *)newSuperview {
    [super willMoveToSuperview:newSuperview];
    [self switchToIndex:_selectedIndex];
}

#pragma mark -
#pragma mark Setter&Getter

- (void)setArrViewControllers:(NSArray *)arrViewControllers
{
    _arrViewControllers = arrViewControllers;
}

- (void)setArrTitles:(NSArray *)arrTitles
{
    _arrTitles = arrTitles;
    _segment.arrTitles = arrTitles;
}

- (void)setSelectedColor:(UIColor *)selectedColor
{
    _segment.selectedColor = selectedColor;
}

- (void)setNormalColor:(UIColor *)normalColor
{
    _segment.normalColor = normalColor;
}

- (void)setSelectedIndex:(NSInteger)selectedIndex {
    _selectedIndex = selectedIndex;
    _segment.selectedIndex = _selectedIndex;
    [self switchToIndex:_selectedIndex];
}

- (void)setHideShadow:(BOOL)hideShadow {
    _hideShadow = hideShadow;
    _segment.hideShadow = _hideShadow;
}

#pragma mark -
#pragma mark SlideSegmentDelegate

- (void)slideSegmentDidSelectedAtIndex:(NSInteger)index {
    if (index == _selectedIndex) {return;}
    [self switchToIndex:index];
}

#pragma mark -
#pragma mark UIPageViewControllerDelegate&DataSource

- (UIViewController *)pageViewController:(UIPageViewController *)pageViewController viewControllerAfterViewController:(UIViewController *)viewController {
    UIViewController *vc;
    if (_selectedIndex + 1 < _arrViewControllers.count) {
        vc = _arrViewControllers[_selectedIndex + 1];
        vc.view.bounds = pageViewController.view.bounds;
    }
    return vc;
}

- (UIViewController *)pageViewController:(UIPageViewController *)pageViewController viewControllerBeforeViewController:(UIViewController *)viewController {
    UIViewController *vc;
    if (_selectedIndex - 1 >= 0) {
        vc = _arrViewControllers[_selectedIndex - 1];
        vc.view.bounds = pageViewController.view.bounds;
    }
    return vc;
}

- (void)pageViewController:(UIPageViewController *)pageViewController didFinishAnimating:(BOOL)finished previousViewControllers:(NSArray<UIViewController *> *)previousViewControllers transitionCompleted:(BOOL)completed {
    _selectedIndex = [_arrViewControllers indexOfObject:pageViewController.viewControllers.firstObject];
    _segment.selectedIndex = _selectedIndex;
    [self performSwitchDelegateMethod];
}

- (UIInterfaceOrientation)pageViewControllerPreferredInterfaceOrientationForPresentation:(UIPageViewController *)pageViewController NS_AVAILABLE_IOS(7_0) __TVOS_PROHIBITED {
    return UIInterfaceOrientationPortrait;
}

#pragma mark - ScrollViewDelegate

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    //    if (!scrollView.isDragging) {return;}
    if (scrollView.contentOffset.x == scrollView.bounds.size.width) {return;}
    CGFloat progress = scrollView.contentOffset.x/scrollView.bounds.size.width;
    _segment.progress = progress;
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
    [_segment.collectionView reloadData];
}

- (void)scrollViewDidEndScrollingAnimation:(UIScrollView *)scrollView {
    _segment.ignoreAnimation = false;
}

#pragma mark - 其他方法

- (void)switchToIndex:(NSInteger)index {
    __weak __typeof(self)weekSelf = self;
    [_pageVC setViewControllers:@[_arrViewControllers[index]] direction:index<_selectedIndex animated:YES completion:^(BOOL finished) {
        _selectedIndex = index;
        [weekSelf performSwitchDelegateMethod];
    }];
}

//执行切换代理方法
- (void)performSwitchDelegateMethod {
    if ([_delegate respondsToSelector:@selector(slideSwitchDidselectAtIndex:)]) {
        [_delegate slideSwitchDidselectAtIndex:_selectedIndex];
    }
}
@end
