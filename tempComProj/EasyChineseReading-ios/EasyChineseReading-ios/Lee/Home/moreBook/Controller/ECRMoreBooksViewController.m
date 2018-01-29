//
//  ECRMoreBooksViewController.m
//  EasyChineseReading-ios
//
//  Created by lee on 2017/8/30.
//  Copyright © 2017年 lee. All rights reserved.
//

static CGFloat filterHeight;// 筛选条件高度
static CGFloat listCellH        = 150;// 图示列表cell高度
static CGFloat sortCellH2 = 40;// MARK: 销量,价格,好评,行高

#import "ECRMoreBooksViewController.h"
#import "ECRSortTableViewController.h"
#import "ECRMoreBooksCell.h"
#import "ECRBookInfoModel.h"
#import "ECRClassSortModel.h"
#import "ECRHomeSortModel.h"
#import "UIView+Extension.h"
#import "ECRBookClassSortHeader.h"
#import "ECRSearchTitleView.h"
#import "ECRMoreBaseModel.h"
#import "ECRMoreRowModel.h"
#import "ECRClassSortModel.h"
#import "ECRBookInfoViewController.h"
#import "ECRSeriesModel.h"
#import "ECRRequestFailuredView.h"
#import "ECRMoreBooksFooterView.h"

@interface ECRMoreBooksViewController ()<
ECRSearchTitleViewDelegate,
ECRBookClassSortHeaderDelegate,
ECRSortTableViewControllerDelegate
>
/** 空数据view */
@property (strong,nonatomic) ECRRequestFailuredView *rrfv;
@property (strong,nonatomic) ECRSortTableViewController *stvc;
@property (strong,nonatomic) UIButton *halfBtn;//
@property (strong,nonatomic) ECRMoreBaseModel *mbModel;//
@property (strong,nonatomic) NSArray<ECRMoreRowModel *> *esb;//
@property (strong,nonatomic) NSArray<ECRMoreRowModel *> *cub;//
@property (strong,nonatomic) NSArray<ECRMoreRowModel *> *inb;//
@property (strong,nonatomic) NSArray<ECRMoreRowModel *> *filterArray;//

@property (strong,nonatomic) NSMutableDictionary *filterDict;//

/** 导航栏状态,搜索 = 1, 常规 = 0 */
@property (assign,nonatomic) BOOL navState;

@end

@implementation ECRMoreBooksViewController

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self navDisplay];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setupUI];
}

- (void)setSerialModel:(ECRSeriesModel *)serialModel{
    _serialModel = serialModel;
    [self.xilie addObject:[NSString stringWithFormat:@"%ld",serialModel.parent.id]];
    [self.xilie addObject:[NSString stringWithFormat:@"%ld",serialModel.serialId]];
}

// MARK: 通过接口 加载 filter（分类）
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
        
        __block BOOL notAdd = NO;
        [self.xilie enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            if ([obj isEqualToString:monkeyId]) {
                notAdd = YES;
            }
        }];
        if (!notAdd) {
            [self.xilie addObject:monkeyId];
        }
    }
    
    // 设置标题
    self.title = classModel.name;
    
    // 加载筛选条件数据
    if (_filterArray == nil) {
        [self loadFilterData];
    }else{
        [self setFilterData];
    }
    // 加载书籍list
    [self loadLisytData];
}

- (void)loadFilterData{
    [[ECRDataHandler sharedDataHandler] bmDataWithSuccess:^(id object) {
        ECRMoreBaseModel *mbModel = [ECRMoreBaseModel mj_objectWithKeyValues:object];
        mbModel.id = _classModel.id;
        self.mbModel = mbModel;
        self.esb = mbModel.esb;
        self.cub = mbModel.cub;
        self.inb = mbModel.inb;
        [self setFilterData];
    } failure:^(NSString *msg) {
        // TODO: 筛选条件请求失败
        /// 添加请求失败的header
        
    } commenFailure:^(NSError *error) {
        
    }];
}

- (void)loadLisytData{
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
    
    //    [self.tableView.mj_header beginRefreshing];
    self.requestPage = 0;
    NSLog(@"classid -- %@",classId);
    NSLog(@"xilie -- %@",xilieId);
//    NSLog(@"self.requestsort -- %ld",self.requestSort);
    [[ECRDataHandler sharedDataHandler] bmListDataWithInterface:[self netInterface] special:nil series:xilieId classify:classId length:self.requestLength page:self.requestPage sort:self.requestSort searchName:self.searchName success:^(id object) {
        self.array = [NSMutableArray arrayWithArray:object];
        NSLog(@"self.array -- %@",self.array);
        if (self.array.count == 0) {
            self.displayFooter = YES;
        }else{
            self.displayFooter = NO;
        }
        
        [[NSOperationQueue mainQueue] addOperationWithBlock:^{
            if (_halfBtn != nil) {
                [self.halfBtn removeFromSuperview];
                self.halfBtn = nil;
            }
            [self.tableView.mj_header endRefreshing];
            [self.tableView reloadData];
        }];
        self.requestPage = self.array.count;
        NSLog(@"page_more -- %ld",self.requestPage);
    } failure:^(NSString *msg) {
        self.requestPage = 0;
        [self.tableView.mj_header endRefreshing];
    } commenFailure:^(NSError *error) {
        self.requestPage = 0;
        [self.tableView.mj_header endRefreshing];
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
    [[ECRDataHandler sharedDataHandler] bmListDataWithInterface:[self netInterface] special:nil series:xilieId classify:classId length:self.requestLength page:self.requestPage sort:self.requestSort searchName:self.searchName success:^(id object) {
        //        NSLog(@"bookarray -- %@",object);
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

//    [self.tableView.mj_footer endRefreshing];// test
}


// 装载顶部筛选条件的数据
- (void)setFilterData{
    NSArray *arr;
    switch (self.classModel.id) {
        case 425:{// 汉语读物
            arr = self.esb;
        }
            break;
        case 446:{// 文化读物
            arr = self.cub;
            
        }
            break;
        case 447:{// 互动教材
            arr = self.inb;
        }
            break;
        default:{
            arr = self.esb;
        }
            break;
    }
    
    for (NSInteger i = 0; i < arr.count; i++) {
        ECRMoreRowModel *rowModel = arr[i];
        for (NSInteger j = 0; j < rowModel.classArray.count; j++) {
            ECRClassSortModel *classModel = rowModel.classArray[j];
            classModel.lg_isSelected = NO;
            if (classModel.id == self.classModel.id) {
                classModel.lg_isSelected = YES;
            }
            if (self.serialModel != nil) {
                if (classModel.id == self.serialModel.serialId) {
                    classModel.lg_isSelected = YES;
                }
            }
        }
    }
    self.filterArray = arr;
    
}
- (void)setFilterArray:(NSArray<ECRMoreRowModel *> *)filterArray{
    _filterArray = filterArray;
    filterHeight = filterArray.count * self.stvc.sortCellH;
    [[NSOperationQueue mainQueue] addOperationWithBlock:^{
        [self.tableView reloadData];
    }];
}


#pragma mark - ECRSearchTitleViewDelegate
- (void)stViewClose:(ECRSearchTitleView *)view{
    [self endSearching];
    self.navState = NO;
}
- (void)stView:(ECRSearchTitleView *)view content:(NSString *)content{
    // MARK: 根据content 开始搜索
    self.searchName = content;
    [self loadLisytData];
}

#pragma mark - ECRSortTableViewControllerDelegate
// MARK: 筛选条件点击事件
// 切换数据核心代码
- (void)stbController:(ECRSortTableViewController *)controller classModel:(ECRClassSortModel *)classModel rowModel:(ECRMoreRowModel *)rowModel indexPath:(NSIndexPath *)indexPath{
    if (classModel.parentId == 0) {// MARK: 切换分类 (点击 汉语读物,文化读物,互动教材)
        if (self.bookClassIds.count != 0) {
            [self.bookClassIds removeAllObjects];
        }
        if (self.array_all.count != 0) {
            [self.array_all removeAllObjects];
        }
        if (self.xilie.count != 0) {
            [self.xilie removeAllObjects];
        }
        [self.filterDict removeAllObjects];
        self.classModel = classModel;
    }else if(classModel.id == -1){// 点击全部
        if (rowModel.indexPath.item == 0) {// 点击 第一行 全部 --> 请求汉语读物 数据
            [self.filterDict removeAllObjects];
            [self.bookClassIds removeAllObjects];
            self.classModel = [ECRClassSortModel defaultModel];
        }else{
            if (classModel.type == 1) {// 分类
                // 点击分类
                // MARK: 点击分类全部
                
                BOOL isAdd = YES;// 默认添加 分类id
                for (NSIndexPath *index in self.array_all) {
                    if (index.item == rowModel.indexPath.item) {
                        isAdd = NO;// 代码执行此分支表示 该行的分类id已经全部添加至 bookClassIds
                    }
                }
                [rowModel.classArray enumerateObjectsUsingBlock:^(ECRClassSortModel * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
                    //           NSLog(@"%@ -- %ld",obj.name,obj.id);
                    if (obj.id == -1) {// 不添加"全部"
                        
                    }else{
                        if (isAdd) {
                            [self.bookClassIds addObject:[NSString stringWithFormat:@"%ld",obj.id]];
                        }else{
                            [self.bookClassIds removeObject:[NSString stringWithFormat:@"%ld",obj.id]];
                        }
                    }
                }];
                if (isAdd) {
                    [self.array_all addObject:rowModel.indexPath];
                }else{
                    [self.array_all removeObject:rowModel.indexPath];
                }
                [self.array_all enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
                    NSIndexPath *index = obj;
                    NSLog(@"index -- %ld",index.item);
                }];
            }
            if (classModel.type == 2) {// 系列
                // MARK: 点击系列全部
                if (self.xilie.count > 1) {
                    [self.xilie removeLastObject];
                }
                //            [self.xilie addObject:[NSString stringWithFormat:@"%ld",self.serialModel.serialId]];
            }
        }
        [self loadLisytData];
    }else{// 点击单个 分类 or 系列
        [self setFilterObject:classModel.id forKey:indexPath.row];
        if (classModel.type == 2) {// 系列
            // MARK: 点击单个系列
            BOOL isAdd = YES;// 默认添加
            for (NSInteger i = self.xilie.count - 1;i >= 0;i--) {
                NSString *classId = self.xilie[i];
                if ([classId integerValue] == classModel.id) {
                    [self.xilie removeObject:classId];
                    [self deteleFilterObjectForkey:indexPath.row];
                    isAdd = NO;// 如果数组中已经存在 分类id,表示点击取消该分类,则只删除此id,不做添加该分类id操作
                }else{
                }
            }
            if (isAdd) {
                [self.xilie removeAllObjects];
                [self.filterDict.allKeys enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
                    [self.xilie addObject:self.filterDict[obj]];
                }];
            }
        }
        if (classModel.type == 1) {// 分类
            // MARK: 点击单个分类
            //        NSLog(@"删除前 -- %@",self.bookClassIds);
            BOOL isAdd = YES;// 默认添加 分类id
            for (NSInteger i = self.bookClassIds.count - 1;i >= 0;i--) {
                NSString *classId = self.bookClassIds[i];
                if ([classId integerValue] == classModel.id) {
                    [self.bookClassIds removeObject:classId];
                    [self deteleFilterObjectForkey:indexPath.row];
                    isAdd = NO;// 如果数组中已经存在 分类id,表示点击取消该分类,则只删除此id,不做添加该分类id操作
                }else{
                }
            }
            if (isAdd) {
                [self.bookClassIds removeAllObjects];
                [self.filterDict.allKeys enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
                    [self.bookClassIds addObject:self.filterDict[obj]];
                }];
            }
        }
        [self loadLisytData];
    }
    
    [self.tableView reloadData];
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    CGFloat sectionHeaderHeight = filterHeight;
    if(scrollView.contentOffset.y<=sectionHeaderHeight&&scrollView.contentOffset.y>=0) {
        scrollView.contentInset = UIEdgeInsetsMake(-scrollView.contentOffset.y, 0, 0,0);
    } else if (scrollView.contentOffset.y>=sectionHeaderHeight) {
        scrollView.contentInset = UIEdgeInsetsMake(-sectionHeaderHeight, 0, 0, 0);
    }
}

#pragma mark - table view delegate
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return _array.count ? _array.count : 0;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    return [self reTable:tableView cellForRowAtIndexPath:indexPath];
}

- (UITableViewCell *)reTable:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    ECRMoreBooksCell *cell = [tableView dequeueReusableCellWithIdentifier:reuserID];
    cell.selectionStyle = UITableViewCellSeparatorStyleNone;
    cell.indexPath = indexPath;
    BookModel *model;
    if (_array.count) {
        model              = _array[indexPath.row];
    }
    cell.model             = model;
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return listCellH;
}
- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    ECRBookClassSortHeader *head = [tableView dequeueReusableHeaderFooterViewWithIdentifier:rHeadID];
//    head.contentView.backgroundColor = [UIColor whiteColor];
    head.stvc.delegate = self;
    head.rowModels = self.filterArray;
    head.delegate = self;
    return head;
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return filterHeight + sortCellH2;
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section{
    ECRMoreBooksFooterView *footer = [tableView dequeueReusableHeaderFooterViewWithIdentifier:rFooterID];
    footer.openType = self.openType;
    return footer;
}
- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    /// 屏幕高度 - header 的高度
    if (self.displayFooter) {
        return self.view.bounds.size.height - filterHeight - sortCellH2;
    }else{
        return 0;
    }
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [self reTableView:tableView didSelectRowAtIndexPath:indexPath];
}

- (void)reTableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [self lg_setNavTintColor];
    BookModel *model;
    if (_array.count) {
        model              = _array[indexPath.row];
    }
    [self userOnLine:^{
        UIStoryboard *board = [UIStoryboard storyboardWithName:@"BookInfo" bundle:nil];
        ECRBookInfoViewController *bivc = [board instantiateViewControllerWithIdentifier:@"ECRBookInfoViewController"];
        bivc.viewControllerPushWay = ECRBaseControllerPushWayPush;
        bivc.bookId = model.bookId;
        [self.navigationController pushViewController:bivc animated:YES];
    } offLine:nil];
    
}

#pragma mark - ECRBookClassSortHeaderDelegate
// MARK: 销量,好评,价格排序
- (void)bcsHeader:(ECRBookClassSortHeader *)header tag:(NSInteger)tag isDesOrder:(BOOL)isDesOrder{
    switch (tag) {
        case 0:// 销量
            if (isDesOrder) {
                // 销量 由高到低
                self.requestSort = 1;
            }else{
                // 销量 由低到高
                self.requestSort = 2;
            }
            break;
        case 1:// 价格
            if (isDesOrder) {// 高 --> 低
                self.requestSort = 3;
            }else{
                self.requestSort = 4;
            }
            break;
        case 2:// 好评
            if (isDesOrder) {
                self.requestSort = 5;
            }else{
                self.requestSort = 6;
            }
            break;
        case -1:{
            self.requestSort = 0;
            self.searchName = nil;
        }
            break;
        default:
            self.requestSort = 0;
            self.searchName = nil;
            break;
    }
    [self loadLisytData];
}


- (void)setupUI{
    self.navState = NO;
    self.displayFooter = NO;
    [self navDisplay];
    
    self.view.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:self.tableView];
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.view.mas_top);//.offset(7);
        make.left.equalTo(self.view.mas_left);
        make.right.equalTo(self.view.mas_right);
        make.bottom.equalTo(self.view.mas_bottom);
    }];
    // MARK: MJRefresh
    MJRefreshNormalHeader *header = [MJRefreshNormalHeader headerWithRefreshingTarget:self refreshingAction:@selector(loadLisytData)];

    header.lastUpdatedTimeLabel.hidden = YES;
    self.tableView.mj_header = header;
    
    self.tableView.mj_footer = [MJRefreshAutoNormalFooter footerWithRefreshingTarget:self refreshingAction:@selector(loadMoreListData)];
    
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self.tableView registerNib:[UINib nibWithNibName:reuserID bundle:nil] forCellReuseIdentifier:reuserID];
    [self.tableView registerNib:[UINib nibWithNibName:rHeadID bundle:nil] forHeaderFooterViewReuseIdentifier:rHeadID];
    [self.tableView registerClass:[ECRMoreBooksFooterView class] forHeaderFooterViewReuseIdentifier:rFooterID];

    self.tableView.estimatedRowHeight = 0;
    self.tableView.estimatedSectionHeaderHeight = 0;
    self.tableView.estimatedSectionFooterHeight = 0;
    
    // MARK: 设置导航栏右边搜索按钮
    [self setNavRighSearchItem];
    [self setSubView];
    
}
// 设置顶部搜索框
- (void)replaceTitleViewForSearch{
    // 设置 搜索 title view
    [UIView animateWithDuration:0.2 animations:^{
        self.navState = YES;
        [self navDisplay];
        
        self.navigationItem.titleView   = self.stv;
        self.navigationItem.rightBarButtonItem = nil;
        UIBarButtonItem *spaceBarButtonItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFixedSpace target:nil action:nil];
        spaceBarButtonItem.width = -4;
        self.navigationItem.leftBarButtonItems = @[spaceBarButtonItem];
        [self.navigationItem setHidesBackButton:YES];
    } completion:^(BOOL finished) {
        [self.stv lg_becomResponser];
    }];
}
- (ECRSearchTitleView *)stv{
    if (_stv == nil) {
        CGRect stRect                   = CGRectMake(0, 0, Screen_Width, 64);
        _stv = [[ECRSearchTitleView alloc] initWithFrame:stRect];
        _stv.delegate = self;
    }
    return _stv;
}
// 设置导航栏右侧搜索按钮
- (void)setNavRighSearchItem{
    UIBarButtonItem *rItem = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"icon_search"] style:UIBarButtonItemStyleDone target:self action:@selector(bookSearch:)];
    self.navigationItem.rightBarButtonItem = rItem;
    [self lg_setNavTintColor];
}
- (void)lg_setNavTintColor{
    self.navigationController.navigationBar.barTintColor = [LGSkinSwitchManager currentThemeColor];
}
- (void)bookSearch:(id)sender{
    [self addHalfAlphaButton];
    [self replaceTitleViewForSearch];
}
// 结束搜索状态
- (void)endSearching{
    // MARK: moreCallBack.关闭搜索
//    [self.halfBtn removeFromSuperview];
//    self.halfBtn = nil;
    [self.view endEditing:YES];
    [UIView animateWithDuration:0.2 animations:^{
        self.navigationItem.titleView = nil;
    }];
    [self createNavLeftBackItem];
    [self setNavRighSearchItem];
    self.searchName = nil;
    [self loadLisytData];
}

// 留给子界面重写或更新界面
- (void)setSubView{

}

- (void)settingsWithNumber:(NSInteger)number searchCallBack:(void(^)())searchCallBack moreCallBack:(void(^)())moreCallBack{
    switch (number) {
        case 1:
            if (searchCallBack) {
                searchCallBack();
            }
            break;
        case 4:
            if (moreCallBack) {
                moreCallBack();
            }
            break;
    }
}

- (ECRSortTableViewController *)stvc{
    if (_stvc == nil) {
        _stvc = [[ECRSortTableViewController alloc] init];
    }
    return _stvc;
}

- (UITableView *)tableView{
    if (_tableView == nil) {
        _tableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStylePlain];
        _tableView.dataSource      = self;
        _tableView.delegate        = self;
        _tableView.separatorStyle  = UITableViewCellSeparatorStyleNone;
    }
    return _tableView;
}

- (NSMutableArray *)bookClassIds{
    if (_bookClassIds == nil) {
        _bookClassIds = [NSMutableArray new];
    }
    return _bookClassIds;
}
- (NSMutableArray *)array_all{
    if (_array_all == nil) {
        _array_all = [NSMutableArray new];
    }
    return _array_all;
}
- (NSMutableArray *)xilie{
    if (_xilie == nil) {
        _xilie = [NSMutableArray new];
    }
    return _xilie;
}
- (NSMutableDictionary *)filterDict{
    if (_filterDict == nil) {
        _filterDict = [NSMutableDictionary new];
    }
    return _filterDict;
}

- (void)setFilterObject:(NSInteger)classModelId forKey:(NSInteger)modelRow{
    [self.filterDict setObject:[NSString stringWithFormat:@"%ld",classModelId] forKey:[NSString stringWithFormat:@"%ld",modelRow]];
}
- (id)objectForFilterDictWithKey:(NSInteger)number{
    return [self.filterDict objectForKey:[NSString stringWithFormat:@"%ld",number]];
}
- (void)deteleFilterObjectForkey:(NSInteger)number{
    [self.filterDict removeObjectForKey:[NSString stringWithFormat:@"%ld",number]];
}
- (NSInteger)requestLength{
    return 12;
}
//- (void)textDependsLauguage{
//    self.title = [LGPChangeLanguage localizedStringForKey:self.classModel.btnTitle];
//}

- (void)addHalfAlphaButton{
    UIButton *half = [[UIButton alloc] initWithFrame:self.view.bounds];
    half.backgroundColor = [UIColor colorWithRGB:0 alpha:0.2];
    [half addTarget:self action:@selector(halfBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:half];
    self.halfBtn = half;
}
- (void)halfBtnClick:(UIButton *)sender{
    [self endSearching];
}

- (void)navDisplay{

}
- (ECRRequestFailuredView *)rrfv{
    if (_rrfv == nil) {
        _rrfv = [ECRRequestFailuredView new];
        _rrfv.emptyType = ECRRFViewEmptyTypeClassifyNoData;
    }
    return _rrfv;
}

- (NSString *)netInterface{
    switch (self.openType) {
        case ECRMoreBookOpenTypeDefault:{
            return @"books/books";
        }
            break;
        case ECRMoreBookOpenTypeAccess:{
            return @"organization/selectOwendGrantBooks";
        }
            break;
        default:
            return @"books/books";
            break;
    }
}

- (void)setDisplayFooter:(BOOL)displayFooter{
    _displayFooter = displayFooter;
    if (displayFooter == YES) {
        self.tableView.mj_footer.hidden = YES;
    }else{
        self.tableView.mj_footer.hidden = NO;
    }
}

@end


