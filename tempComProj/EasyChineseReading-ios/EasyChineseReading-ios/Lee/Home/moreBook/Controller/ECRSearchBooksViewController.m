//
//  ECRSearchBooksViewController.m
//  EasyChineseReading-ios
//
//  Created by lee on 2017/9/5.
//  Copyright © 2017年 lee. All rights reserved.
//

#import "ECRSearchBooksViewController.h"
#import "ECRSearchTitleView.h"
#import "ECRClassSortModel.h"
#import "ECRMoreBooksFooterView.h"

@interface ECRSearchBooksViewController ()<
ECRSearchTitleViewDelegate
>

@property (assign,nonatomic) BOOL first;//
@property (strong,nonatomic) UIButton *closeButton;//

@property (copy,nonatomic) void(^closeBlock)();//

@end

@implementation ECRSearchBooksViewController
@synthesize classModel = _classModel;

- (void)setClassModel:(ECRClassSortModel *)classModel{
    _classModel = classModel;
    [self setFilterObject:classModel.id forKey:0];
    // 获取 filterDict 中 key为0 的值(汉语读物,文化读物,互动教材3选1)
    NSString *monkeyId = [self objectForFilterDictWithKey:0];
    // 汉语读物(id425)为分类, 互动教材和文化读物为系列
    if (classModel.type == 1) {// 分类
        self.xilie = nil;
        [self.bookClassIds addObject:monkeyId];
        
    }
    if (classModel.type == 2) {// 系列
        self.bookClassIds = nil;
        [self.xilie addObject:monkeyId];
    }
    [self loadFilterData];
    if (self.first) {
        [self stView:nil content:self.searchName];
    }
}

// MARK: 搜索
- (void)stView:(ECRSearchTitleView *)view content:(NSString *)content{
    self.first = YES;
    // MARK: 根据content 开始搜索
    self.searchName = content;
    NSLog(@"content -- %@",self.searchName);
    NSString *classId;
    NSString *xilieId;
    if (self.xilie.count == 0) {
        if (self.classModel == nil) {
            classId = @"425";
        }else{
            xilieId = @"";
            classId = [self.bookClassIds componentsJoinedByString:@","];
        }
    }else{
        classId = @"0";
        xilieId = [self.xilie componentsJoinedByString:@","];
    }
    self.requestPage = 0;
//    NSLog(@"classid -- %@",classId);
//    NSLog(@"xilie -- %@",xilieId);
    // TODO: interface
    [[ECRDataHandler sharedDataHandler] bmListDataWithInterface:[self netInterface] special:nil series:xilieId classify:classId length:self.requestLength page:self.requestPage sort:self.requestSort searchName:self.searchName success:^(id object) {
        self.array = [NSMutableArray arrayWithArray:object];
        if (self.array.count == 0) {
            self.displayFooter = YES;
            [self presentFailureTips:LOCALIZATION(@"暂无数据")];
        }else{
            self.displayFooter = NO;
        }
        self.requestPage = self.array.count;
        NSLog(@"requestPage -- %ld",self.requestPage);
        [[NSOperationQueue mainQueue] addOperationWithBlock:^{
            [self.tableView.mj_header endRefreshing];
            self.tableView.hidden = NO;
            [self.tableView reloadData];
        }];
    } failure:^(NSString *msg) {
        self.tableView.hidden = YES;
        [self presentFailureTips:msg];
    } commenFailure:^(NSError *error) {
        self.tableView.hidden = YES;
        [self presentFailureTips:LOCALIZATION(@"链接失败, 请检查你的网络")];
    }];
}

// MARK: 加载更多数据
- (void)loadMoreListData{
    NSString *classId;
    NSString *xilieId;
    if (self.xilie.count == 0) {
        if (self.classModel == nil) {
            classId = @"0";
        }else{
            xilieId = @"";
            classId = [self.bookClassIds componentsJoinedByString:@","];
        }
    }else{
        classId = @"0";
        xilieId = [self.xilie componentsJoinedByString:@","];
    }
//    NSLog(@"classid -- %@",classId);
//    NSLog(@"xilie -- %@",xilieId);
    // TODO: interface
    [[ECRDataHandler sharedDataHandler] bmListDataWithInterface:[self netInterface] special:nil series:xilieId classify:classId length:self.requestLength page:self.requestPage sort:self.requestSort searchName:self.searchName success:^(id object) {
        NSArray *arr = object;
        if (arr == nil || arr.count == 0) {
            [self.tableView.mj_footer endRefreshingWithNoMoreData];
        }else{
            [self.tableView.mj_footer endRefreshing];
            [self.array addObjectsFromArray:arr];
        }
        self.requestPage += arr.count;
        NSLog(@"page_more -- %ld",self.requestPage);
        [[NSOperationQueue mainQueue] addOperationWithBlock:^{
            [self.tableView reloadData];
        }];
    } failure:^(NSString *msg) {
        [self.tableView.mj_footer endRefreshing];
    } commenFailure:^(NSError *error) {
        [self.tableView.mj_footer endRefreshing];
    }];
    
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self replaceTitleViewForSearch];// 设置搜索框
    [self setupUI];
    
}
- (void)setupUI{
    self.view.backgroundColor = [UIColor clearColor];
    
    [self.view addSubview:self.closeButton];
    [self.view addSubview:self.tableView];
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.view.mas_top);//.offset(7);
        make.left.equalTo(self.view.mas_left);
        make.right.equalTo(self.view.mas_right);
        make.bottom.equalTo(self.view.mas_bottom);
    }];
    // MARK: MJRefresh
    self.tableView.mj_footer = [MJRefreshAutoNormalFooter footerWithRefreshingTarget:self refreshingAction:@selector(loadMoreListData)];
    
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self.tableView registerNib:[UINib nibWithNibName:reuserID bundle:nil] forCellReuseIdentifier:reuserID];
    [self.tableView registerNib:[UINib nibWithNibName:rHeadID bundle:nil] forHeaderFooterViewReuseIdentifier:rHeadID];
    [self.tableView registerClass:[ECRMoreBooksFooterView class] forHeaderFooterViewReuseIdentifier:rFooterID];
    
    self.tableView.estimatedRowHeight = 0;
    self.tableView.estimatedSectionHeaderHeight = 0;
    self.tableView.estimatedSectionFooterHeight = 0;
    
    self.tableView.hidden = YES;
    self.first = NO;
    
}
- (void)clickCloseButton:(UIButton *)sender{
    [self.stv endEditing:YES];
    [self baseViewControllerDismiss];
}

// 重写不实现
- (void)setNavRighSearchItem{
    
}
#pragma mark - ECRSearchTitleViewDelegate
- (void)stViewClose:(ECRSearchTitleView *)view{
    [self.stv endEditing:YES];
    [self baseViewControllerDismiss];
}
- (void)scrollViewDidScroll:(UIScrollView *)scrollView{
    [self.stv endEditing:YES];
}
- (void)baseViewControllerDismiss{
    [super baseViewControllerDismiss];
    if (self.closeBlock) {
        self.closeBlock();
    }
}

//- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
//    return nil;
//}
//- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
//    return 0;
//}

- (UIButton *)closeButton{
    if (_closeButton == nil) {
        _closeButton = [[UIButton alloc] initWithFrame:self.view.bounds];
        [_closeButton setBackgroundColor:[UIColor blackColor]];
        _closeButton.alpha = 0.2;
        [_closeButton addTarget:self action:@selector(clickCloseButton:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _closeButton;
}

+ (CLMNavigationController *)searchBooksNav:(UIViewController *)vc closeBlock:(void(^)())closeBlock{
    ECRSearchBooksViewController *svc = [ECRSearchBooksViewController new];
    svc.openType = ECRMoreBookOpenTypeDefault;
    return [svc searchBooksNav:vc closeBlock:closeBlock];
}
- (CLMNavigationController *)searchBooksNav:(UIViewController *)vc closeBlock:(void(^)())closeBlock{
//    ECRSearchBooksViewController *scvc = [[ECRSearchBooksViewController alloc] init];
    self.classModel = [ECRClassSortModel defaultModel];
    self.viewControllerPushWay = ECRBaseControllerPushWayModal;
    CLMNavigationController *nav = [[CLMNavigationController alloc] initWithRootViewController:self];
    nav.modalTransitionStyle = UIModalTransitionStyleCrossDissolve;
    nav.modalPresentationStyle = UIModalPresentationOverCurrentContext;
    vc.definesPresentationContext = YES;
    self.closeBlock = closeBlock;
    return nav;
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
//    self.navigationController.navigationBar.barTintColor = [UIColor whiteColor];
}
- (void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
//    self.navigationController.navigationBar.barTintColor = [UIColor cm_purpleColor_82056B_1];
}

@end
