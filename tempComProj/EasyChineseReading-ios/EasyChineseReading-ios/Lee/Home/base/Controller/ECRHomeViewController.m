//
//  ECRHomeViewController.m
//  EasyChineseReading-ios
//
//  Created by lee on 2017/8/29.
//  Copyright © 2017年 lee. All rights reserved.
//

static NSString *bcCell = @"ECRBookClassesCollectionCell";
static NSString *brCell = @"ECRHomeBRCell";
static NSString *rmCell = @"ECRHomeRMCell";
static NSString *rmCell_iPad = @"ECRHomeRMIpadCell";
static NSString *sbvCell = @"ECRHomeSBVCell";

#import "ECRHomeViewController.h"
#import "ECRHomeMainModel.h"// 主view model
#import "ECRHomeMainView.h"// 主 view
#import "ECRHomeTitleView.h"// title view
#import "ECRMoreBooksViewController.h"// 更多
#import "ECRShoppingCarViewController.h"// 购物车
#import "ECRSearchBooksViewController.h"
#import "ECRBookInfoViewController.h"
#import "ECRBookClasses.h"
#import "ECRBoomRecomment.h"
#import "ECRSeriesAera.h"
#import "ECRSeriesBooksView.h"
#import "ECRReadMonster.h"
#import "ECRBookClassesCollectionCell.h"
#import "ECRHomeBRCell.h"
#import "ECRHomeRMCell.h"
#import "ECRHomeSBVCell.h"
#import "ECRLocationManager.h"
#import "ECRDataHandler.h"
#import "ECRHomeBook.h"
#import "ECRHeadlineView.h"
#import "ECRSeriesModel.h"
#import "ECRThemeAera.h"
#import "ECRThematicModel.h"
#import "ECRRankUser.h"
#import "ECRSubjectController.h"
#import "ECRRequestFailuredView.h"
#import "ECRClassSortModel.h"
#import "ECRHomeRMIpadCell.h"
#import "ECRRowObject.h"
#import "ECRHomeTitleCountryNameView.h"
#import "ECRBaseWkViewController.h"
#import "ECRAdvModel.h"
#import "ECRHome.h"
#import "UFriendInfoVC.h"
#import "ECRMentionBoy.h"
#import "LGCartIcon.h"
#import "ECRShoppingCarManager.h"
#import "GuideFigureImageView.h"

@interface ECRHomeViewController ()<
ECRHomeTitleViewDelelgate,
ECRHomeMainViewDelegate,
UICollectionViewDataSource,
UICollectionViewDelegate,
UITableViewDataSource,
UITableViewDelegate,
ECRThemeAeraDelegate,
ECRRequestFailuredViewDelegate,
ECRHomeTitleCountryNameViewDelegate
>

@property (strong,nonatomic) ECRRequestFailuredView *rrfv;//
@property (strong,nonatomic) ECRHomeTitleView *tView;//
@property (strong,nonatomic) ECRHomeMainView *mainView;
@property (strong,nonatomic) NSMutableArray *hcnModels;// 分类数组(汉语读物等)
@property (strong,nonatomic) NSArray *reco;// 推荐书籍
// 系列专区数据源
@property (strong,nonatomic) NSArray *sfArr;//
@property (strong,nonatomic) NSArray *ssArr;// ssArr
@property (strong,nonatomic) NSArray *stArr;// stArr
// 阅读达人榜
@property (strong,nonatomic) NSArray *rmArr;//
@property (assign,nonatomic) BOOL isSearch;//
@property (strong,nonatomic) MBProgressHUD *loadDataHUD;//

@end

@implementation ECRHomeViewController

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    // if 搜索
    if (self.isSearch) {
        [self.navigationController setNavigationBarHidden:YES animated:NO];
    }else{
        // else
        [self.navigationController setNavigationBarHidden:YES animated:YES];
    }
    [self userOnLine:^{
        [ECRShoppingCarManager loadCartCount:^(NSInteger count) {
            self.tView.cartButton.cartCount = count;
        }];
    } offLine:^{
        
    }];
}
- (void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    [self.navigationController setNavigationBarHidden:NO animated:YES];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setupUI];
}

- (void)setupUI{
//    self.automaticallyAdjustsScrollViewInsets = NO;
    self.view.backgroundColor = [UIColor whiteColor];
    
    [self.view addSubview:self.mainView];
    [self.view addSubview:self.tView];
    
    [self rg_locatedWithBlock:^(NSString *countryName) {
       // 定位之后的回调
        self.tView.title = countryName;
    }];
    
    /// 添加刷新header
    MJRefreshNormalHeader *mjnHeader = [MJRefreshNormalHeader headerWithRefreshingTarget:self refreshingAction:@selector(loadNewData)];
    self.mainView.scrollView.mj_header = mjnHeader;
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(ruClickNotification:) name:LGPRankUserClickNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(tabBarClickNotification:) name:ECRHomeSwitchAniNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(serailClick:) name:ECRHomeSerialClickNotification object:nil];
    [self.mainView.scrollView.mj_header beginRefreshing];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(changeUI:) name:kNotificationChangeHomeUI object:nil];
    
    if (![[CacheDataSource sharedInstance] loadCacheWithCacheKey:CacheKey_NotFirstTimeBookStore]) {
        [self loadGuideFigure];
    }
}

/** 引导图 */
- (void)loadGuideFigure
{
    GuideFigureImageView *imageV = [[GuideFigureImageView alloc] initWithFrame:CGRectMake(0, 0, Screen_Width, Screen_Height)];
    imageV.itemIndex = 0;
    
    UIWindow *window = [UIApplication sharedApplication].keyWindow;
    [window addSubview:imageV];
}

- (void)changeUI:(NSNotification *)notification{
//    NSNumber *type = notification.userInfo[kNotificationChangeHomeUIKey];
    [self.mainView.bookClasses.collectionView reloadData];
//    switch (type.integerValue) {
//        case ECRHomeUITypeDefault:{
//
//        }
//            break;
//        case ECRHomeUITypeKidOne:{
//
//        }
//            break;
//    }
}
// MARK: 请求数据
- (void)loadNewData{
//    self.mainView.hidden = YES;
    self.loadDataHUD = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    [self.view addSubview:self.loadDataHUD];
    self.loadDataHUD.mode = MBProgressHUDModeIndeterminate;
    [[ECRDataHandler sharedDataHandler] homeDataWithSuccess:^(ECRHomeMainModel *model) {
        [self.loadDataHUD hideAnimated:YES];
        [self.mainView.scrollView.mj_header endRefreshing];
        self.mainView.hidden = NO;
        self.tView.hidden = NO;
        _mainView.model = model;
        
        // 分类
        // 过滤多余的数据
        if (model.SeriesClassif.count > 3) {
            for (NSInteger i = model.SeriesClassif.count - 1; i >= 0 ; i--) {
                ECRClassSortModel *csModel = model.SeriesClassif[i];
                if (csModel.id == 425) {
                }else if(csModel.id == 446){
                }else if(csModel.id == 447){
                }else{
                    [model.SeriesClassif removeObjectAtIndex:i];
                }
            }
        }
        self.hcnModels = [NSMutableArray arrayWithArray:model.SeriesClassif];
        NSString *arrPath = [[NSBundle mainBundle] pathForResource:@"HomeClassNames" ofType:@"plist"];
        NSArray *array = [NSArray arrayWithContentsOfFile:arrPath];
        for (NSInteger i = 0; i < array.count; ++i) {
            if (i == (array.count - 1)) {
                ECRClassSortModel *model = [ECRClassSortModel mj_objectWithKeyValues:array[i]];
                model.type = 1;
                [self.hcnModels addObject:model];
            }
        }
        
        // 推荐书籍
        self.reco = model.reco;
        // 系列专区
//        self.mainView.seriesAera.seriesModels = model.Series;
        for (NSInteger i = 0; i < model.Series.count; i++) {
            ECRSeriesModel *seriesModel = model.Series[i];
            // 0 1 2
            switch (i) {
                case 0:
                    self.sfArr = seriesModel.books;
                    self.mainView.seriesAera.viewFirst.model = seriesModel;
                    break;
                case 1:
                    self.ssArr = seriesModel.books;
                    self.mainView.seriesAera.viewSecond.model = seriesModel;
                    break;
                case 2:
                    self.stArr = seriesModel.books;
                    self.mainView.seriesAera.viewThird.model = seriesModel;
                    break;
            }
        }
        // 专题
        self.mainView.themeAera.models = model.thematic;
        [model.Rank enumerateObjectsUsingBlock:^(ECRRankUser * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            obj.indexInArray = idx;
        }];
        // 阅读达人榜
        if ([ECRMultiObject userInterfaceIdiomIsPad]) {
            self.rmArr = [[ECRMultiObject sharedInstance] singleLineDoubleModelWithOriginArr:model.Rank];
        }else{
            self.rmArr = model.Rank;
        }
        
        [[NSOperationQueue mainQueue] addOperationWithBlock:^{
            [self.mainView.bookClasses.collectionView reloadData];
            [self.mainView.boomRecomment.collectionView reloadData];
            [self.mainView.seriesAera.viewFirst.collectionView reloadData];
            [self.mainView.seriesAera.viewSecond.collectionView reloadData];
            [self.mainView.seriesAera.viewThird.collectionView reloadData];
            [self.mainView.readMonster.tableView reloadData];
            [self.rrfv removeFromSuperview];
            _rrfv = nil;
        }];
        
    } failure:^(NSString *msg) {
        [self.mainView.scrollView.mj_header endRefreshing];
        [self addRequestFailuredView];
        [self.loadDataHUD hideAnimated:YES];
        self.tView.hidden = NO;
    } commenFailure:^(NSError *error) {
        [self.mainView.scrollView.mj_header endRefreshing];
        [self addRequestFailuredView];
        [self.loadDataHUD hideAnimated:YES];
        self.tView.hidden = NO;
    }];

}

- (void)addRequestFailuredView{
    self.mainView.hidden = YES;
    // MARK: 添加请求错误view
    if (_rrfv == nil) {
        [self.view addSubview:self.rrfv];
    }
}

#pragma mark - ECRRequestFailuredViewDelegate 错误请求代理
- (void)rfViewReloadData:(ECRRequestFailuredView *)view eType:(ECRRFViewEmptyType)etype{
    [self loadNewData];
}

#pragma mark - UICollectionViewDataSource
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    if ([collectionView isEqual:self.mainView.bookClasses.collectionView]) {
        return self.hcnModels.count;
    }
    if ([collectionView isEqual:self.mainView.boomRecomment.collectionView]) {
        return self.reco.count;
    }
//    if ([collectionView isEqual:self.mainView.seriesAera.viewFirst.collectionView] ||
//        [collectionView isEqual:self.mainView.seriesAera.viewThird.collectionView]) {
//        if (Screen_Width < 375) {
//            return 2;
//        }else{
//            return 3;
//        }
//    }
    if ([collectionView isEqual:self.mainView.seriesAera.viewFirst.collectionView]) {
        return self.sfArr.count;
    }
    if ([collectionView isEqual:self.mainView.seriesAera.viewSecond.collectionView]) {
        return self.ssArr.count;
    }
    if ([collectionView isEqual:self.mainView.seriesAera.viewThird.collectionView]) {
        return self.stArr.count;
    }
    return 0;
}
- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    if ([collectionView isEqual:self.mainView.bookClasses.collectionView]) {
        ECRBookClassesCollectionCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:bcCell forIndexPath:indexPath];
        ECRClassSortModel *model = self.hcnModels[indexPath.item];
        cell.indexPath = indexPath;
        cell.model = model;
        return cell;
    }
    if ([collectionView isEqual:self.mainView.boomRecomment.collectionView]) {
        ECRHomeBRCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:brCell forIndexPath:indexPath];
        ECRHomeBook *recoModel = self.reco[indexPath.item];
        cell.model = recoModel;
        return cell;
    }
    if ([collectionView isEqual:self.mainView.seriesAera.viewFirst.collectionView]) {
        ECRHomeSBVCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:sbvCell forIndexPath:indexPath];
        ECRHomeBook *saBook = self.sfArr[indexPath.item];
        cell.model = saBook;
        return cell;
    }
    if ([collectionView isEqual:self.mainView.seriesAera.viewSecond.collectionView]) {
        ECRHomeSBVCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:sbvCell forIndexPath:indexPath];
        ECRHomeBook *saBook = self.ssArr[indexPath.item];
        cell.model = saBook;
        return cell;

    }
    if ([collectionView isEqual:self.mainView.seriesAera.viewThird.collectionView]) {
        ECRHomeSBVCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:sbvCell forIndexPath:indexPath];
        ECRHomeBook *saBook = self.stArr[indexPath.item];
        cell.model = saBook;
        return cell;

    }
    return nil;
}
- (void)mbvcWithModel:(ECRClassSortModel *)model serialModel:(ECRSeriesModel *)serailModel{
    self.isSearch = NO;
    ECRMoreBooksViewController *mbvc = [[ECRMoreBooksViewController alloc] init];
    mbvc.openType = ECRMoreBookOpenTypeDefault;
    if (serailModel == nil) {
        mbvc.classModel = model;
    }else{
        mbvc.serialModel = serailModel;
        mbvc.classModel = serailModel.parent;
    }
    mbvc.viewControllerPushWay = ECRBaseControllerPushWayPush;
    [self.navigationController pushViewController:mbvc animated:YES];
}

// MARK: 跳转至系列(分类页面选中系列)
- (void)serailClick:(NSNotification *)notification{
    ECRSeriesModel *serialModel = notification.userInfo[ECRHomeSerialClickKey];
//    NSLog(@"turntoxilie -- %@ id -- %ld",serialModel.serialName,serialModel.serialId);
    [self mbvcWithModel:nil serialModel:serialModel];
}

#pragma mark - UICollectionViewDelegate
- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    if ([collectionView isEqual:self.mainView.bookClasses.collectionView]) {
        // MARK: 进入分类页面
        ECRClassSortModel *model = self.hcnModels[indexPath.item];
        [self mbvcWithModel:model serialModel:nil];
    }else{
        ECRHomeBook *book;
        if ([collectionView isEqual:self.mainView.boomRecomment.collectionView]) {
            book = self.reco[indexPath.item];
        }
        if ([collectionView isEqual:self.mainView.seriesAera.viewFirst.collectionView]) {
            book = self.sfArr[indexPath.item];
        }
        if ([collectionView isEqual:self.mainView.seriesAera.viewSecond.collectionView]) {
            book = self.ssArr[indexPath.item];
        }
        if ([collectionView isEqual:self.mainView.seriesAera.viewThird.collectionView]) {
            book = self.stArr[indexPath.item];
        }
        
        // MARK: 进入详情页面
        self.isSearch = NO;
        UIStoryboard *board = [UIStoryboard storyboardWithName:@"BookInfo" bundle:nil];
        ECRBookInfoViewController *bivc = [board instantiateViewControllerWithIdentifier:@"ECRBookInfoViewController"];
        bivc.viewControllerPushWay = ECRBaseControllerPushWayPush;
        bivc.bookId = book.bookId;
        [self.navigationController pushViewController:bivc animated:YES];
        
    }
}

#pragma mark - scrolview delegate
- (void)scrollViewDidScroll:(UIScrollView *)scrollView{
    CGFloat offsetY = scrollView.contentOffset.y;
//        NSLog(@"offsety -- %f",offsetY);
    if ([scrollView isEqual:self.mainView.scrollView]) {
        if (offsetY < self.lg_scrollView_offsetY) {
            self.tView.hidden = YES;
        }else if (offsetY > 0){
            self.tView.hidden = NO;
            self.tView.bgdsState = ECRHomeTitleViewBgdsStateSolid;
        }else{
            self.tView.bgdsState = ECRHomeTitleViewBgdsStateDefault;
            self.tView.hidden = NO;
        }
    }
}
- (CGFloat)lg_scrollView_offsetY{
    if ([ECRMultiObject isiPhoneX]) {
        return -44;
    }
    return -20;
}
#pragma mark - UITableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.rmArr.count;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    if ([tableView isEqual:self.mainView.readMonster.tableView]) {
        if ([ECRMultiObject userInterfaceIdiomIsPad]) {
            ECRHomeRMIpadCell *cell = [tableView dequeueReusableCellWithIdentifier:rmCell_iPad forIndexPath:indexPath];
            ECRRowObject *rowModel = self.rmArr[indexPath.row];
            cell.rowModel = rowModel;
            return cell;
        }else{
            ECRHomeRMCell *cell = [tableView dequeueReusableCellWithIdentifier:rmCell forIndexPath:indexPath];
            ECRRankUser *model = self.rmArr[indexPath.row];
            cell.model = model;
            return cell;
        }
    }
    return nil;
}

#pragma mark - UITableViewDelegate
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if ([ECRMultiObject userInterfaceIdiomIsPad]) {
        ECRHomeRMIpadCell *cell = [tableView dequeueReusableCellWithIdentifier:rmCell_iPad];
        
        return cell.cellHeight;
    }else{
        ECRHomeRMCell *cell = [tableView dequeueReusableCellWithIdentifier:rmCell];
        
        return cell.cellHeight;
    }
//    return 0;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    if ([tableView isEqual:self.mainView.readMonster.tableView]) {
        ECRRankUser *model;
        if (self.rmArr.count) {
            model = self.rmArr[indexPath.row];
            [self jumpToUserInfoWithMode:model];
        }
    }
}

#pragma mark - ECRHomeMainViewDelegate
- (void)hmClickAdView:(ECRHomeMainView *)view model:(ECRAdvModel *)model{
    // MARK: 打开轮播广告
    self.isSearch = NO;
    ECRBaseWkViewController *bwkvc = [ECRBaseWkViewController new];
    bwkvc.URLString = model.adurl;
    [self.navigationController pushViewController:bwkvc animated:YES];
}
#pragma mark - ECRThemeAeraDelegate 专题代理
- (void)taView:(ECRThemeAera *)view model:(ECRThematicModel *)model{
    self.isSearch = NO;
    ECRSubjectController *sbvc = [[ECRSubjectController alloc] init];
    sbvc.viewControllerPushWay = ECRBaseControllerPushWayPush;
    sbvc.model = model;
    [self.navigationController pushViewController:sbvc animated:YES];
}

#pragma mark - ECRHomeTitleViewDelelgate
// MARK: 显示国家全名
- (void)htViewRgLocated:(ECRHomeTitleView *)titleView cnBlock:(void (^)(NSString *))cnBlock{
    ECRHomeTitleCountryNameView *htcnView = [[ECRHomeTitleCountryNameView alloc] initWithCountryName:titleView.contryName.text frame:Screen_Bounds titleFrame:CGRectMake(10, 64, 0, 0)];
    htcnView.delegate = self;
    [self.view addSubview:htcnView];
}
// MARK: 跳转搜索
- (void)htViewBeginSearch:(ECRHomeTitleView *)titleView{
    [self.view endEditing:YES];
    self.isSearch = YES;
    [self presentViewController:[ECRSearchBooksViewController searchBooksNav:self closeBlock:^{
        self.tabBarController.tabBar.hidden = NO;
    }] animated:YES completion:^{
        self.tabBarController.tabBar.hidden = YES;
    }];
    
}
// MARK: 购物车
- (void)htView:(ECRHomeTitleView *)titlView sCarClick:(id)param{
    [self userOnLine:^{
        self.isSearch = NO;
        ECRShoppingCarViewController *sc = [[ECRShoppingCarViewController alloc] init];
        sc.viewControllerPushWay = 0;
        [self.navigationController pushViewController:sc animated:YES];
    } offLine:nil];
}

// MARK: 点击阅读达人榜的用户_通知
- (void)ruClickNotification:(NSNotification *)notification{
    ECRRankUser *model = notification.userInfo[@"model"];
    self.isSearch = NO;
    [self jumpToUserInfoWithMode:model];
    
}
// MARK: 跳转至用户信息页面
- (void)jumpToUserInfoWithMode:(ECRRankUser *)model{
    FriendModel *friend = [FriendModel new];
    friend.userId = model.userId;
    friend.iconUrl = model.iconUrl;
    friend.name = model.name;
    UFriendInfoVC *vc = [UFriendInfoVC loadFromStoryBoard:@"User"];
    vc.friendInfo = friend;
    [self.navigationController pushViewController:vc animated:YES];
}

// 删除定位浮框
- (void)htcnViewClose:(ECRHomeTitleCountryNameView *)view{
    [ECRLocationManager currentLocationIsChina];
    [view removeFromSuperview];
}

- (void)createNavLeftBackItem{
    // 重写,不做任何操作
}

- (ECRHomeTitleView *)tView{
    if (_tView == nil) {
        _tView = [[ECRHomeTitleView alloc] initWithFrame:CGRectMake(0, 0, Screen_Width, self.fakeNavHeight)];
        _tView.delegate = self;
        _tView.bgdsState = ECRHomeTitleViewBgdsStateDefault;
    }
    return _tView;
}
- (CGFloat)fakeNavHeight{
    if ([ECRMultiObject isiPhoneX]) {
        return 88;
    }
    return 64;
}
- (CGFloat)topInset{
    if ([ECRMultiObject isiPhoneX]) {
        return 44;
    }
    return 20;
}
- (ECRHomeMainView *)mainView{
    if (_mainView == nil) {
        //    CGRect mvRect = CGRectMake(0, -64, Screen_Width, Screen_Height);
//        _mainView = [[ECRHomeMainView alloc] initWithFrame:CGRectMake(0, 64, Screen_Width, Screen_Height - 64)];
        CGFloat topInset = self.topInset;
        _mainView = [[ECRHomeMainView alloc] initWithFrame:CGRectMake(0, -topInset, Screen_Width, Screen_Height + topInset)];
        // MARK: 注册cell
        [_mainView.bookClasses.collectionView registerNib:[UINib nibWithNibName:bcCell bundle:nil] forCellWithReuseIdentifier:bcCell];
        [_mainView.boomRecomment.collectionView registerNib:[UINib nibWithNibName:brCell bundle:nil] forCellWithReuseIdentifier:brCell];
        [_mainView.readMonster.tableView registerNib:[UINib nibWithNibName:_mainView.readMonster.tableviewCellId bundle:nil] forCellReuseIdentifier:_mainView.readMonster.tableviewCellId];
        [_mainView.seriesAera.viewFirst.collectionView registerNib:[UINib nibWithNibName:sbvCell bundle:nil] forCellWithReuseIdentifier:sbvCell];
        [_mainView.seriesAera.viewSecond.collectionView registerNib:[UINib nibWithNibName:sbvCell bundle:nil] forCellWithReuseIdentifier:sbvCell];
        [_mainView.seriesAera.viewThird.collectionView registerNib:[UINib nibWithNibName:sbvCell bundle:nil] forCellWithReuseIdentifier:sbvCell];
        [_mainView.seriesAera.headLine.more addTarget:self action:@selector(seriesMoreClick:) forControlEvents:UIControlEventTouchUpInside];
        _mainView.delegate = self;
        _mainView.bookClasses.collectionView.dataSource = self;
        _mainView.bookClasses.collectionView.delegate = self;
        _mainView.boomRecomment.collectionView.dataSource = self;
        _mainView.boomRecomment.collectionView.delegate = self;
        _mainView.readMonster.tableView.dataSource = self;
        _mainView.readMonster.tableView.delegate = self;
        _mainView.seriesAera.viewFirst.collectionView.dataSource = self;
        _mainView.seriesAera.viewFirst.collectionView.delegate = self;
        _mainView.seriesAera.viewSecond.collectionView.dataSource = self;
        _mainView.seriesAera.viewSecond.collectionView.delegate = self;
        _mainView.seriesAera.viewThird.collectionView.dataSource = self;
        _mainView.seriesAera.viewThird.collectionView.delegate = self;
        _mainView.themeAera.delegate = self;
        _mainView.scrollView.delegate = self;
    }
    return _mainView;
}

- (void)rg_locatedWithBlock:(void (^)(NSString *))cnBlock{
    [ECRLocationManager rg_startUpdatingLocationWithBlock:cnBlock];
}

// MARK: 更多系列
- (void)seriesMoreClick:(UIButton *)senser{
//    NSLog(@"更多系列 -- ");
    [ECRMentionBoy loadTipsForOneHour];
}

- (ECRRequestFailuredView *)rrfv{
    if (_rrfv == nil) {
        _rrfv = [[ECRRequestFailuredView alloc] initWithFrame:self.view.bounds];
        _rrfv.delegate = self;
    }
    return _rrfv;
}
- (NSMutableArray *)hcnModels{
    if (_hcnModels == nil) {
        _hcnModels = [NSMutableArray arrayWithCapacity:10];
    }
    return _hcnModels;
}

- (void)tabBarClickNotification:(NSNotification *)notification{
    self.isSearch = YES;
}

- (void)dealloc{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}
- (void)didReceiveMemoryWarning{
    [super didReceiveMemoryWarning];
    [[SDImageCache sharedImageCache] setValue:nil forKey:@"memCache"];
}

@end

