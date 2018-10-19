//
//  OLThreeMeetingsViewController.m
//  HBDJProj
//
//  Created by Peanut Lee on 2018/5/4.
//  Copyright © 2018年 Lee. All rights reserved.
//

#import "OLThreeMeetingsViewController.h"
#import "DJThreemeetListViewController.h"
#import "DJUploadThreeMeetingsTableViewController.h"

static CGFloat channelLabelY = 17;
static CGFloat channelScrollViewHeight = 51;

#define contentScrollViewHeight (kScreenHeight - channelScrollViewHeight - kNavHeight)

@interface OLThreeMeetingsViewController ()<
UIScrollViewDelegate,
DJOnlineUplaodTableViewControllerDelegate>
@property (strong,nonatomic) UIScrollView *channelScrollView;
@property (weak,nonatomic) UIView *elf;

@property (strong,nonatomic) UIScrollView *contentScrollView;
/** 频道栏 title 数组 */
@property (strong,nonatomic) NSArray *channelTitleArray;
/** 频道栏 lable数组 */
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
    
    /// 只有支部管理员才能创建三会一课和主题党日
    if (DJUser.sharedInstance.ismanager) {
        UIBarButtonItem *item_create = [[UIBarButtonItem alloc] initWithTitle:@"创建" style:UIBarButtonItemStyleDone target:self action:@selector(createContent)];
        self.navigationItem.rightBarButtonItem = item_create;
    }
    
    
    [self.view addSubview:self.channelScrollView];
    
    _channelLabelArray = [NSMutableArray new];
    
    /// 设置频道标题数组
    NSMutableArray *array = [NSMutableArray arrayWithArray:[DJUploadThreeMeetingsTableViewController tagStrings]];
    [array insertObject:@"全部" atIndex:0];
    self.channelTitleArray = array.copy;
    
    /// MARK: 配置channel
    __block CGFloat totalWidth;
    [self.channelTitleArray enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        NSString *title = obj;
        
        UILabel *lastLabel;
        CGFloat x;
        if (idx > 0) {
            lastLabel = _channelLabelArray[idx - 1];
            x = marginTwenty + CGRectGetMaxX(lastLabel.frame);
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
        totalWidth += (channelLabel.width + marginTwenty);
        [_channelScrollView addSubview:channelLabel];
    }];
    [_channelScrollView setContentSize:CGSizeMake(totalWidth, 0)];
    
    /// MARK: 设置elf
    [self moveElfWithLabels:self.channelLabelArray index:0];
    
    [self.view addSubview:self.contentScrollView];
    
    /// MARK: 配置content
    for (NSInteger i = 0; i < self.channelTitleArray.count; i++) {
        /// 三会一课列表控制器
        DJThreemeetListViewController *vc = DJThreemeetListViewController.new;
        vc.sessionType = i;
        /// 设置frame 会执行控制器的 viewdidload
        vc.view.frame = CGRectMake(kScreenWidth * i, 0, kScreenWidth, contentScrollViewHeight);
        [self addChildViewController:vc];
        [self.contentScrollView addSubview:vc.view];
    }

    [_contentScrollView setContentSize:CGSizeMake(self.channelTitleArray.count * kScreenWidth, 0)];
}

#pragma mark - target
- (void)channelClick:(UIGestureRecognizer *)tap{
    _currentIndex = tap.view.tag;
    [self moveElfWithLabels:self.channelLabelArray index:_currentIndex];
    [self.contentScrollView setContentOffset:CGPointMake((_currentIndex * kScreenWidth), 0) animated:YES];
}
- (void)createContent{
    /// MARK: 创建三会一课
    DJUploadThreeMeetingsTableViewController *olupvc = [[DJUploadThreeMeetingsTableViewController alloc] init];
    olupvc.delegate = self;
    [self.navigationController pushViewController:olupvc animated:YES];
}

- (void)threeMeetingOrThemeUploadDone{
    for (DJThreemeetListViewController *vc in self.childViewControllers) {
        [vc upload_reloadData];
    }
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
