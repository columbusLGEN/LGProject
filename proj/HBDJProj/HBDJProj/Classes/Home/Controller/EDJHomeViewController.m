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
#import "EDJMicroLessonHeaderView.h"

@interface EDJHomeViewController ()<
EDJHomeNavDelelgate,
UITableViewDelegate,
UICollectionViewDelegate,
LGSegmentControlDelegate,
EDJMicroLessonHeaderViewDelegate
>

@property (strong,nonatomic) EDJHomeHeaderView *header;
/** 微党课&党建要闻控制器 */
@property (strong,nonatomic) EDJMicroPartyLessionViewController *microPLViewController;
/** 数字阅读控制器 */
@property (strong,nonatomic) EDJDigitalReadViewController *digitalController;
@property (assign,nonatomic) NSInteger currentSegment;
@property (assign,nonatomic) CGPoint lastContentOffset;

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
  
}

#pragma mark - 微党课header点击事件
- (void)mlHeaderClick:(EDJMicroLessonHeaderView *)header segment:(NSInteger)segment{
    NSLog(@"微党课 -- %ld",segment);
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
    _currentSegment = click;
}
- (void)configMOBVcWithSegment:(NSInteger)segment{
    self.microPLViewController.tableView.delegate = self;
    [self.microPLViewController configHeaderWithSegment:segment delegate:self];
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
    return 376;
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
