//
//  ECRBookInfoViewController.m
//  EasyChineseReading-ios
//
//  Created by lee on 2017/9/11.
//  Copyright © 2017年 lee. All rights reserved.
//

static NSString *pjCell = @"ECRDetailPJTableViewCell";
static NSString *pjCellPad = @"ECRDetailPJTableViewPadCell";

#import "ECRBookInfoViewController.h"
#import "ECRSwichView.h"
#import "ECRBookInfoModel.h"
#import "ECRBookInfoTableViewCell.h"
#import "ECRBiCommentModel.h"
#import "ECRDetailPJTableViewCell.h"
#import "ECRRentSeriousViewController.h"
#import "ECRShoppingCarViewController.h"
#import "ECRShoppingCarManager.h"
#import "ECRShoppingCarModel.h"
#import "ECRDataHandler.h"
#import "ECRScoreUserModel.h"
#import "ECRRowObject.h"
#import "ECRRequestFailuredView.h"
#import "ECRDetailPJTableViewPadCell.h"
#import "ECRRecoBook.h"
#import "ECRDownloadManager.h"
#import "ShareVC.h"
#import "ECRBookrackDataHandler.h"
#import "ECRBookReaderManager.h"
#import "ECRLocalFileManager.h"
#import "ECRBiCustomButton.h"
#import "ECRBookFormViewController.h"
#import "ECRDownloadFirstReadSecond.h"
#import "LGCartIcon.h"
#import "ECRNetLoadingView.h"

@interface ECRBookInfoViewController ()<
UITableViewDelegate,
UITableViewDataSource,
ECRSwichViewDelegate,
ECRRequestFailuredViewDelegate,
ECRBookInfoTableViewCellDelegate,
ECRBookFormViewControllerDelegate
>{
    CGFloat ssvH;// switchscrollview 的 height
}
@property (weak, nonatomic) IBOutlet UIImageView *icon_arrow_right;
@property (weak, nonatomic) IBOutlet UIImageView *icon_tab_selected;
@property (weak, nonatomic) IBOutlet UIImageView *icon_coin;

@property (strong,nonatomic) ECRBookInfoModel *model;
@property (strong, nonatomic) IBOutlet UIScrollView *baseScrollView;
@property (strong, nonatomic) IBOutlet UIView *topInfoView;
@property (strong, nonatomic) IBOutlet UIScrollView *swithcScrollView;
@property (strong, nonatomic) IBOutlet UIView *buttonView;/// MARK: 默认状态 buttonview
@property (strong, nonatomic) IBOutlet ECRSwichView *diSwitchView;
/** switchscrollview 高度约束 */
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *ssvHeight;
/** infotableview 高度约束 */
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *bitbHeight;
/** pjtableview 高度约束 */
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *pjtbHeight;
/** 评价为空view 高度约束 */
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *pj_empty_view_height;
@property (weak, nonatomic) IBOutlet UIImageView *biCover;
@property (weak, nonatomic) IBOutlet UILabel *biName;
@property (weak, nonatomic) IBOutlet UILabel *biAuthor;
@property (weak, nonatomic) IBOutlet UIView *biStar;
/** 新starview */
@property (strong,nonatomic) ZStarView *nbiStar;
@property (weak, nonatomic) IBOutlet UILabel *biPrice;
@property (weak, nonatomic) IBOutlet UILabel *biPriceSymbles;
@property (weak, nonatomic) IBOutlet UIView *biRectView;
@property (weak, nonatomic) IBOutlet UIView *biLine;
@property (weak, nonatomic) IBOutlet UIView *biLine2;
@property (weak, nonatomic) IBOutlet UIButton *buyButton;// 购买纸质书
@property (weak, nonatomic) IBOutlet UITableView *infoTableView;
@property (weak, nonatomic) IBOutlet UITableView *pjTableView;/// 评价列表

@property (assign,nonatomic) CGFloat rHeight1;
@property (assign,nonatomic) CGFloat rHeight2;
@property (assign,nonatomic) CGFloat rHeight3;
@property (assign,nonatomic) CGFloat rHeight4;
@property (assign,nonatomic) CGFloat pjHeight;
@property (strong,nonatomic) NSArray *comments;// 品论数据源
@property (strong,nonatomic) ECRRequestFailuredView *rrfv;// 请求失败 view
@property (strong,nonatomic) UIButton *like;//
@property (strong,nonatomic) MBProgressHUD *dlProgressHUD;/// download
@property (weak, nonatomic) IBOutlet ECRBiCustomButton *tryRead;/// 试读
@property (weak, nonatomic) IBOutlet ECRBiCustomButton *seriesBao;/// 系列包月
@property (weak, nonatomic) IBOutlet ECRBiCustomButton *addCart;/// 加入购物车 & 不能加入
@property (weak, nonatomic) IBOutlet UIButton *buyNow;/// 购买 & 立即阅读
@property (assign,nonatomic) BOOL downloading;//
/** 评价为空view */
@property (weak, nonatomic) IBOutlet ECRRequestFailuredView *pjEmptyView;
/** 自定义购物车按钮 */
@property (strong,nonatomic) LGCartIcon *cartButton;
/** 加载过程view */
@property (strong,nonatomic) ECRNetLoadingView *netLoadingView;

@end

@implementation ECRBookInfoViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setupUI];
    [self.view addSubview:self.netLoadingView];
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:NO animated:YES];
    [ECRShoppingCarManager loadCartCount:^(NSInteger count) {
        self.cartButton.cartCount = count;
    }];
}

- (void)setBookId:(NSInteger)bookId{
    _bookId = bookId;
    [self loadNewDataWithBookId:bookId];
}
- (void)loadNewDataWithBookId:(NSInteger)bookId{
    [[ECRDataHandler sharedDataHandler] biDataWithBookId:bookId success:^(id object) {
        ECRBookInfoModel *model = (ECRBookInfoModel *)object;
        self.like.selected = model.collectionType;
        self.model = model;
        self.comments = model.scores;
        NSLog(@"评价条数 -- %ld",self.comments.count);
        if (self.comments.count) {
            self.pjEmptyView.hidden = YES;
        }else{
            self.pjEmptyView.hidden = NO;
        }
        
        [[NSOperationQueue mainQueue] addOperationWithBlock:^{
            if (_rrfv != nil) {
                [_rrfv removeFromSuperview];
                _rrfv = nil;
            }
            // 基本信息
            [self.biCover sd_setImageWithURL:[NSURL URLWithString:model.iconUrl] placeholderImage:LGPlaceHolderImg];
            if ([LGPChangeLanguage currentLanguageIsEnglish]) {
                self.biName.text = model.en_bookName;
                self.biAuthor.text = model.en_author;
            }else{
                self.biName.text = model.bookName;
                self.biAuthor.text = model.author;
            }
//            NSLog(@"xiangqingpingfeninteger -- %ld",(NSInteger)model.score);
            [self.nbiStar setScore:(NSInteger)model.score withAnimation:NO];
//            NSLog(@"xiangqingpingfen -- %f",model.score);
            self.biPrice.text = [NSString stringWithFormat:@"%.2f",model.price];
            [self.infoTableView reloadData];
            [self.pjTableView reloadData];
            
            if (self.model.owendType > 0) {// MARK: owendType为已拥有
                [self setBtnLocaText:self.buyNow titleKey:@"立即阅读"];
                [self.buyNow setImage:[UIImage imageNamed:@"icon_read_now"] forState:UIControlStateNormal];
            }
            if (self.model.owendType == 1) {
                [self setAddCartButtonGray];
            }        
            [self.netLoadingView removeFromSuperview];
        }];
    } failure:^(NSString *msg) {
        [self.netLoadingView removeFromSuperview];
//        NSLog(@"msg -- %@",msg);
        if (_rrfv == nil) {
            [self.view addSubview:self.rrfv];
        }
    } commenFailure:^(NSError *error) {
        [self.netLoadingView removeFromSuperview];
        if (_rrfv == nil) {
            [self.view addSubview:self.rrfv];
        }
    }];
}

// MARK: 点击立即购买
- (void)buyEbookClick:(UIButton *)sender {
    
    [self userOnLine:^{
        if (self.model.owendType > 0) {
            [self readBook];
        }else{
            ECRBookFormViewController *dFormDetail = [[ECRBookFormViewController alloc] init];
            dFormDetail.viewControllerPushWay = ECRBaseControllerPushWayPush;
            if (self.model != nil) {
                dFormDetail.tickedArray = @[self.model];
            }
            dFormDetail.tickedPrice = self.model.price;
            dFormDetail.delegate = self;
            [self.navigationController pushViewController:dFormDetail animated:YES];
        }
    } offLine:nil];
}
// MARK: 试读
- (void)experClick:(UIButton *)sender {
    [self userOnLine:^{
        if (self.model.academicProbationUrl == nil || [self.model.academicProbationUrl isEqualToString:@""]) {
            // 提示用户没有试读资源
            [self presentSuccessTips:LOCALIZATION(@"没有试读资源")];
        }else{
            [self readBook];
        }
    } offLine:nil];

}
- (void)readBook{
    self.downloading = YES;
    [ECRDownloadFirstReadSecond downloadFirstReadSecondWithvc:self book:self.model success:^{
        self.downloading = NO;
    } failure:^(NSError *error) {
        [ECRLocalFileManager deleteLocalFileWithPath:self.model.localURL];
        [self presentSuccessTips:LOCALIZATION(@"下载失败,请稍后重试")];
        NSLog(@"下载失败 -- %@",error);
        self.downloading = NO;
    }];
}

// MARK: 系列包月
- (void)setBaoClick:(UIButton *)sender {
    
    ECRRentSeriousViewController *rsvc = [[ECRRentSeriousViewController alloc] init];
    rsvc.model = self.model;
    rsvc.viewControllerPushWay = ECRBaseControllerPushWayPush;
    [self.navigationController pushViewController:rsvc animated:YES];
    
}
- (IBAction)bookBuy:(UIButton *)sender {
    // MARK: 购买纸质书
    
}
#pragma mark - ECRRequestFailuredViewDelegate 错误请求代理
- (void)rfViewReloadData:(ECRRequestFailuredView *)view eType:(ECRRFViewEmptyType)etype{
    [self loadNewDataWithBookId:self.bookId];
}

#pragma mark - ECRBookInfoTableViewCellDelegate
// MARK: 跳转至推荐书籍
- (void)bitbrecoBookClick:(ECRBookInfoTableViewCell *)cell model:(ECRRecoBook *)model{
    UIStoryboard *board = [UIStoryboard storyboardWithName:@"BookInfo" bundle:nil];
    ECRBookInfoViewController *bivc = [board instantiateViewControllerWithIdentifier:@"ECRBookInfoViewController"];
    bivc.viewControllerPushWay = ECRBaseControllerPushWayPush;
    bivc.bookId = model.bookId;
    [self.navigationController pushViewController:bivc animated:YES];
}
- (void)bitbnrcaFold:(ECRBookInfoTableViewCell *)cell{
    [self.infoTableView reloadData];
}

#pragma mark - ECRSwichViewDelegate
- (void)ecrSwichView:(ECRSwichView *)view didClick:(NSInteger)click{
    switch (click) {
        case 0:
            [self.swithcScrollView setContentOffset:CGPointZero animated:YES];
            self.swithcScrollView.contentSize = CGSizeMake(2 * Screen_Width, self.bitbHeight.constant);
            break;
        case 1:
            [self.swithcScrollView setContentOffset:CGPointMake(Screen_Width, 0) animated:YES];
            self.swithcScrollView.contentSize = CGSizeMake(2 * Screen_Width, self.pjtbHeight.constant);
            break;
    }
}
- (void)scrollViewDidScroll:(UIScrollView *)scrollView{
    if ([scrollView isEqual:self.swithcScrollView]) {

        if (scrollView.contentOffset.x == 0) {
            self.ssvHeight.constant = _rHeight1 + _rHeight2 +_rHeight3 +_rHeight4;
            self.swithcScrollView.contentSize = CGSizeMake(2 * Screen_Width, self.bitbHeight.constant);
            [self.diSwitchView switchSelectedItem:0];
        }
        if (scrollView.contentOffset.x >= Screen_Width) {
            self.ssvHeight.constant = self.pjHeight;
            [self.diSwitchView switchSelectedItem:1];
            self.swithcScrollView.contentSize = CGSizeMake(2 * Screen_Width, self.pjtbHeight.constant);
            
        }
    }else{

    }
}

#pragma mark - data source
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if ([tableView isEqual:self.infoTableView]) {
        return 4;
    }
    return _comments.count;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    if ([tableView isEqual:self.infoTableView]) {
        ECRBookInfoTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:[ECRBookInfoTableViewCell gainReuseID:indexPath]];
        cell.indx = indexPath;
//        NSLog(@"%@",indexPath);
        cell.model = self.model;
        cell.delegate = self;
        return cell;
    }
    ECRDetailPJTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:pjCell];
    ECRScoreUserModel *model = _comments[indexPath.row];
    cell.model = model;
    return cell;
    
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if ([tableView isEqual:self.infoTableView]) {
        // MARK: ssv height
        ECRBookInfoTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:[ECRBookInfoTableViewCell gainReuseID:indexPath]];
        cell.indx = indexPath;
        cell.model = self.model;
        
        if (indexPath.row == 0) {
            _rHeight1 = cell.rHeight1;
        }
        if (indexPath.row == 1) {
            _rHeight2 = cell.rHeight2;
        }
        if (indexPath.row == 2) {
            _rHeight3 = cell.rHeight3;
        }
        if (indexPath.row == 3) {// 如何获取总高度?
            _rHeight4 = cell.rHeight4;
            self.ssvHeight.constant = _rHeight1 + _rHeight2 +_rHeight3 +_rHeight4;
            self.bitbHeight.constant = _rHeight1 + _rHeight2 +_rHeight3 +_rHeight4;
            self.pj_empty_view_height.constant = self.bitbHeight.constant;
        }
        return cell.rHeight;
    }
    CGFloat pjRowHeight;
    ECRDetailPJTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:pjCell];
    pjRowHeight = cell.cellHeight;
    if (indexPath.row == (_comments.count - 1)) {
        _pjHeight = pjRowHeight * (_comments.count);
        self.pjtbHeight.constant = _pjHeight;
    }
    return pjRowHeight;
}

- (void)textDependsLauguage{
    NSString *bookInfo = [LGPChangeLanguage localizedStringForKey:@"图书详情"];
    NSString *bookReview = [LGPChangeLanguage localizedStringForKey:@"评价"];
    self.title = bookInfo;
    _diSwitchView.buttonNames = @[bookInfo,bookReview];
    [self setBtnLocaText:self.buyButton titleKey:@"购买纸书"];
    
    
    if (self.model.owendType > 0) {// MARK: owendType
        [self setBtnLocaText:self.buyNow titleKey:@"立即阅读"];
    }else{
        [self setBtnLocaText:self.buyNow titleKey:@"立即购买"];
    }
}
- (void)setBtnLocaText:(UIButton *)button titleKey:(NSString *)titleKey{
    [button setTitle:[LGPChangeLanguage localizedStringForKey:titleKey] forState:UIControlStateNormal];
}

#pragma mark - UI
- (void)setupUI{
    [self textDependsLauguage];
    [self setNavRightCustemView];
    [_icon_arrow_right setImage:[UIImage imageNamed:@"icon_arrow_right"]];
    [_icon_tab_selected setImage:[UIImage imageNamed:@"icon_tabbar_selected_bookstore"]];
    [_icon_coin setImage:[UIImage imageNamed:@"icon_virtual_currency"]];
    [_buyButton setTitleColor:[LGSkinSwitchManager currentThemeColor] forState:UIControlStateNormal];
    [self.swithcScrollView setContentSize:CGSizeMake(Screen_Width, 0)];
    self.swithcScrollView.pagingEnabled = YES;
    self.infoTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.swithcScrollView.directionalLockEnabled = NO;
    _diSwitchView.delegate = self;
    
    self.pjTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self.pjTableView registerNib:[UINib nibWithNibName:pjCell bundle:nil] forCellReuseIdentifier:pjCell];
    
    
    // MARK: 新按钮
    NSString *textPurple = [LGSkinSwitchManager currentThemeColorStr];
    NSString *bgWhite = @"ffffff";
    [self setNewBottomButtonWith:_addCart imgName:@"icon_shop_car" text:@"加入购物车" textColor:textPurple action:@selector(addToscClick:) bgColorStr:bgWhite];
    [self setNewBottomButtonWith:_tryRead imgName:@"icon_book_read" text:@"试读" textColor:textPurple action:@selector(experClick:) bgColorStr:bgWhite];
    [self setNewBottomButtonWith:_seriesBao imgName:@"icon_book_lease" text:@"系列" textColor:textPurple action:@selector(setBaoClick:) bgColorStr:bgWhite];
    
    [_buyNow setImageEdgeInsets:UIEdgeInsetsMake(0, 0, 0, 10)];
    [_buyNow setBackgroundColor:[UIColor cm_mainColor]];
    [self.view setNeedsLayout];
    [self.view layoutIfNeeded];
 
//    NSLog(@"self.biStar.frame -- %@",NSStringFromCGRect(self.biStar.frame));
    CGRect starFrame = self.biStar.frame;
    self.nbiStar = [[ZStarView alloc] initWithFrame:starFrame numberOfStar:5];
    [self.topInfoView addSubview:self.nbiStar];
    
    self.pjEmptyView.emptyType = ECRRFViewEmptyTypeNoComments;
}

- (void)setNewBottomButtonWith:(ECRBiCustomButton *)bicus imgName:(NSString *)imgName text:(NSString *)text textColor:(NSString *)textColor action:(SEL)action bgColorStr:(NSString *)bgColorStr{
    [bicus setupWithImgName:imgName labelText:text labelTextColor:textColor];
    [bicus addTarget:self action:action forControlEvents:UIControlEventTouchUpInside];
    bicus.layer.borderColor = [UIColor cm_whiteColor_E7E7E7_1].CGColor;
    bicus.layer.borderWidth = 1;
    bicus.bgColorStr = bgColorStr;
}
// MARK: 加入购物车
- (void)addToscClick:(UIButton *)sender {
//    NSLog(@"addToscClick -- %@",sender.titleLabel.text);
    [self userOnLine:^{
        NSDictionary *dict = [NSDictionary dictionaryWithObjectsAndKeys:
                              [NSString stringWithFormat:@"%ld",self.model.bookId],@"bookId",
                              [NSString stringWithFormat:@"%f",self.model.price],@"price",
                              @"1",@"type",
                              nil];
        [[ECRShoppingCarManager sharedInstance] manageShopCarWithDict:dict success:^(NSMutableArray *totalArray, NSMutableArray *tickedArray, CGFloat priceT) {
            // 加入购物车成功
            // 已经加入购物车
            [self presentSuccessTips:LOCALIZATION(@"加入成功")];
            [self setAddCartButtonGray];
            self.cartButton.cartCount += 1;
        } failure:^(NSString *msg) {
            [self presentSuccessTips:LOCALIZATION(msg)];
            [self setAddCartButtonGray];
        } commenFailure:^(NSError *error) {
            [self presentSuccessTips:LOCALIZATION(@"失败")];
        }];
    } offLine:nil];
}

#pragma mark - target
// MARK: 收藏/取消收藏
- (void)navLike:(UIButton *)sender{
    [self closeDownloadTask];
    
    [self userOnLine:^{
        NSInteger typeCollect;
        NSString *showString;
        if (sender.selected) {
            // 取消收藏成功
            showString = LOCALIZATION(@"取消");
            typeCollect = 0;
        }else{
            // 收藏成功
            showString = LOCALIZATION(@"收藏成功");
            typeCollect = 1;
        }
        /// type 1.添加收藏,2.移除收藏
        [[ECRDataHandler sharedDataHandler] bookCollectWithBookId:self.model.bookId type:typeCollect success:^(id object) {
            //        NSLog(@"collection接口成功回调 -- %@",object);
            if (typeCollect == 1) {
                sender.selected = YES;
            }else{
                sender.selected = NO;
            }
            [self presentSuccessTips:showString];
            NSDictionary *dict = @{kNotificationCollectMangeKeyType:@(typeCollect)};
            [[NSNotificationCenter defaultCenter] postNotificationName:kNotificationCollectMangeKeyType object:nil userInfo:dict];
        } failure:^(NSString *msg) {
            [self presentFailureTips:msg];
        } commenFailure:^(NSError *error) {
            [self presentFailureTips:LOCALIZATION(@"网络连接失败")];
        }];
    } offLine:nil];
    
}
// MARK: 分享(站内信)
- (void)navShare:(UIButton *)sender{
    [self closeDownloadTask];
    [self userOnLine:^{
        ShareVC *share = [ShareVC loadFromNib];
        share.book = self.model;
        share.modalTransitionStyle = UIModalTransitionStyleCrossDissolve;
        share.modalPresentationStyle = UIModalPresentationOverCurrentContext;
        [self presentViewController:share animated:YES completion:nil];
    } offLine:nil];
}
- (void)navCar:(UIButton *)sender{
    // 关闭正在飞的下载请求
//    [ECRDownloadManager cancelDownloadTask];
    [self closeDownloadTask];
    [self userOnLine:^{
        // MARK: 跳转购物车
        ECRShoppingCarViewController *spvc = [[ECRShoppingCarViewController alloc] init];
        spvc.viewControllerPushWay = ECRBaseControllerPushWayPush;
        [self.navigationController pushViewController:spvc animated:YES];
    } offLine:nil];

}

- (void)setNavRightCustemView{
    // 导航栏按钮s
    CGFloat bItemW = 28;
    CGFloat bItemY = -3;
    UIButton *like = [UIButton buttonWithType:UIButtonTypeCustom];
    [like setImage:[UIImage imageNamed:@"icon_unFavourite_white"] forState:UIControlStateNormal];
    [like setImage:[UIImage imageNamed:@"icon_favourite_white" ] forState:UIControlStateSelected];
    [like setFrame:CGRectMake(0, bItemY, bItemW, bItemW)];
    self.like = like;
    UIBarButtonItem *navLike = [[UIBarButtonItem alloc] initWithCustomView:like];
    [like addTarget:self action:@selector(navLike:) forControlEvents:UIControlEventTouchUpInside];
    
    UIButton *share = [UIButton buttonWithType:UIButtonTypeCustom];
    [share setImage:[UIImage imageNamed:@"icon_share_white"] forState:UIControlStateNormal];
    [share setFrame:CGRectMake(0, bItemY, bItemW, bItemW)];
    UIBarButtonItem *navShare = [[UIBarButtonItem alloc] initWithCustomView:share];
    [share addTarget:self action:@selector(navShare:) forControlEvents:UIControlEventTouchUpInside];
    
    self.cartButton.frame = CGRectMake(0, bItemY, bItemW, bItemW);
    UIBarButtonItem *navCar = [[UIBarButtonItem alloc] initWithCustomView:self.cartButton];
    self.navigationItem.rightBarButtonItems = @[navCar,navShare,navLike];
    
}


#pragma mark - lazy load
- (ECRRequestFailuredView *)rrfv{
    if (_rrfv == nil) {
        _rrfv = [[ECRRequestFailuredView alloc] initWithFrame:self.view.bounds];
        _rrfv.delegate = self;
    }
    return _rrfv;
}
- (ECRNetLoadingView *)netLoadingView{
    if (_netLoadingView == nil) {
        _netLoadingView = [[ECRNetLoadingView alloc] initWithFrame:self.view.bounds];
    }
    return _netLoadingView;
}
- (CGFloat)pjHeight{
    if (_pjHeight == 0) {
        if ([ECRMultiObject userInterfaceIdiomIsPad]) {
            _pjHeight = 600; 
        }else{
            _pjHeight = 200;
        }
    }
    return _pjHeight;
}
- (LGCartIcon *)cartButton{
    if (_cartButton == nil) {
        _cartButton = [LGCartIcon new];
        [_cartButton.button addTarget:self action:@selector(navCar:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _cartButton;
}

- (void)dealloc{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}
- (void)baseViewControllerDismiss{
    [super baseViewControllerDismiss];
    [self closeDownloadTask];
}

- (void)closeDownloadTask{
    if (self.downloading) {
        // 如果正在下载
        // 关闭正在飞的下载请求
        [ECRDownloadManager lg_cancelDownloadTask];
        // 隐藏下载进度条
        [ECRDownloadFirstReadSecond removeDlProgressHUD];
    }
}
- (void)setAddCartButtonGray{
    [self.addCart modifyTextColorWithColorString:@"737373" iconName:@"icon_shop_car_gray"];
}

@end
