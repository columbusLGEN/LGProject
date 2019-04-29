//
//  TCMyBookrackViewController.m
//  TimeCollege
//
//  Created by Peanut Lee on 2019/4/15.
//  Copyright © 2019 lee. All rights reserved.
//

#import "TCMyBookrackViewController.h"
#import "TCMyCollectionViewController.h"
#import "TCMyBookSortView.h"
#import "TCMyBookSwitchSortWayView.h"

@interface TCMyBookrackViewController ()
@property (weak,nonatomic) UIImageView *shadowTop;
@property (strong,nonatomic) TCMyBookSortView *sortView;
@property (strong,nonatomic) TCMyBookSwitchSortWayView *sswView;

@end

@implementation TCMyBookrackViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self  configUI];

}

/** 搜索 */
- (void)searchMyBookrack{
    
}
/** 切换排序方式 */
- (void)switchSortWay:(UIButton *)sender{
    
    /// 1.userSortWay 记录用户上次选择的排序方式，保存在本地
    /// 2.载入画面时，取本地记录的数据
    /// 3.如果本地没有数据，默认按照 最近加入 排序
    /// 4.如果本地有数据，按照本地的排序方式
    NSNumber *sortWay = [NSUserDefaults.standardUserDefaults valueForKey:self.kMyBookSortWay];
    if (sortWay.integerValue == 0) {
        sortWay = @(1);
    }
    self.sswView.sortWay = sortWay.integerValue;
    [self.view addSubview:self.sswView];
    
    [self.sswView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.shadowTop.mas_top);
        make.left.right.bottom.equalTo(self.view);
        
    }];
}
/** 关闭切换排序方式view */
- (void)closeSSWView:(UIButton *)sender{
    [self.sswView removeFromSuperview];
}
/** 最近加入 排序 */
- (void)sortByAdd:(UIButton *)sender{
    [self.sswView removeFromSuperview];
    /// 修改本地数据
    /// 改变 sortView 以及 sswView 的排序方式属性
    [NSUserDefaults.standardUserDefaults setValue:@(TCMyBookSortWayAdd) forKey:self.kMyBookSortWay];
    self.sswView.sortWay = TCMyBookSortWayAdd;
    self.sortView.sortWay = TCMyBookSortWayAdd;
}
/** 最近阅读 排序 */
- (void)sortByRead:(UIButton *)sender{
    [self.sswView removeFromSuperview];
    [NSUserDefaults.standardUserDefaults setValue:@(TCMyBookSortWayRead) forKey:self.kMyBookSortWay];
    self.sswView.sortWay = TCMyBookSortWayRead;
    self.sortView.sortWay = TCMyBookSortWayRead;
}

- (void)configUI{
    ///
    self.title = @"我的书橱";
    /// 搜索按钮
    UIBarButtonItem *right = [UIBarButtonItem.alloc initWithImage:[UIImage imageNamed:@"icon_search_white"] style:UIBarButtonItemStyleDone target:self action:@selector(searchMyBookrack)];
    self.navigationItem.rightBarButtonItem = right;
    
    /// 取 我的书架排序方式
    NSNumber *sortWay = [NSUserDefaults.standardUserDefaults valueForKey:self.kMyBookSortWay];
    if (sortWay.integerValue == 0) {
        /// 默认按照 最近加入排序
        sortWay = @(1);/// TCMyBookSortWayAdd == 1 (TCMyBookSwitchSortWayView.h)
    }
    
    // 排序按钮
    TCMyBookSortView *sortView = TCMyBookSortView.new;
    sortView.sortWay = sortWay.integerValue;
    _sortView = sortView;
    [sortView.switchButton addTarget:self action:@selector(switchSortWay:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:sortView];
    
    // 上阴影
    UIImageView *shadowTop = [UIImageView.alloc initWithImage:[UIImage imageNamed:@"cyan_fade_down"]];
    [self.view addSubview:shadowTop];
    _shadowTop = shadowTop;
    // 下阴影
    UIImageView *shadowBottom = [UIImageView.alloc initWithImage:[UIImage imageNamed:@"cyan_fade_down"]];
    [self.view addSubview:shadowBottom];
    
    // 主视图
    TCMyCollectionViewController *mcvc = [TCMyCollectionViewController.alloc init];
//    NSLog(@"mcvc.collectionView: %@",mcvc.view);
    [self.view addSubview:mcvc.view];
    [self addChildViewController:mcvc];
    
    [sortView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.top.equalTo(self.view);
        make.height.mas_equalTo(50);
    }];
    [shadowTop mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(self.view);
        make.top.equalTo(sortView.mas_bottom);
        make.height.mas_equalTo(10);
    }];
    [shadowBottom mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(self.view);
        make.bottom.equalTo(self.view);
        make.height.mas_equalTo(10);
    }];
    
    [mcvc.view mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(self.view);
        make.top.equalTo(shadowTop.mas_bottom);
        make.bottom.equalTo(shadowBottom.mas_top);
    }];
    
    

}

- (TCMyBookSwitchSortWayView *)sswView{
    if (!_sswView) {
        _sswView = [TCMyBookSwitchSortWayView switchSortwayView];
        [_sswView.close addTarget:self action:@selector(closeSSWView:) forControlEvents:UIControlEventTouchUpInside];
        [_sswView.addRecently addTarget:self action:@selector(sortByAdd:) forControlEvents:UIControlEventTouchUpInside];
        [_sswView.readRecently addTarget:self action:@selector(sortByRead:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _sswView;
}

- (NSString *)kMyBookSortWay{
    NSString *userId = @"1";
    return [userId stringByAppendingString:@"_sortWay"];
}
@end
