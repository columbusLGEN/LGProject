//
//  OLThreeMeetingsViewController.m
//  HBDJProj
//
//  Created by Peanut Lee on 2018/5/4.
//  Copyright © 2018年 Lee. All rights reserved.
//

#import "OLThreeMeetingsViewController.h"
#import "OLMindReportViewController.h"

static CGFloat channelLabelY = 17;
static CGFloat channelScrollViewHeight = 51;

#define contentScrollViewHeight (kScreenHeight - channelScrollViewHeight - kNavHeight)

@interface OLThreeMeetingsViewController ()<
UIScrollViewDelegate>
@property (strong,nonatomic) UIScrollView *channelScrollView;
@property (weak,nonatomic) UIView *elf;

@property (strong,nonatomic) UIScrollView *contentScrollView;

@property (strong,nonatomic) NSArray *channelTitleArray;
@property (strong,nonatomic) NSMutableArray *channelLabelArray;

@property (assign,nonatomic) NSInteger currentIndex;

@end

@implementation OLThreeMeetingsViewController

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:NO animated:YES];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self configUI];
    
}

- (void)configUI{
    [self.view addSubview:self.channelScrollView];
    
    _channelLabelArray = [NSMutableArray new];
    self.channelTitleArray = @[@"全部",@"支部党员大会",@"党支部委员会",@"党小组会",@"党课  "];
    
    /// MARK: 配置channel
    __block CGFloat totalWidth;
    [self.channelTitleArray enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        NSString *title = obj;
        
        UILabel *lastLabel;
        CGFloat x;
        if (idx > 0) {
            lastLabel = _channelLabelArray[idx - 1];
            x = marginTen + CGRectGetMaxX(lastLabel.frame);
        }else{
            x = marginTen;
        }
        
        CGRect labelFrame = CGRectMake(x, channelLabelY, 0, 0);
        UILabel *channelLabel = [[UILabel alloc] initWithFrame:labelFrame];
        channelLabel.userInteractionEnabled = YES;
        channelLabel.tag = idx;
        channelLabel.text = title;
        [channelLabel sizeToFit];
        
        /// 给label 添加tap 手势
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(channelClick:)];
        [channelLabel addGestureRecognizer:tap];
        
        [_channelLabelArray addObject:channelLabel];
        totalWidth += (channelLabel.width + marginTen);
        [_channelScrollView addSubview:channelLabel];
    }];
    [_channelScrollView setContentSize:CGSizeMake(totalWidth, 0)];
    
    /// MARK: 设置elf
    [self moveElfWithLabels:self.channelLabelArray index:0];
    
    [self.view addSubview:self.contentScrollView];
    
    /// MARK: 配置content
    [self.channelTitleArray enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        OLMindReportViewController *vc = [OLMindReportViewController new];
        vc.view.frame = CGRectMake(kScreenWidth * idx, 0, kScreenWidth, contentScrollViewHeight);
        [self addChildViewController:vc];
        [self.contentScrollView addSubview:vc.view];
    }];
    [_contentScrollView setContentSize:CGSizeMake(self.channelTitleArray.count * kScreenWidth, 0)];
}

#pragma mark - target
- (void)channelClick:(UIGestureRecognizer *)tap{
    _currentIndex = tap.view.tag;
    [self moveElfWithLabels:self.channelLabelArray index:_currentIndex];
    [self.contentScrollView setContentOffset:CGPointMake((_currentIndex * kScreenWidth), 0) animated:YES];
}

#pragma mark - scroll view delegate
- (void)scrollViewDidScroll:(UIScrollView *)scrollView{

}
- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView{
    if ([scrollView isEqual:self.contentScrollView]) {
        CGFloat contentOffsetX = scrollView.contentOffset.x;
        /// 获取当前页面滚动的索引
        NSInteger index = contentOffsetX / kScreenWidth;
        [self moveElfWithLabels:self.channelLabelArray index:index];
        _currentIndex = index;
    }
}

#pragma mark - getter
- (UIScrollView *)channelScrollView{
    if (_channelScrollView == nil) {
        _channelScrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, kNavHeight, kScreenWidth, channelScrollViewHeight)];
        _channelScrollView.showsHorizontalScrollIndicator = NO;
        _channelScrollView.delegate = self;
    }
    return _channelScrollView;
}
- (UIScrollView *)contentScrollView{
    if (_contentScrollView == nil) {
        _contentScrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, kNavHeight + channelScrollViewHeight, kScreenWidth, contentScrollViewHeight)];
        _contentScrollView.pagingEnabled = YES;
        _contentScrollView.delegate = self;
    }
    return _contentScrollView;
}

#pragma mark - 私有方法
/** 移动elf
 备注:如果efl为空，则初始化
 需要参数:频道中的lable数组，以及索引
 */
- (void)moveElfWithLabels:(NSArray *)channelLabels index:(NSInteger)index{
    UILabel *label = channelLabels[index];
    
    CGRect destiFrame = CGRectMake(label.x,
                                   CGRectGetMaxY(label.frame) + 6,
                                   label.width,
                                   2);
    
    /// 设置频道中label字体颜色
    label.textColor = [UIColor EDJMainColor];
    [channelLabels enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        UILabel *label = obj;
        if (!(idx == index)) {
            label.textColor = [UIColor blackColor];
        }
    }];
    
    if (_elf) {
        /// 移动elf
        [UIView animateWithDuration:0.3 animations:^{
            _elf.frame = destiFrame;
        }];
    }else{
        /// 创建elf
        UIView *elf = [[UIView alloc] initWithFrame:destiFrame];
        elf.backgroundColor = [UIColor EDJMainColor];
        [_channelScrollView addSubview:elf];
        _elf = elf;
    }
}

@end