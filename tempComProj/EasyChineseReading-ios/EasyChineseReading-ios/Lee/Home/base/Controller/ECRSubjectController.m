//
//  ECRSubjectController.m
//  EasyChineseReading-ios
//
//  Created by Peanut Lee on 2017/10/23.
//  Copyright © 2017年 retech. All rights reserved.
//

static NSString *reuserID = @"ECRSubjectCell";
static NSString *headerID = @"ECRSubjectHeaderView";
static NSString *reuseID_iPhone = @"ECRMoreBooksCell";

#import "ECRSubjectController.h"
#import "ECRSubjectView.h"
//#import "ECRSubjectRowModel.h"
#import "ECRRowObject.h"
#import "ECRSubjectModel.h"
#import "ECRSubjectCell.h"
#import "ECRBookInfoViewController.h"
#import "ECRThematicModel.h"
#import "ECRSubjectHeaderView.h"
#import "ECRMoreBooksCell.h"

@interface ECRSubjectController ()<
UITableViewDelegate,
UITableViewDataSource
>
@property (strong,nonatomic) NSMutableArray *rowModels;//
@property (strong,nonatomic) NSMutableArray *tempArray;// rowModels 的临时数组
/** iPhone 数据 */
@property (strong,nonatomic) NSMutableArray *models;

@property (strong,nonatomic) ECRSubjectView *sbv;//

@property (assign,nonatomic) CGFloat headerHeight;//
@property (assign,nonatomic) NSInteger reqLength;//
@property (assign,nonatomic) NSInteger reqPage;//

@end

@implementation ECRSubjectController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setupUI];

}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:NO animated:YES];
}

- (void)setupUI{
    [self.view addSubview:self.sbv];
    [[NSNotificationCenter defaultCenter]
     addObserver:self
     selector:@selector(subjectBookClickNotification:)
     name:ECRSubjectBookClickNotification object:nil];

    MJRefreshNormalHeader *rfHeader = [MJRefreshNormalHeader headerWithRefreshingTarget:self refreshingAction:@selector(loadNewData)];
    self.sbv.tableView.mj_header = rfHeader;
    
    MJRefreshAutoNormalFooter *rfFooter = [MJRefreshAutoNormalFooter footerWithRefreshingTarget:self refreshingAction:@selector(loadMoreData)];
    self.sbv.tableView.mj_footer = rfFooter;
    
    self.sbv.tableView.estimatedRowHeight = 0;
    self.sbv.tableView.estimatedSectionHeaderHeight = 0;
    self.sbv.tableView.estimatedSectionFooterHeight = 0;
    self.sbv.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    
    if (![ECRMultiObject userInterfaceIdiomIsPad]) {
        [self.sbv.tableView registerNib:[UINib nibWithNibName:reuseID_iPhone bundle:nil] forCellReuseIdentifier:reuseID_iPhone];
    }
}
// MARK: 请求数据
- (void)setModel:(ECRThematicModel *)model{
    _model = model;
    self.title = model.thematicName;
    [self loadNewData];
}
- (void)loadNewData{
    self.reqPage = 0;
    [self.tempArray removeAllObjects];
    self.tempArray = nil;
    [[ECRDataHandler sharedDataHandler] subjectDataWithSpecial:[NSString stringWithFormat:@"%ld",self.model.seqid] series:nil classify:nil length:self.reqLength page:self.reqPage sort:0 success:^(id object) {
        
        [self.sbv.tableView.mj_header endRefreshing];
        [self.sbv.tableView.mj_footer resetNoMoreData];
        
        /// 数据处理
        NSArray *arr = object;
        if ([ECRMultiObject userInterfaceIdiomIsPad]) {
            [arr enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
                ECRSubjectModel *model = [ECRSubjectModel mj_objectWithKeyValues:obj];
                //            NSLog(@"%@ -- %ld",model.bookName,model.bookId);
                [self.tempArray addObject:model];
            }];
            NSArray *deArr = [[ECRMultiObject sharedInstance] singleLineDoubleModelWithOriginArr:self.tempArray.copy];
            //        NSLog(@"dearr -- %@",deArr);
            
            self.rowModels = nil;
            self.rowModels = [NSMutableArray arrayWithArray:deArr];
            self.reqPage = self.tempArray.count;
        }else{
            [self.models removeAllObjects];
            self.models = nil;
            [arr enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
                ECRSubjectModel *model = [ECRSubjectModel mj_objectWithKeyValues:obj];
                //            NSLog(@"%@ -- %ld",model.bookName,model.bookId);
                [self.models addObject:model];
            }];
            self.reqPage = self.models.count;
        }
        
        [[NSOperationQueue mainQueue] addOperationWithBlock:^{
            [self.sbv.tableView reloadData];
        }];
    } failure:^(NSString *msg) {
        [self.sbv.tableView.mj_header endRefreshing];
    } commenFailure:^(NSError *error) {
        [self.sbv.tableView.mj_header endRefreshing];
    }];
}

- (void)loadMoreData{
//    NSLog(@"self.temparray -- %@",self.tempArray);
    [[ECRDataHandler sharedDataHandler] subjectDataWithSpecial:[NSString stringWithFormat:@"%ld",self.model.seqid] series:nil classify:nil length:self.reqLength page:self.reqPage sort:0 success:^(id object) {
        NSArray *arr = object;
        if (arr.count == 0 || arr == nil) {
            [self.sbv.tableView.mj_footer endRefreshingWithNoMoreData];
            [self presentFailureTips:LOCALIZATION(@"没有更多数据")];
            if (self.tempArray.count <= 8) {
                [[NSOperationQueue mainQueue] addOperationWithBlock:^{
                    [self.sbv.tableView setContentOffset:CGPointMake(0, 0) animated:YES];
                }];
            }

        }else{
            [self.sbv.tableView.mj_footer endRefreshing];
            if ([ECRMultiObject userInterfaceIdiomIsPad]) {
                [arr enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
                    ECRSubjectModel *model = [ECRSubjectModel mj_objectWithKeyValues:obj];
                    NSLog(@"%@ -- %ld",model.bookName,model.bookId);
                    [self.tempArray addObject:model];
                }];
                self.reqPage = self.tempArray.count;
                //        if (self.tempArray.count == 27) {
                //            [self.sbv.tableView.mj_footer endRefreshingWithNoMoreData];
                //        }
                
                NSArray *deArr = [[ECRMultiObject sharedInstance] singleLineDoubleModelWithOriginArr:self.tempArray.copy];
                self.rowModels = [NSMutableArray arrayWithArray:deArr];
            }else{
                [arr enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
                    ECRSubjectModel *model = [ECRSubjectModel mj_objectWithKeyValues:obj];
                    //            NSLog(@"%@ -- %ld",model.bookName,model.bookId);
                    [self.models addObject:model];
                }];
                self.reqPage = self.models.count;
            }
            
            [[NSOperationQueue mainQueue] addOperationWithBlock:^{
                [self.sbv.tableView reloadData];
            }];
        }
        
    } failure:^(NSString *msg) {
        [self.sbv.tableView.mj_footer endRefreshing];
    } commenFailure:^(NSError *error) {
        [self.sbv.tableView.mj_footer endRefreshing];
    }];
}

// MARK: 点击书籍的通知
- (void)subjectBookClickNotification:(NSNotification *)notification{
    [self userOnLine:^{
        NSDictionary *userInfo = notification.userInfo;
        ECRSubjectModel *model = userInfo[@"model"];
        [self jumpToBookInfoWithModel:model];
    } offLine:nil];

}

#pragma mark - table view data source & delegate
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if ([ECRMultiObject userInterfaceIdiomIsPad]) {
        return self.rowModels.count;
    }else{
        return self.models.count;
    }
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    if ([ECRMultiObject userInterfaceIdiomIsPad]) {
        ECRSubjectCell *cell = [tableView dequeueReusableCellWithIdentifier:reuserID];
        ECRRowObject *rowModel = self.rowModels[indexPath.row];
        cell.rowModel = rowModel;
        return cell;
    }else{
        ECRMoreBooksCell *cell = [tableView dequeueReusableCellWithIdentifier:reuseID_iPhone];
        ECRSubjectModel *model = self.models[indexPath.row];
        cell.model = model;
        return cell;
    }
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if ([ECRMultiObject userInterfaceIdiomIsPad]) {
        ECRSubjectCell *cell = [tableView dequeueReusableCellWithIdentifier:reuserID];
        return cell.cellHeight;
    }else{
        return 180;
    }
}
- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    ECRSubjectHeaderView *header = [tableView dequeueReusableHeaderFooterViewWithIdentifier:headerID];
    header.imgURL = self.model.templetimg;
    return header;
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return self.headerHeight;
}
- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    CGFloat sectionHeaderHeight = self.headerHeight;
    if(scrollView.contentOffset.y<=sectionHeaderHeight&&scrollView.contentOffset.y>=0) {
        scrollView.contentInset = UIEdgeInsetsMake(-scrollView.contentOffset.y, 0, 0,0);
    } else if (scrollView.contentOffset.y>=sectionHeaderHeight) {
        scrollView.contentInset = UIEdgeInsetsMake(-sectionHeaderHeight, 0, 0, 0);
    }
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    ECRSubjectModel *model;
    if (self.models.count) {
        model = self.models[indexPath.row];
        [self jumpToBookInfoWithModel:model];
    }
}

// MARK: 跳转至详情
- (void)jumpToBookInfoWithModel:(ECRSubjectModel *)model{
    UIStoryboard *board = [UIStoryboard storyboardWithName:@"BookInfo" bundle:nil];
    ECRBookInfoViewController *bivc = [board instantiateViewControllerWithIdentifier:@"ECRBookInfoViewController"];
    bivc.bookId = model.bookId;
    bivc.viewControllerPushWay = ECRBaseControllerPushWayPush;
    [self.navigationController pushViewController:bivc animated:YES];
}

- (ECRSubjectView *)sbv{
    if (_sbv == nil) {
        _sbv = [[ECRSubjectView alloc] initWithFrame:self.view.bounds];
        _sbv.tableView.dataSource = self;
        _sbv.tableView.delegate = self;
        [_sbv.tableView registerNib:[UINib nibWithNibName:reuserID bundle:nil] forCellReuseIdentifier:reuserID];
        [_sbv.tableView registerNib:[UINib nibWithNibName:headerID bundle:nil] forHeaderFooterViewReuseIdentifier:headerID];
    }
    return _sbv;
}
- (CGFloat)headerHeight{
    if ([[ECRMultiObject sharedInstance] userInterfaceIdiom] == UIUserInterfaceIdiomPad) {
        return 240;
    }else{
        return 180;
    }
}
- (void)dealloc{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (NSInteger)reqLength{
    return 12;
}
- (NSMutableArray *)rowModels{
    if (_rowModels == nil) {
        _rowModels = [NSMutableArray new];
    }
    return _rowModels;
}
- (NSMutableArray *)tempArray{
    if (_tempArray == nil) {
        _tempArray = [NSMutableArray new];
    }
    return _tempArray;
}

- (NSMutableArray *)models{
    if (_models == nil) {
        _models = [NSMutableArray new];
    }
    return _models;
}


@end


/**
     ECRSubjectView --> 主view
     ECRSubjectCell --> 一个cell 有两个 或者 一个 ECRSubjectSingleView
     ECRSubjectSingleView  --> 一本书
 
 */
