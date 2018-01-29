//
//  UFavouriteVC.m
//  EasyChineseReading-ios
//
//  Created by 赵春阳 on 17/8/30.
//  Copyright © 2017年 lee. All rights reserved.
//

#import "UserFavouriteVC.h"

#import "UFavouriteTableViewCell.h"
#import "EmptyView.h"
#import "ShareVC.h"
#import "ECRShoppingCarModel.h"

#import "ECRBookInfoViewController.h"
#import "UVirtualCurrencyRechargeVC.h"
#import "ECRBookFormViewController.h"

static NSString *const kIconArrowSelectedUp   = @"icon_favourite_arrow_up";
static NSString *const kIconArrowSelectedDown = @"icon_favourite_arrow_down";
static NSString *const kIconArrowUnSelected   = @"icon_favourite_arrow_down_gray";

@interface UserFavouriteVC () <UITableViewDelegate, UITableViewDataSource, UFavouriteTableViewCellDelegate>

@property (weak, nonatomic) IBOutlet UITableView *tableView;

@property (weak, nonatomic) IBOutlet UILabel *lblTime;              // 时间
@property (weak, nonatomic) IBOutlet UILabel *lblMoney;             // 价格
@property (weak, nonatomic) IBOutlet UILabel *lblFavouriteNum;      // 收藏人气

@property (weak, nonatomic) IBOutlet UIImageView *imgTime;          // 时间
@property (weak, nonatomic) IBOutlet UIImageView *imgMoney;         // 价格
@property (weak, nonatomic) IBOutlet UIImageView *imgFavouriteNum;  // 收藏人气

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *widthTimeSortConstraint;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *widthPriceSortConstraint;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *widthHotSortConstraint;

@property (strong, nonatomic) NSMutableArray *arrDataSource;        // 数据
//@property (strong, nonatomic) NSMutableArray *arrSelected;          // 选中的数据

@property (strong, nonatomic) EmptyView *emptyView; // 空白提示界面

@property (assign, nonatomic) ENUM_FavouriteSortType favouriteSort; // 排序

@property (strong, nonatomic) BookModel *selectBook; // 查看详情的图书

@property (assign, nonatomic) BOOL selectedAll; // 选择全部

@end

@implementation UserFavouriteVC

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.arrDataSource = [NSMutableArray array];
    [self configFavouriteView];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:NO animated:YES];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

#pragma mark - 配置界面

- (void)updateSystemLanguage
{
    self.title = LOCALIZATION(@"我的收藏");
    _lblTime.text = LOCALIZATION(@"时间");
    _lblMoney.text = LOCALIZATION(@"价格");
    _lblFavouriteNum.text = LOCALIZATION(@"收藏人气");
    
    [_tableView reloadData];
}

- (void)configFavouriteView
{
    [self registTableView];
    [self configHeaderView];
    [self addEmptyView];
    [self configMJRefresh];
    [self getFavourite];
    
    WeakSelf(self)
    // 更新收藏数据
    [self fk_observeNotifcation:kNotificationCollectMangeKeyType usingBlock:^(NSNotification *note) {
        StrongSelf(self)
        NSDictionary *dic = note.userInfo;
        if ([dic[kNotificationCollectMangeKeyType] isEqual:@(0)]) // 取消收藏
            [self.arrDataSource removeObject:self.selectBook];
        else // 添加收藏
            [self.arrDataSource addObject:self.selectBook];

        [self.tableView reloadData];
        self.emptyView.hidden = self.arrDataSource.count > 0;
    }];
}

- (void)configHeaderView
{
    _lblTime.font        = [UIFont systemFontOfSize:cFontSize_16];
    _lblMoney.font       = [UIFont systemFontOfSize:cFontSize_16];
    
    _lblTime.textColor        = [UIColor cm_mainColor];
    _lblMoney.textColor       = [UIColor cm_blackColor_333333_1];
    
    _imgTime.image          = [UIImage imageNamed:kIconArrowSelectedDown];
    _imgMoney.image         = [UIImage imageNamed:kIconArrowUnSelected];
    _imgFavouriteNum.image  = [UIImage imageNamed:kIconArrowUnSelected];
    
    // 自适应宽度 左右20空白+文字宽度
    _widthTimeSortConstraint.constant  = [NSString stringWidthWithText:_lblTime.text fontSize:_lblTime.font.pointSize] + 20*2;
    _widthPriceSortConstraint.constant = [NSString stringWidthWithText:_lblMoney.text fontSize:_lblMoney.font.pointSize] + 20*2;
    _widthHotSortConstraint.constant   = [NSString stringWidthWithText:_lblFavouriteNum.text fontSize:_lblFavouriteNum.font.pointSize] + 20*2;
    
    UITapGestureRecognizer *tapTime  = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(sortWithTime)];
    UITapGestureRecognizer *tapMoney = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(sortWithMoney)];
    UITapGestureRecognizer *tapNumb  = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(sortWithNumb)];

    [_lblTime addGestureRecognizer:tapTime];
    [_lblMoney addGestureRecognizer:tapMoney];
    [_lblFavouriteNum addGestureRecognizer:tapNumb];
    
    _favouriteSort = ENUM_FavouriteSortTypeTimeDown;
}

- (void)registTableView
{
    self.tableView.rowHeight = UITableViewAutomaticDimension;
    self.tableView.estimatedRowHeight = 100;
    [self.tableView registerNib:[UINib nibWithNibName:NSStringFromClass([UFavouriteTableViewCell class]) bundle:nil] forCellReuseIdentifier:NSStringFromClass([UFavouriteTableViewCell class])];
    
    UIView *footer = [UIView new];
    footer.backgroundColor = [UIColor whiteColor];
    _tableView.tableFooterView = footer;
}

- (void)addEmptyView
{
    _emptyView = [EmptyView loadFromNibWithFrame:CGRectMake(0, 0, Screen_Width, self.view.height)];
    [_emptyView updateEmptyViewWithType:ENUM_EmptyResultTypeUnknow Image:nil desc:LOCALIZATION(@"你还没有收藏过图书") subDesc:nil];
    [self.view addSubview:_emptyView];
}

- (void)configMJRefresh
{
    WeakSelf(self)
    _tableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        [weakself getFavourite];
    }];
    
    _tableView.mj_footer = [MJRefreshBackFooter footerWithRefreshingBlock:^{
        [weakself.tableView.mj_footer endRefreshing];
    }];
}

#pragma mark - 获取数据

- (void)getFavourite
{
    _selectedAll = NO;
    [self showWaitTips];
    WeakSelf(self)
    [[FavouriteRequest sharedInstance] getFavourtesWithSort:_favouriteSort completion:^(id object, ErrorModel *error) {
        StrongSelf(self)
        [self dismissTips];
        [self.tableView.mj_header endRefreshing];
        if (error) {
            [self presentFailureTips:error.message];
        }
        else {
            self.arrDataSource = [NSMutableArray mj_objectArrayWithKeyValuesArray:object];
            self.emptyView.hidden = _arrDataSource.count > 0;
            if (self.arrDataSource.count > 0) {
                [self.tableView reloadData];
            }
        }
    }];
}

#pragma mark - UITableViewDataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return _arrDataSource.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UFavouriteTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([UFavouriteTableViewCell class])];
    cell.index = indexPath.row;
    cell.data = _arrDataSource[indexPath.row];
    cell.delegate = self;
    cell.isSelected = _selectedAll;
    
    return cell;
}

#pragma mark - UITableViewDelegate

/** 查看图书详情 */
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    BookModel *book = _arrDataSource[indexPath.row];
    UIStoryboard *board = [UIStoryboard storyboardWithName:@"BookInfo" bundle:nil];
    ECRBookInfoViewController *bivc = [board instantiateViewControllerWithIdentifier:@"ECRBookInfoViewController"];
    bivc.viewControllerPushWay = ECRBaseControllerPushWayPush;
    bivc.bookId = book.bookId;
    _selectBook = book;
    [self.navigationController pushViewController:bivc animated:YES];
}

- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    return YES;
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        [self delBook:_arrDataSource[indexPath.row] indexPath:indexPath];
    }
}

/** 删除图书 */
- (void)delBook:(BookModel *)book indexPath:(NSIndexPath *)indexPath
{
    [self showWaitTips];
    WeakSelf(self)
    [[FavouriteRequest sharedInstance] updateFavouriteWithBookId:[NSString stringWithFormat:@"%ld", book.bookId] type:ENUM_FavouriteActionTypeDelete completion:^(id object, ErrorModel *error) {
        StrongSelf(self)
        [self dismissTips];
        if (error) {
            [self presentFailureTips:error.message];
        }
        else {
            [self.arrDataSource removeObjectAtIndex:indexPath.row];
            [self.tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationTop];
            self.emptyView.hidden = self.arrDataSource.count > 0;
        }
    }];
}

#pragma mark - UFavouriteTableViewCellDelegate
/** 添加到购物车 */
- (void)addToShopCarWithBook:(BookModel *)book
{
    [self showWaitTips];
    WeakSelf(self)
    [[ShopCarRequest sharedInstance] configShopCarWithBookId:[NSString stringWithFormat:@"%ld", (long)book.bookId]
                                                    serialId:@""
                                                     buyType:[NSString stringWithFormat:@"%ld", (long)ENUM_GetBookTypeBuy]
                                                        type:[NSString stringWithFormat:@"%ld", (long)ENUM_ShopCarActionAdd]
                                                       price:[NSString stringWithFormat:@"%.2f", book.price]
                                                     orderId:@""
                                                     readDay:@""
                                                  completion:^(id object, ErrorModel *error) {
                                                      StrongSelf(self)
                                                      [self dismissTips];
                                                      if (error)
                                                          [self presentFailureTips:error.message];
                                                      else
                                                          [self presentSuccessTips:LOCALIZATION(@"成功添加到购物车")];
                                                  }];
}

/** 分享图书 */
- (void)shareWithBook:(BookModel *)book
{
    ShareVC *share = [ShareVC loadFromNib];
    share.book = book;
    
    share.modalTransitionStyle = UIModalTransitionStyleCrossDissolve;
    share.modalPresentationStyle = UIModalPresentationOverCurrentContext;
    [self presentViewController:share animated:YES completion:nil];
}

#pragma mark - 底部点击操作
#pragma mark 全选
/** 选择全部或取消选中 */
- (void)selectedAllFavourite
{
//    [self.arrSelected removeAllObjects];
//    if (_selectedAll == NO) {
//        [_arrSelected addObjectsFromArray:_arrDataSource];
//        _imgSelectedAll.image = [UIImage imageNamed:cImageSelected];
//    }
//    else {
//        _imgSelectedAll.image = [UIImage imageNamed:cImageUnSelected];
//    }
//    _selectedAll = !_selectedAll;
//    [self.tableView reloadData];
}

#pragma mark 批量购买

/**
 批量购买
 */
- (IBAction)click_btnBuy:(id)sender {
//    if (_arrSelected.count > 0) {
//        CGFloat price = 0;
//        NSMutableArray *array = [NSMutableArray array];
//        for (NSInteger i = 0; i < _arrSelected.count; i ++) {
//            BookModel *book = _arrSelected[i];
//            NSDictionary *dic = [book createDictionayFromModelProperties];
//            price += book.price;
//            ECRShoppingCarModel *shopModel = [ECRShoppingCarModel mj_objectWithKeyValues:dic];
//            [array addObject:shopModel];
//        }
//
//        ECRBookFormViewController *dFormDetail = [[ECRBookFormViewController alloc] init];
//        dFormDetail.viewControllerPushWay = ECRBaseControllerPushWayPush;
//        dFormDetail.tickedArray = array;
//        dFormDetail.tickedPrice = price;
//        [self.navigationController pushViewController:dFormDetail animated:YES];
//    }
//    else {
//        [self alertNoSelected];
//    }
}

#pragma mark 批量删除

/**
 批量删除
 */
- (IBAction)click_btnDelete:(id)sender {
//    // 选中的收藏
//    if (self.arrSelected.count > 0) {
//        ZAlertView *alert = [[ZAlertView alloc] initWithTitle:LOCALIZATION(@"取消收藏?") message:nil delegate:self cancelButtonTitle:LOCALIZATION(@"取消") otherButtonTitles:LOCALIZATION(@"确定"), nil];
//
//        alert.whenDidSelectOtherButton = ^{
//            if (_arrSelected.count > 0) {
//                [self deleteFavouriteHandle];
//            }
//            else {
//
//            }
//        };
//        [alert show];
//    }
//    else {
//        [self alertNoSelected];
//    }
}

- (void)alertNoSelected
{
    ZAlertView *alert = [[ZAlertView alloc] initWithTitle:LOCALIZATION(@"没有选中的书籍") message:nil delegate:self cancelButtonTitle:LOCALIZATION(@"确定") otherButtonTitles: nil, nil];

    [alert show];
}

#pragma mark - 批量删除收藏

- (void)deleteFavouriteHandle
{
//    NSMutableString *bookIds = [[NSMutableString alloc] init];
//    for (NSInteger i = 0; i < _arrSelected.count; i ++) {
//        BookModel *book = _arrSelected[i];
//        [bookIds appendString:[NSString stringWithFormat:@"%ld,", (long)book.bookId]];
//    }
//    [[FavouriteRequest sharedInstance] updateFavouriteWithBookId:bookIds
//                                                            type:ENUM_FavouriteActionTypeDelete
//                                                      completion:^(id object, ErrorModel *error) {
//                                                          if (error) {
//                                                              [self presentFailureTips:error.message];
//                                                          }
//                                                          else {
//                                                              [_arrDataSource removeObjectsInArray:_arrSelected];
//                                                              [_tableView reloadData];
//                                                          }
//                                                      }];
}

#pragma mark - 排序

/** 根据收藏的时间排序 */
- (void)sortWithTime
{
    // 如果当前排序是时间降序排序，则改为时间升序
    if (_favouriteSort == ENUM_FavouriteSortTypeTimeDown) {
        _favouriteSort = ENUM_FavouriteSortTypeTimeUp;
        _imgTime.image = [UIImage imageNamed:kIconArrowSelectedUp];
    }
    // 时间降序
    else {
        _favouriteSort = ENUM_FavouriteSortTypeTimeDown;
        _imgTime.image = [UIImage imageNamed:kIconArrowSelectedDown];
    }
    _imgMoney.image = [UIImage imageNamed:kIconArrowUnSelected];
    _imgFavouriteNum.image = [UIImage imageNamed:kIconArrowUnSelected];
    
    _lblTime.textColor = [UIColor cm_mainColor];
    _lblMoney.textColor = [UIColor cm_blackColor_333333_1];
    _lblFavouriteNum.textColor = [UIColor cm_blackColor_333333_1];
    
    [self updateViewWithSort];
}

/** 根据价格排序 */
- (void)sortWithMoney
{
    // 如果当前排序是价格降序排序，则改为价格升序
    if (_favouriteSort == ENUM_FavouriteSortTypePriceDown) {
        _favouriteSort = ENUM_FavouriteSortTypePriceUp;
        _imgMoney.image = [UIImage imageNamed:kIconArrowSelectedUp];
    }
    // 价格降序
    else {
        _favouriteSort = ENUM_FavouriteSortTypePriceDown;
        _imgMoney.image = [UIImage imageNamed:kIconArrowSelectedDown];
    }
    _imgTime.image = [UIImage imageNamed:kIconArrowUnSelected];
    _imgFavouriteNum.image = [UIImage imageNamed:kIconArrowUnSelected];
    
    _lblTime.textColor = [UIColor cm_blackColor_333333_1];
    _lblMoney.textColor = [UIColor cm_mainColor];
    _lblFavouriteNum.textColor = [UIColor cm_blackColor_333333_1];
    
    [self updateViewWithSort];
}

/** 根据收藏热度排序 */
- (void)sortWithNumb
{
    // 如果当前排序是热度降序排序，则改为热度升序
    if (_favouriteSort == ENUM_FavouriteSortTypeHotDown) {
        _favouriteSort = ENUM_FavouriteSortTypeHotUp;
        _imgFavouriteNum.image = [UIImage imageNamed:kIconArrowSelectedUp];
    }
    // 热度降序
    else {
        _favouriteSort = ENUM_FavouriteSortTypeHotDown;
        _imgFavouriteNum.image = [UIImage imageNamed:kIconArrowSelectedDown];
    }
    _imgMoney.image = [UIImage imageNamed:kIconArrowUnSelected];
    _imgTime.image = [UIImage imageNamed:kIconArrowUnSelected];
    
    _lblTime.textColor = [UIColor cm_blackColor_333333_1];
    _lblMoney.textColor = [UIColor cm_blackColor_333333_1];
    _lblFavouriteNum.textColor = [UIColor cm_mainColor];
    
    [self updateViewWithSort];
}

- (void)updateViewWithSort
{
    [self getFavourite];
}

@end
