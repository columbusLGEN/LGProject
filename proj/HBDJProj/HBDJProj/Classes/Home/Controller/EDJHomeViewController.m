//
//  EDJHomeViewController.m
//  HBDJProj
//
//  Created by Peanut Lee on 2018/4/2.
//  Copyright © 2018年 Lee. All rights reserved.
//

#import "EDJHomeViewController.h"
#import "EDJHomeHeaderView.h"
#import "EDJMicroPartyLessionViewController.h"
#import "EDJDigitalReadViewController.h"
#import "LGSegmentControl.h"
#import "EDJMicroBuildCell.h"
#import "EDJMicroPartyLessonCell.h"
#import "EDJHomeNav.h"

@interface EDJHomeViewController ()<
EDJHomeNavDelelgate,
UITableViewDelegate,
UICollectionViewDelegate,
LGSegmentControlDelegate
>

@property (strong,nonatomic) EDJHomeHeaderView *header;
/** 微党课&党建要闻控制器 */
@property (strong,nonatomic) EDJMicroPartyLessionViewController *microPLViewController;
/** 数字阅读控制器 */
@property (strong,nonatomic) EDJDigitalReadViewController *digitalController;
@property (assign,nonatomic) NSInteger currentSegment;
@property (assign,nonatomic) CGPoint lastContentOffset;
@property (strong,nonatomic) EDJHomeNav *nav;

@end

@implementation EDJHomeViewController

- (void)loadView{
    [super loadView];
    [self.navigationController setNavigationBarHidden:YES animated:NO];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    /// 设置 _lastContentOffset 的默认值,防止在一开始没有滑动的时候直接点击造成的错位
    _lastContentOffset = CGPointMake(0, -[self headerHeight]);
    
    /// 设置header轮播图数据
    self.header.imgURLStrings = @[
                                  @"https://goss.vcg.com/creative/vcg/800/version23/VCG21gic13374057.jpg",
                                  @"http://dl.bizhi.sogou.com/images/2013/12/19/458657.jpg",
                                  @"https://goss3.vcg.com/creative/vcg/800/version23/VCG21gic19568254.jpg"];
    
    /// 默认加载微党课
    [self configMOBVcWithSegment:0];
    
    /// TODO: 希望: 系统版本小于11.0,编译此处
    self.automaticallyAdjustsScrollViewInsets = NO;
    
    /// 添加自定义导航栏
    EDJHomeNav *nav = [[EDJHomeNav alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, navHeight())];
    [self.view addSubview:nav];
    _nav = nav;
    
    UISwipeGestureRecognizer *swipeRight = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(swipe:)];
    [self.view addGestureRecognizer:swipeRight];
    
    UISwipeGestureRecognizer *swipeLeft = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(swipe:)];
    swipeLeft.direction = UISwipeGestureRecognizerDirectionLeft;
    [self.view addGestureRecognizer:swipeLeft];
}

- (void)swipe:(UISwipeGestureRecognizer *)swipeRecognizer{
    if (swipeRecognizer.direction == 1) {
        /// 向右扫 -- > 屏幕向左滑动
        switch (_currentSegment) {
            case 0:{
            }
                break;
            case 1:{
                [self segmentControl:nil didClick:0];
                [self.header.segment elfAnimateWithIndex:0];
                _currentSegment = 0;
                
            }
                break;
            case 2:{
                [self segmentControl:nil didClick:1];
                [self.header.segment elfAnimateWithIndex:1];
                _currentSegment = 1;
                
            }
                break;
        }
        
    }else if (swipeRecognizer.direction == 2){
        /// 向左扫
        switch (_currentSegment) {
            case 0:{
                [self segmentControl:nil didClick:1];
                [self.header.segment elfAnimateWithIndex:1];
                _currentSegment = 1;
            }
                break;
            case 1:{
                [self segmentControl:nil didClick:2];
                [self.header.segment elfAnimateWithIndex:2];
                _currentSegment = 2;
                
            }
                break;
            case 2:{
            }
                break;
        }
    }
    

}

/// switch 语句中的两个分支,加载同一个控制器,但是数据需要分别处理,如何简化代码?
#pragma mark - LGSegmentControlDelegate
- (void)segmentControl:(LGSegmentControl *)sender didClick:(NSInteger)click{
    if (_currentSegment != click) {/// 从其余页面切换
        if (click == 2) {
            /// digital read /// 数字阅读
            [self.microPLViewController.tableView removeFromSuperview];
            self.digitalController.collectionView.delegate = self;
            [self.view addSubview:self.digitalController.collectionView];
            [self.digitalController.collectionView addSubview:_header];
            [self.digitalController.collectionView setContentOffset:_lastContentOffset animated:NO];
        }else{
            /// micro party lession
            /// party build big news
            [self configMOBVcWithSegment:click];
        }
    }
    [self.view bringSubviewToFront:_nav];
    _currentSegment = click;
}
- (void)configMOBVcWithSegment:(NSInteger)segment{
    self.microPLViewController.dataType = segment;
    self.microPLViewController.tableView.delegate = self;
    [self.view addSubview:self.microPLViewController.tableView];
    [self.microPLViewController.tableView addSubview:_header];
    [self.microPLViewController.tableView setContentOffset:_lastContentOffset animated:NO];
}

#pragma mark - UIScrollViewDelegate
- (void)scrollViewDidScroll:(UIScrollView *)scrollView{
    /// 控制头部在滚动时的frame
    CGFloat offsetY = scrollView.contentOffset.y;
    if (offsetY <= -[self headerHeight]) {
        /// tempView 保持原来的位置
        _header.frame = CGRectMake(0, offsetY, kScreenWidth, [self headerHeight]);
    }else{
    }
    _lastContentOffset = scrollView.contentOffset;
}

#pragma mark - UITableViewDelegate
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (_currentSegment == 0) {
        return [EDJMicroPartyLessonCell cellHeightWithModel:self.microPLViewController.microModels[indexPath.row]];
    }else if (_currentSegment == 1){
        return [EDJMicroBuildCell cellHeightWithModel:self.microPLViewController.buildModels[indexPath.row]];
    }
    return 0;
}


#pragma mark - nav delegate


/// MARK: lazy load
- (EDJHomeHeaderView *)header{
    if (_header == nil) {
        /// frame
        CGFloat headerHeight = [self headerHeight];
        CGRect headerFrame = CGRectMake(0, - headerHeight, kScreenWidth,headerHeight);
        
        /// header
        _header = [[EDJHomeHeaderView alloc] initWithFrame:headerFrame];
        _header.nav.delegate = self;
        _header.segment.delegate = self;
    }
    return _header;
}

- (EDJMicroPartyLessionViewController *)microPLViewController{
    if (_microPLViewController == nil) {
        _microPLViewController = [EDJMicroPartyLessionViewController new];
    }
    return _microPLViewController;
}
- (EDJDigitalReadViewController *)digitalController{
    if (_digitalController == nil) {
        _digitalController = [EDJDigitalReadViewController new];
    }
    return _digitalController;
}


- (CGFloat)headerHeight{
    return [EDJHomeHeaderView headerHeight];
}
@end
