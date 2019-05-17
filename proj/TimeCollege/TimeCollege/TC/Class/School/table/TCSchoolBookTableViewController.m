//
//  TCSchoolBookTableViewController.m
//  TimeCollege
//
//  Created by Peanut Lee on 2019/4/17.
//  Copyright © 2019 lee. All rights reserved.
//

#import "TCSchoolBookTableViewController.h"
#import "TCSchoolBookTableViewCell.h"
#import "TCBookDetailManagerController.h"

#import "TCListHeaderTableViewController.h"
#import "TCBookCatagoryLineModel.h"

static NSString * const sbTableViewCell = @"TCSchoolBookTableViewCell";

@interface TCSchoolBookTableViewController ()
/// FLT --> 分类头部视图
@property (strong,nonatomic) TCListHeaderTableViewController *lhvc;
@property (strong,nonatomic) UIView *lhView;
/** 当前已经有二级分类展示在页面上 */
@property (assign,nonatomic) BOOL hasSecondery;

@end

@implementation TCSchoolBookTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self configUI];
    
}

- (void)configUI{
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.view);
    }];
    [self.tableView registerNib:[UINib nibWithNibName:sbTableViewCell bundle:nil] forCellReuseIdentifier:sbTableViewCell];
    
//    self.tableView.mj_header = nil;
//    self.tableView.mj_footer = nil;
    
    /// 0
    UIView *lhView = [UIView.alloc initWithFrame:CGRectZero];
    _lhView = lhView;
    
    /// 分类头部视图 FLT
    /// FLT.1.
    self.lhvc = TCListHeaderTableViewController.new;
    
    /// FLT.2 获取数据(网络请求)
    NSArray *lhArray = [TCBookCatagoryLineModel loadLocalPlistWithPlistName:@"fenleiTest"];
    
    /// FLT.2 根据数据行数,重新计算高度,刷新UI
    CGFloat lhHeight = lhArray.count * 40;
    
    lhView.frame = CGRectMake(0, 0, Screen_Width, lhHeight);
    [lhView addSubview:self.lhvc.view];
    [self.lhvc.view mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(lhView);
    }];
    self.tableView.tableHeaderView = lhView;
    
    self.lhvc.array = lhArray;
    
    [NSNotificationCenter.defaultCenter addObserver:self selector:@selector(listFenleiClick:) name:kNotificationListFenleiClick object:nil];
}

// MARK: 二级分类的展示 or 隐藏
- (void)listFenleiClick:(NSNotification *)notification{
    /// 初始化新数组
    NSMutableArray *arrmu = [NSMutableArray arrayWithArray:self.lhvc.array];
    
    /// 获取分类数组
    /// 分类本身
    TCQuadrateModel *quadrateModel = notification.userInfo[kNotificationListFenleiClickInfoOrigin];
    /// 二级分类
    TCBookCatagoryLineModel *lineModel = notification.userInfo[kNotificationListFenleiClickInfoSecondery];
    
    if (lineModel.isSecondery) {
        /// 选中 二级分类
        if (lineModel.showSeconndery) {
            /// 展示二级分类
            if (self.hasSecondery) {
                /// 替换当前二级页面
                [arrmu replaceObjectAtIndex:1 withObject:lineModel];
            }else{
                /// 新增二级页面
                [arrmu insertObject:lineModel atIndex:1];
                self.hasSecondery = YES;
            }
            
            
        }else{
            /// 隐藏二级分类
            if (self.hasSecondery) {
                [arrmu removeObjectAtIndex:1];
                self.hasSecondery = NO;
            }
        }
        
    }else{
        /// 普通选中
        
    }

    /// 重新计算高度 & 刷新UI
    CGFloat lhHeight = (arrmu.count - 1) * 40 + 30;
    _lhView.frame = CGRectMake(0, 0, Screen_Width, lhHeight);
    self.tableView.tableHeaderView = _lhView;

    /// 重新赋值
    self.lhvc.array = arrmu.copy;
}
// MARK: 接收数据
- (void)setArray:(NSArray *)array{
    [super setArray:array];
    
}

- (void)headerRefresh{
    [super headerRefresh];
    // MARK: 获取数据(下拉刷新)
    
    
    [self stopRefreshAnimate];
}
- (void)footerRefresh{
    self.currentPage += 1;
    // MARK: 上拉获取数据
    [self stopRefreshAnimate];
    
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 20;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    TCSchoolBookTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:sbTableViewCell forIndexPath:indexPath];
    cell.index = indexPath;
    [cell index:indexPath firstCellHiddenLine:self.firstCellHiddenLine];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    TCBookDetailManagerController *bdvc = [TCBookDetailManagerController new];
    bdvc.detailType = self.listType;
    [self.navigationController pushViewController:bdvc animated:YES];
}

- (void)dealloc{
    [NSNotificationCenter.defaultCenter removeObserver:self];
}

@end
