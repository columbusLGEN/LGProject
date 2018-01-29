//
//  ECRBookRackController.m
//  EasyChineseReading-ios
//
//  Created by lee on 2017/9/5.
//  Copyright © 2017年 lee. All rights reserved.
//

#import "ECRBookRackController.h"
#import "ECRBookrackView.h"
#import "ECRBookrackModel.h"
#import "ECRDownloadStateModel.h"
#import "ECRBookrackCollectionViewCell.h"
#import "ECRBookrackFlowLayout.h"
#import "ECRFloderView.h"
#import "ECRBookFloderLayout.h"
#import "ECRDBReadViewController.h"
#import "ECRBookInfoViewController.h"
#import "ECRBookrackNavMenuView.h"
#import "ECRBookrackEditBottom.h"
#import "ECRBrebAlertView.h"
#import "ECRBookDownloadStateView.h"
#import "ECRBookrackDataHandler.h"
#import "ECRSearchBooksViewController.h"
#import "ECRRequestFailuredView.h"
#import "ECRBookReaderManager.h"
#import "ECRClassSortModel.h"
#import "ECRBRLoadLocalBookModel.h"
#import "ECRInputBookViewController.h"
#import "ECRLocalFileManager.h"
#import "ECRBookrackDownloadCenter.h"
#import "GuideFigureImageView.h"
#import "LGCryptor.h"

static NSString *ECRBookrackcell = @"ECRBookrackCollectionViewCell";

@interface ECRBookRackController ()<
ECRBookrackViewDelegate,
UICollectionViewDelegate,
UICollectionViewDataSource,
ECRBookrackFlowLayoutSwitchStateDelegate,
LXReorderableCollectionViewDataSource,
LXReorderableCollectionViewDelegateFlowLayout,
ECRFloderViewDelegate,
ECRBookrackNavMenuViewDelegate,
ECRBookrackEditBottomDelegate,
ECRBrebAlertViewDelegate,
ECRBookrackCollectionViewCellDelegate,
UITextFieldDelegate,
ECRBookDownloadStateViewDelegate,
ECRRequestFailuredViewDelegate
>
@property (strong,nonatomic) ECRRequestFailuredView *rfview;
@property (strong,nonatomic) ECRBookrackNavMenuView *menu;
@property (strong,nonatomic) ECRBrebAlertView *deboAlert;
@property (strong,nonatomic) ECRBookrackView *mainView;
@property (strong,nonatomic) ECRFloderView *floderView;
@property (strong,nonatomic) ECRBookrackEditBottom *breBottom;
@property (strong,nonatomic) UIView *currentView;
/** 当前分组 */
@property (strong,nonatomic) ECRBookrackModel *currentFloderModel;
/** 全部图书模型数组 */
@property (strong,nonatomic) NSMutableArray<ECRBookrackModel *> *allBookModels;
/** 已购买模型数组 */
@property (strong,nonatomic) NSMutableArray<ECRBookrackModel *> *bookrackModels;
/** 全部图书,选中图书,添加到该数组 */
@property (strong,nonatomic) NSMutableArray<ECRBookrackModel *> *absModels;
/** 已购买,选中图书,添加到该数组 */
@property (strong,nonatomic) NSMutableArray<ECRBookrackModel *> *modelsWillBeRemove;
/** 未知 */
@property (assign,nonatomic) BOOL canReadEpub;
/** 编辑状态,1 = 编辑, 0 = 普通 */
@property (assign,nonatomic) BOOL isEdit_br;
@property (copy,nonatomic) void(^editDoneBlock)();
/** 全部图书书籍总数 */
@property (assign,nonatomic) NSInteger allBookTotalCount;
/** 已购买书籍总数 */
@property (assign,nonatomic) NSInteger bookTotalCount;
/** 1 = 全部图书，2 = 已购买 */
@property (assign,nonatomic) ECRBookrackCurrentPlace currentPlace;
/** 书架列表数据排序 */
@property (assign,nonatomic) ECRBookShelfListSort bslSort;


@end

@implementation ECRBookRackController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setupUI];
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    if (self.currentPlace == 2) {
        [self.mainView.firstFloor setContentOffset:CGPointMake(Screen_Width, 0) animated:NO];
    }
//    [self loadNewData];
    
}

#pragma mark -
/** 引导图 */
- (void)loadGuideFigure
{
    GuideFigureImageView *imageV = [[GuideFigureImageView alloc] initWithFrame:CGRectMake(0, 0, Screen_Width, Screen_Height)];
    imageV.itemIndex = 1;
    
    UIWindow *window = [UIApplication sharedApplication].keyWindow;
    [window addSubview:imageV];
}

- (void)setCurrentPlace:(ECRBookrackCurrentPlace)currentPlace{
    _currentPlace = currentPlace;
    [ECRBookrackDownloadCenter sharedInstance].currentPlace = currentPlace;
}
/** 取消所有正在下载的任务 */
- (void)cancelAllDownloadingTask{
    
    [self.allBookModels enumerateObjectsUsingBlock:^(ECRBookrackModel * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        [obj.dsModel cancelCurrentDownloadTask];
    }];
    [self.bookrackModels enumerateObjectsUsingBlock:^(ECRBookrackModel * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        [obj.dsModel cancelCurrentDownloadTask];
    }];
    
}
// MARK: 请求数据
- (void)loadNewData{
    [self cancelAllDownloadingTask];
    [self userOnLine:^{
        [ECRBookrackDataHandler bookShelfWithSort:self.bslSort success:^(NSMutableArray *arrAll, NSMutableArray *arrBuyed, NSInteger abCount, NSInteger bbCount) {
            if (arrAll == nil || arrAll.count == 0) {
                if (_rfview == nil) {
                    [self.view addSubview:self.rfview];
                    _rfview.emptyType = ECRRFViewEmptyTypeBookrackEmpty;
                }else{
                    [self.rfview removeFromSuperview];
                    _rfview = nil;
                    [self.view addSubview:self.rfview];
                    _rfview.emptyType = ECRRFViewEmptyTypeBookrackEmpty;
                }
            }else{
                if (arrBuyed == nil || arrBuyed.count == 0) {
                    // TODO: 已购买为空 是否单独处理?
                }
                
                if (_rfview != nil) {
                    [self.rfview removeFromSuperview];
                    _rfview = nil;
                    [[NSOperationQueue mainQueue] addOperationWithBlock:^{
                        [self setupMainView];
                    }];
                }
                [self.mainView.allOfBooks.mj_header endRefreshing];
                [self.mainView.bookrack.mj_header endRefreshing];
                
                self.allBookTotalCount = abCount;
                self.bookTotalCount = bbCount;
                self.allBookModels = [NSMutableArray arrayWithArray:arrAll.copy];// 全部图书
                self.bookrackModels = [NSMutableArray arrayWithArray:arrBuyed.copy];// 已购买
                [ECRBookrackDownloadCenter sharedInstance].allBookModels = self.allBookModels;
                [ECRBookrackDownloadCenter sharedInstance].bookrackModels = self.bookrackModels;
                
                [[NSOperationQueue mainQueue] addOperationWithBlock:^{
                    [self.mainView.allOfBooks reloadData];
                    [self.mainView.bookrack reloadData];
                }];
            }
        } failure:^(NSError *error, NSString *msg) {
            if (self.mainView != nil) {
                [self.mainView removeFromSuperview];
                self.mainView = nil;
            }
            if (_rfview == nil) {
                [self.view addSubview:self.rfview];
                _rfview.emptyType = ECRRFViewEmptyTypeDisconnect;
            }else{
                [self.rfview removeFromSuperview];
                _rfview = nil;
                [self.view addSubview:self.rfview];
                _rfview.emptyType = ECRRFViewEmptyTypeDisconnect;
            }
        }];
    } offLine:^{
        [self addRfview];
    }];
    
    
    
}
- (void)setupUI{
    // 默认当前位置为 全部图书
    self.currentPlace = 1;
    self.allBookTotalCount = 0;
    self.bookTotalCount = 0;
    // 设置导航栏右箭头
    [self setNavRightItemsWithState:YES];
    
//    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(floderViewTextFiledTextDidChange:) name:UITextFieldTextDidChangeNotification object:nil];
    [self setupMainView];
    
    // 注册通知
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(loadNewData) name:kNotificationBookrackLoadNewData object:nil];
    [self fk_observeNotifcation:kNotificationUserLogin usingBlock:^(NSNotification *note) {
        [self loadNewData];
    }];
    [self fk_observeNotifcation:kNotificationUserLogout usingBlock:^(NSNotification *note) {
        [self loadNewData];
    }];
    [self userOnLine:^{
        [self.mainView.allOfBooks.mj_header beginRefreshing];
    } offLine:^{
        [self addRfview];
    }];
    self.bslSort = ECRBookShelfListSortDefault;
    
    if (![[CacheDataSource sharedInstance] loadCacheWithCacheKey:CacheKey_NotFirstTimeBookShelf]) {
        [self loadGuideFigure];
    }

}
- (void)addRfview{
    if (_rfview == nil) {
        [self.view addSubview:self.rfview];
        _rfview.emptyType = ECRRFViewEmptyTypeNotLogIn;
    }else{
        [self.rfview removeFromSuperview];
        _rfview = nil;
        [self.view addSubview:self.rfview];
        _rfview.emptyType = ECRRFViewEmptyTypeNotLogIn;
    }
}
- (void)setupMainView{
    [self.view addSubview:self.mainView];
    
    MJRefreshNormalHeader *rfHeader = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        [self loadNewData];
    }];
    rfHeader.lastUpdatedTimeLabel.hidden = YES;
    self.mainView.allOfBooks.mj_header = rfHeader;
    
    MJRefreshNormalHeader *rfbrHeader = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        [self loadNewData];
    }];
    rfbrHeader.lastUpdatedTimeLabel.hidden = YES;
    self.mainView.bookrack.mj_header = rfbrHeader;
}

- (void)setIsEdit_br:(BOOL)isEdit_br{
    _isEdit_br = isEdit_br;
    if (isEdit_br) {
        /// 编辑状态,禁止刷新
        self.mainView.allOfBooks.mj_header.hidden = YES;
        self.mainView.bookrack.mj_header.hidden = YES;
    }else{
        self.mainView.allOfBooks.mj_header.hidden = NO;
        self.mainView.bookrack.mj_header.hidden = NO;
    }
}

#pragma mark - ECRRequestFailuredViewDelegate
- (void)rfViewReloadData:(ECRRequestFailuredView *)view eType:(ECRRFViewEmptyType)etype{

    if (etype == ECRRFViewEmptyTypeNotLogIn) {
//        [self pushToViewControllerWithClassName:@"LoginVC"];
    }else if (etype == ECRRFViewEmptyTypeBookrackEmpty){
        self.tabBarController.selectedIndex = 0;
    }else{
        [self loadNewData];
    }
}

#pragma mark - ECRBookDownloadStateViewDelegate 更新下载状态代理
// MARK: 开始下载
- (void)bdsView:(ECRBookDownloadStateView *)view beginDownloadWithModel:(ECRDownloadStateModel *)model{
    /// 0.修改模型状态
    /// MARK: 1.开始下载,开始（或暂停）下载 在模型内部实现
    [model changeDownloadStateWith:model.modelState progressBlock:^(CGFloat progress) {
        /// 2.设置view 的显示 进度
        [[NSOperationQueue mainQueue] addOperationWithBlock:^{
            if (progress == 100.0) {
                model.modelState = ECRDownloadStateModelStateDownloaded;
                view.model = model;
                [[ECRBookrackDownloadCenter sharedInstance] combineWithdsModel:model];
            }
            view.progress = progress;
        }];
    } failureBlock:^(NSError *error) {
//        [self presentFailureTips:LOCALIZATION(@"下载链接错误")];
        [[NSOperationQueue mainQueue] addOperationWithBlock:^{
            model.modelState = ECRDownloadStateModelStateNormal;
            view.model = model;
            [[ECRBookrackDownloadCenter sharedInstance] combineWithdsModel:model];
        }];
    }];
    view.model = model;
}

#pragma mark - 导航点击代理 ECRBookrackNavMenuViewDelegate
- (void)closeBrnmView:(ECRBookrackNavMenuView *)view{
    [self.menu removeFromSuperview];
    self.menu = nil;
}
- (void)brnmView:(ECRBookrackNavMenuView *)view tb:(BOOL)tb{
    if (tb == 0) {
        // MARK: 导入图书
        NSArray *array = [ECRBRLoadLocalBookModel modelArray];
        ECRInputBookViewController *ibvc = [ECRInputBookViewController new];
        ibvc.array = array;
        [self.navigationController pushViewController:ibvc animated:YES];
    }else{
        // MARK: 时间排序
        if (self.bslSort == ECRBookShelfListSortDefault) {
            self.bslSort = ECRBookShelfListSortBackOrder;
        }else{
            self.bslSort = ECRBookShelfListSortDefault;
        }
        if (self.currentPlace == 1) {
            [self.mainView.allOfBooks.mj_header beginRefreshing];
        }
        if (self.currentPlace == 2) {
            [self.mainView.bookrack.mj_header beginRefreshing];
        }
        
    }
    [self.menu removeFromSuperview];
    self.menu = nil;
}

#pragma mark - 点击底部删除按钮 ECRBookrackEditBottomDelegate
- (void)brebDeleteClick:(ECRBookrackEditBottom *)view{
    if (self.currentPlace == 1) {// 全部图书
        // 如果没有选中任何一本书，则不alert
        if (self.absModels.count == 0) {
        }else{
            self.deboAlert.countForRemove = self.absModels.count;
            [[UIApplication sharedApplication].keyWindow addSubview:self.deboAlert];
//            [self.view addSubview:self.deboAlert];
        }
    }
    if (self.currentPlace == 2) {// 已购买
        // 如果没有选中任何一本书，则不alert
        if (self.modelsWillBeRemove.count == 0) {
            
        }else{
            self.deboAlert.countForRemove = self.modelsWillBeRemove.count;
            [[UIApplication sharedApplication].keyWindow addSubview:self.deboAlert];
        }
    }
    
}
// MARK: 全选
- (void)allSelected{
    // 全选时,要区分 全部图书  与  已购买
    // 点击之前的三种情况
    // situation A 全部未选中
    // situation B 部分选中，部分未选中
    // situation C 全部选中
    
    if (self.currentPlace == 1) {// 全部图书
        // 1修改模型状态
        if (self.absModels.count < self.allBookTotalCount || self.absModels.count == 0) {
            //  situation A & situation B
            for (NSInteger i = 0; i < self.allBookModels.count; i++) {
                ECRBookrackModel *modelOutside = self.allBookModels[i];
                if (!modelOutside.isSelected) {
                    modelOutside.isSelected = YES;
                    [self.absModels addObject:modelOutside];
                }
                if (modelOutside.books.count != 0) {// 分组
                    [self.absModels removeObject:modelOutside];// 删除文件夹模型
                    for (NSInteger j = 0; j < modelOutside.books.count; j++) {
                        ECRBookrackModel *modelInside = modelOutside.books[j];
                        if (!modelInside.isSelected) {
                            modelInside.isSelected = YES;
                            [self.absModels addObject:modelInside];
                        }
                    }
                }
            }
        }else if (self.absModels.count == self.allBookTotalCount) {
            // situation C
            for (NSInteger i = 0; i < self.allBookModels.count; i++) {
                ECRBookrackModel *modelOutside = self.allBookModels[i];
                modelOutside.isSelected = NO;
                if (modelOutside.books.count != 0) {
                    for (NSInteger j = 0; j < modelOutside.books.count; j++) {
                        ECRBookrackModel *modelInside = modelOutside.books[j];
                        modelInside.isSelected = NO;
                    }
                }
            }
            [self.absModels removeAllObjects];
            self.absModels = nil;
        }
        if (self.absModels.count > self.allBookTotalCount) {// 异常状态
            [self.absModels removeAllObjects];
            NSLog(@"异常 -- ");
        }
        NSLog(@"全部图书选中 - %ld - ,书籍总数 -- %ld",self.absModels.count,self.allBookTotalCount);
    }
    if (self.currentPlace == 2) {// 已购买
        // 1修改模型状态
        if (self.modelsWillBeRemove.count < self.bookTotalCount || self.modelsWillBeRemove.count == 0) {
            //  situation A & situation B
            for (NSInteger i = 0; i < self.bookrackModels.count; i++) {
                ECRBookrackModel *modelOutside = self.bookrackModels[i];
                if (!modelOutside.isSelected) {
                    modelOutside.isSelected = YES;
                    [self.modelsWillBeRemove addObject:modelOutside];
                }
                if (modelOutside.alreadyBuyBooks.count != 0) {
                    [self.modelsWillBeRemove removeObject:modelOutside];// 删除文件夹模型
                    for (NSInteger j = 0; j < modelOutside.alreadyBuyBooks.count; j++) {
                        ECRBookrackModel *modelInside = modelOutside.alreadyBuyBooks[j];
                        if (!modelInside.isSelected) {
                            [self.modelsWillBeRemove addObject:modelInside];
                            modelInside.isSelected = YES;
                        }
                    }
                }
            }
        }else if (self.modelsWillBeRemove.count == self.bookTotalCount) {
            // situation C
            for (NSInteger i = 0; i < self.bookrackModels.count; i++) {
                ECRBookrackModel *modelOutside = self.bookrackModels[i];
                modelOutside.isSelected = NO;
                if (modelOutside.alreadyBuyBooks.count != 0) {
                    for (NSInteger j = 0; j < modelOutside.alreadyBuyBooks.count; j++) {
                        ECRBookrackModel *modelInside = modelOutside.alreadyBuyBooks[j];
                        modelInside.isSelected = NO;
                    }
                }
            }
            [self.modelsWillBeRemove removeAllObjects];
            self.modelsWillBeRemove = nil;
        }
        if (self.modelsWillBeRemove.count > self.bookTotalCount) {// 异常状态
            [self.modelsWillBeRemove removeAllObjects];
            NSLog(@"异常 -- ");
        }
        NSLog(@"已购买 选中 - %ld - ,书籍总数 -- %ld",self.modelsWillBeRemove.count,self.bookTotalCount);
    }
    //2 刷新UI
    [self bookrackAndFloderReloadData];// floder.collectionview reload 2
}

#pragma mark - 点击确定删除 ECRBrebAlertViewDelegate
- (void)brebAlert:(ECRBrebAlertView *)view clickEvent:(BOOL)isDelete{
    if (isDelete) {
        if (self.currentPlace == 1) {// 全部图书
            // MARK: 删除选中的书籍
            NSMutableArray *deleteBooks = [NSMutableArray new];
            for (NSInteger i = self.allBookModels.count - 1; i >= 0; i--) {
                ECRBookrackModel *model = self.allBookModels[i];
                if (model.books.count > 0) {
                    for (NSInteger j = model.books.count - 1; j >= 0; j--) {
//                        NSLog(@"books -- %ld",model.books.count);
                        ECRBookrackModel *modelInFile = model.books[j];
                        if (modelInFile.isSelected) {
                            // 删除 --> 等循环结束再执行
                            [deleteBooks addObject:modelInFile];
                            [self.floderView.bookModels removeObject:modelInFile];
                            [model.books removeObject:modelInFile];
                            [self.absModels removeObject:modelInFile];
                        }
                        if (model.books.count == 0) {/// 表明分组中已经没有书籍
                            /// 调用删除分组接口,删除分组数据
                            [ECRBookrackDataHandler bookShelfDeleteGroupWithGroupId:model.groupId success:^(id objc) {
                               NSLog(@"删除分组成功 -- %@",objc);
                                [self.allBookModels removeObject:model];/// 删除该分组模型
                                [self.absModels removeObject:model];///
                            } failure:^(NSError *error, NSString *msg) {
                                NSLog(@"删除分组失败 -- %@",msg);
                            }];
                        }
                    }
                    
                }
                if (model.isSelected) {
                    // 删除 --> 等循环结束再执行
                    [deleteBooks addObject:model];
                    [self.allBookModels removeObject:model];
                    [self.absModels removeObject:model];
                }
            }
            [self bookshelfDeleteBooksFromGroup:deleteBooks];
        }
        if (self.currentPlace == 2) {// 已购买
            NSMutableArray *deleteBooks = [NSMutableArray new];
            // MARK: 删除选中的书籍
            for (NSInteger i = self.bookrackModels.count - 1; i >= 0; i--) {
                ECRBookrackModel *model = self.bookrackModels[i];
                if (model.alreadyBuyBooks.count > 0) {
                    for (NSInteger j = model.alreadyBuyBooks.count - 1; j >= 0; j--) {
//                        NSLog(@"alreadyBuyBooks -- %ld",model.alreadyBuyBooks.count);
                        ECRBookrackModel *modelInFile = model.alreadyBuyBooks[j];
                        if (modelInFile.isSelected) {
                            // 删除 --> 等循环结束再执行
                            [deleteBooks addObject:modelInFile];
                            [self.floderView.bookModels removeObject:modelInFile];
                            [model.alreadyBuyBooks removeObject:modelInFile];
                            [self.modelsWillBeRemove removeObject:modelInFile];
//                            NSLog(@"model.bookname -- %@",model.bookName);
                        }
                        if (model.alreadyBuyBooks.count == 0) {
                            [ECRBookrackDataHandler bookShelfDeleteGroupWithGroupId:model.groupId success:^(id objc) {
                                NSLog(@"删除分组成功 -- %@",objc);
                                [self.bookrackModels removeObject:model];
                                [self.modelsWillBeRemove removeObject:model];
                            } failure:^(NSError *error, NSString *msg) {
                                NSLog(@"删除分组失败 -- %@",msg);
                            }];
                        }
                    }
                }
                if (model.isSelected) {
                    // 删除 --> 等循环结束再执行
                    [deleteBooks addObject:model];
                    [self.bookrackModels removeObject:model];
                    [self.modelsWillBeRemove removeObject:model];
                }
            }
            [self bookshelfDeleteBooksFromGroup:deleteBooks];
        }
        
        // 刷新
        [self bookrackAndFloderReloadData];// floder.collectionview reload 3
    }else{
        // 取消
        
    }
    [self.deboAlert removeFromSuperview];
    self.deboAlert = nil;
    
}
// MARK: 确定删除
- (void)bookshelfDeleteBooksFromGroup:(NSArray *)deleteBooks{
    [ECRBookrackDataHandler bookshelfDeleteBooksFromGroup:deleteBooks success:^(id objc) {
        NSLog(@" 删除成功 --  line 417");
        for (ECRBookrackModel *model in deleteBooks) {
            if (model.eBookFormat == BookModelBookFormatEPUB) {
                [ECRLocalFileManager deleteLocalFileWithPath:model.localEpubEncodePath];
            }else{
                [ECRLocalFileManager deleteLocalFileWithPath:model.localURL];
            }
            
        }
        
        [self editDoneFunc];
        [self loadNewData];
    } failure:^(NSError *error, NSString *msg) {
        [self presentFailureTips:msg];
    }];
}

#pragma mark - 编辑状态下 选中书籍
- (void)brCellBookEditDidClick:(ECRBookrackCollectionViewCell *)cell inx:(NSIndexPath *)inx model:(ECRBookrackModel *)model{
    if (self.floderView != nil) {
//        [self.floderView.collectionView reloadItemsAtIndexPaths:@[inx]];
        if (self.currentPlace == 1) {// 全部图书
            [self commenCellBookEditDidClickModel:model index:inx array:self.absModels collectionView:self.floderView.collectionView];
        }
        if (self.currentPlace == 2) {// 已购买
            [self commenCellBookEditDidClickModel:model index:inx array:self.modelsWillBeRemove collectionView:self.floderView.collectionView];
        }
    }else{
        if (self.currentPlace == 1) {// 全部图书
            [self commenCellBookEditDidClickModel:model index:inx array:self.absModels collectionView:self.mainView.allOfBooks];
        }
        if (self.currentPlace == 2) {// 已购买
            [self commenCellBookEditDidClickModel:model index:inx array:self.modelsWillBeRemove collectionView:self.mainView.bookrack];
        }
    }
}
- (void)commenCellBookEditDidClickModel:(ECRBookrackModel *)model index:(NSIndexPath *)inx array:(NSMutableArray *)array collectionView:(UICollectionView *)collectionView{
    if (model.isSelected) {
        [array addObject:model];
    }else{
        [array removeObject:model];
    }
    [collectionView reloadItemsAtIndexPaths:@[inx]];
}

#pragma mark - 文件夹代理 ECRFloderViewDelegate
- (void)floderViewClose:(ECRFloderView *)floderView{
    // MARK: 关闭正在下载的下载请求
    // 是否需要先提示用户正在下载,确认退出?
    if (self.currentPlace == 1) {
        [self floderViewCancelDownloadTaskWith:self.currentFloderModel.books];
    }else{
        [self floderViewCancelDownloadTaskWith:self.currentFloderModel.alreadyBuyBooks];
    }
    [self.navigationController setNavigationBarHidden:NO animated:NO];
    if (self.floderView != nil) {
        [self.floderView removeFromSuperview];
        self.floderView = nil;
    }
    [self.mainView.bookrack reloadData];
}
- (void)floderViewCancelDownloadTaskWith:(NSArray<ECRBookrackModel *> *)array{
    [array enumerateObjectsUsingBlock:^(ECRBookrackModel * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        [obj.dsModel cancelCurrentDownloadTask];
    }];
}

// 文件夹中点击完成, 退出编辑状态
- (void)floderViewEndEdit:(ECRFloderView *)floderView{
    [self editDoneFunc];
}
// MARK: 文件夹全选
- (void)floderViewAllSelect:(ECRFloderView *)floderView{
    if (self.currentPlace == 1) {// 全部图书
        [self fvasWithArray:self.absModels];
    }
    if (self.currentPlace == 2) {// 已购买
        [self fvasWithArray:self.modelsWillBeRemove];
    }
    [self.floderView.collectionView reloadData];// self.floderView.collectionView reloaddata 1
}
- (void)fvasWithArray:(NSMutableArray *)array{
    // situation A 全部未选中
    // situation B 部分选中，部分为选中
    // situation C 全部选中
    // 先判断是哪种 情况,B 和 A合为一种情况
    BOOL situationC = YES;
    for (NSInteger i = 0; i < self.currentFloderModel.books.count; i++) {
        ECRBookrackModel *model = self.currentFloderModel.books[i];
        if (!model.isSelected) {
            situationC = NO;
            break;
        }
    }
    if (situationC) {//
        for (NSInteger i = 0; i < self.currentFloderModel.books.count; i++) {
            ECRBookrackModel *model = self.currentFloderModel.books[i];
            if (model.isSelected) {
                // 把已经加到数组中的模型删除
                [array removeObject:model];
            }
            model.isSelected = NO;
        }
    }else{
        for (NSInteger i = 0; i < self.currentFloderModel.books.count; i++) {
            ECRBookrackModel *model = self.currentFloderModel.books[i];
            if (!model.isSelected) {
                // 把没加的加进去
                [array addObject:model];
            }
            model.isSelected = YES;
        }
    }
}

#pragma mark - collectionView delegate
- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    ECRBookrackModel *model;
    if (self.currentPlace == 1) {// 全部图书
        model = self.currentFloderModel.books[indexPath.row];
    }else{
        model = self.currentFloderModel.alreadyBuyBooks[indexPath.row];
    }
    [self readBookWithBookModel:model];
}

#pragma mark - 点击书本或者文件夹 ECRBookrackViewDelegate
- (void)brView:(ECRBookrackView *)brViiew didSelectBookrack:(UICollectionView *)collectionView indexPath:(NSIndexPath *)indexPath{
    if ([collectionView isEqual:_mainView.allOfBooks]) {
        ECRBookrackModel *model = self.allBookModels[indexPath.item];
        [self brDidSelectedWithModel:model indexPath:indexPath collectionView:collectionView floderArray:model.books];
    }else{
        ECRBookrackModel *model = self.bookrackModels[indexPath.item];
        [self brDidSelectedWithModel:model indexPath:indexPath collectionView:collectionView floderArray:model.alreadyBuyBooks];
    }
}
- (void)brDidSelectedWithModel:(ECRBookrackModel *)model indexPath:(NSIndexPath *)indexPath collectionView:(UICollectionView *)collectionView floderArray:(NSMutableArray *)floderArray{
    if (floderArray.count != 0) {// 文件夹
        [self.navigationController setNavigationBarHidden:YES animated:NO];
        [self openFloderWithModel:model collectionView:collectionView];
    }else{
        // MARK: 阅读书籍
        [self readBookWithBookModel:model];
    }
}
- (void)openFloderWithModel:(ECRBookrackModel *)model collectionView:(UICollectionView *)collectionView{
    // MARK: 打开文件夹(全部图书)
    if (_floderView == nil) {
        ECRBookFloderLayout *brLayout = [[ECRBookFloderLayout alloc] init];
        brLayout.flssDelegate = self;
        _floderView = [[ECRFloderView alloc] initWithFrame:CGRectZero flowLayout:brLayout];
        _floderView.delegate = self;
        [self.view addSubview:_floderView];
        _floderView.fileName = model.name;
        NSLog(@"文件夹名 -- %@",model.name);
        if ([collectionView isEqual:_mainView.allOfBooks]) {// 全部图书
            _floderView.bookModels = model.books;
        }else{// 已购买
            _floderView.bookModels = model.alreadyBuyBooks;
        }
        
        _floderView.collectionView.dataSource = self;
        _floderView.collectionView.delegate = self;
        _floderView.isEdit_br = self.isEdit_br;// 控制文件夹view 全选按钮的显示0
        _floderView.floderName.delegate = self;
        self.currentFloderModel = model;
        [_floderView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.edges.equalTo(self.view);
        }];
    }
}

- (void)readBookWithBookModel:(ECRBookrackModel *)model{
    if (model.dsModel.modelState < 4) {
        NSLog(@"还未下载完成, 请稍后 -- ");
        // 再次启动app后, 下载状态异常问题亟待修复
    }else{
//        [self editDoneFunc];
        // MARK: 读书,阅读,读取书籍文件
        if (model.eBookFormat == BookModelBookFormatEPUB) {
            [LGCryptor decryptWithEncodePath:model.localEpubEncodePath decodePath:model.localURL success:^(NSString *path) {
                // 打开 解密后的epub 文件
                [ECRBookReaderManager readBookWithType:model.eBookFormat localURL:path vc:self bookModel:model ymeBook:model.ymeBook readFailure:^(id info) {
                    // 请先下载书籍
                    NSLog(@"readfailure -- %@",info);
                    //        [self presentfai]
                }];
            } failure:^(NSError *error) {
                
            }];
        }else{
            [ECRBookReaderManager readBookWithType:model.eBookFormat localURL:model.localURL vc:self bookModel:model ymeBook:model.ymeBook readFailure:^(id info) {
                // 请先下载书籍
                NSLog(@"readfailure -- %@",info);
                //        [self presentfai]
            }];
        }
    }
}

// MARK: 左右滑动
- (void)brViewDidSwitch:(ECRBookrackView *)brViiew place:(NSInteger)place{
    self.currentPlace = place;
//    NSLog(@"currentplace -- %ld",place);
}

#pragma mark - UICollectionViewDataSource
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    if ([collectionView isEqual:_mainView.bookrack]) {
        return _bookrackModels.count;
    }
    if ([collectionView isEqual:_floderView.collectionView]) {
        return _floderView.bookModels.count;
    }
    if ([collectionView isEqual:_mainView.allOfBooks]) {
        return _allBookModels.count;
    }
    return 0;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    if ([collectionView isEqual:_mainView.bookrack]) {
        return [self brCellWithCollectionView:collectionView indexPath:indexPath array:self.bookrackModels];
    }
    if ([collectionView isEqual:_floderView.collectionView]) {
        return [self brCellWithCollectionView:collectionView indexPath:indexPath array:self.floderView.bookModels];
    }
    if ([collectionView isEqual:_mainView.allOfBooks]) {
        return [self brCellWithCollectionView:collectionView indexPath:indexPath array:self.allBookModels];
    }
    return nil;
}
- (ECRBookrackCollectionViewCell *)brCellWithCollectionView:(UICollectionView *)collectionView indexPath:(NSIndexPath *)indexPath array:(NSMutableArray *)array{
    ECRBookrackModel *model;
    ECRBookrackCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:ECRBookrackcell forIndexPath:indexPath];
    cell.inx  = indexPath;
    cell.bdsView.delegate = self;
    cell.delegate = self;
    if (array.count == 0) {
    }else{
        model = array[indexPath.item];
        cell.model = model;
    }
    return cell;
}

#pragma mark - 进入编辑状态 ECRBookrackFlowLayoutSwitchStateDelegate
- (void)brflayout:(ECRBookrackFlowLayout *)flowLayout beginEditWithModel:(ECRBookrackModel *)model doneBlock:(void (^)())doneBlock {
    
    if (self.isEdit_br) {
        
    }else{
        [self brModelChangeStateWith:YES];
        self.isEdit_br = YES;
        // 修改 UI
        // 1.tabbar
        [self rg_setTabbarHidden:YES];
        // 2.nav
        [self setNavRightItemsWithState:NO];
        self.editDoneBlock = doneBlock;
    }
}

// MARK: 从文件夹中移除书籍时 调用
- (void)brflayout:(ECRBookrackFlowLayout *)flowLayout outOfFloderWithModel:(ECRBookrackModel *)model currentView:(UIView *)currentView frame:(CGRect)frame{// 传过来的 currentView 是一个快照、快照没有xy
    
    // MARK: 调取 管理书架接口, 从分组中删除书籍
    [ECRBookrackDataHandler bookShelfDeleteABookFromGroupWithBookId:model.bookId groupId:self.currentFloderModel.groupId groupName:self.currentFloderModel.groupName success:^(id objc) {
        NSLog(@"从分组中删除书籍 --  %@",objc);
        
        
        // 从文件夹中删除该对象
        [self.floderView.bookModels removeObject:model];
        
        [[NSOperationQueue mainQueue] addOperationWithBlock:^{
            // 删除 floderview
            [self floderViewClose:nil];
        }];
        
        if (self.currentPlace == 1) {// 全部图书
            [self.allBookModels insertObject:model atIndex:0];
            [self.mainView.allOfBooks reloadData];
        }
        if (self.currentPlace == 2) {// 已购买
            [self.bookrackModels insertObject:model atIndex:0];
            [self.mainView.bookrack reloadData];
        }
        // 删除分组
        [self deleteGroup:self.currentFloderModel];
        
//        // 添加至书架默认
//        [ECRBookrackDataHandler bookShelfAddBookToBookrackWithBookId:model.bookId success:^(id objc1) {
//            NSLog(@"加入书架默认界面成功 -- %@",objc1);
//
//
//        } failure:^(NSError *error, NSString *msg) {
//
//        }];
    } failure:^(NSError *error, NSString *msg) {
        [self presentFailureTips:msg];
    }];
}
- (void)deleteGroup:(ECRBookrackModel *)group{
    BOOL delete = NO;
    if (self.currentPlace == 1) {// 全部图书
        if (group.books.count == 0) {
            delete = YES;
        }
    }else{
        if (group.alreadyBuyBooks.count == 0) {
            delete = YES;
        }
    }
    if (delete) {
        [ECRBookrackDataHandler bookShelfDeleteGroupWithGroupId:group.groupId success:^(id objc) {
            NSLog(@"删除group成功 -- %@",objc);
            [[NSOperationQueue mainQueue] addOperationWithBlock:^{
                if (self.currentPlace == 1) {// 全部图书
                    [self.allBookModels removeObject:group];
                    [self.mainView.allOfBooks reloadData];
                }else{
                    [self.bookrackModels removeObject:group];
                    [self.mainView.bookrack reloadData];
                }
            }];
        } failure:^(NSError *error, NSString *msg) {
            NSLog(@"删除group失败 error %@ -- msg %@",error,msg);
        }];
    }
}

#pragma mark - LXReorderableCollectionViewDataSource
- (void)collectionView:(UICollectionView *)collectionView itemAtIndexPath:(NSIndexPath *)fromIndexPath didMoveToIndexPath:(NSIndexPath *)toIndexPath{
    // 完成移动时执行
    [collectionView reloadData];
}

- (void)collectionView:(UICollectionView *)collectionView itemAtIndexPath:(NSIndexPath *)fromIndexPath willMoveToIndexPath:(NSIndexPath *)toIndexPath{
    if ([collectionView isEqual:_mainView.bookrack]) {
        ECRBookrackModel *fromModel = _bookrackModels[fromIndexPath.item];
        //        ECRBookrackModel *toModel = _bookrackModels[toIndexPath.item];
        [_bookrackModels removeObjectAtIndex:fromIndexPath.item];
        [_bookrackModels insertObject:fromModel atIndex:toIndexPath.item];
    }else if([collectionView isEqual:_mainView.allOfBooks]){
        ECRBookrackModel *fromModel = _allBookModels[fromIndexPath.item];
        [_allBookModels removeObjectAtIndex:fromIndexPath.item];
        [_allBookModels insertObject:fromModel atIndex:toIndexPath.item];
    }else{
        ECRBookrackModel *fromModel = _floderView.bookModels[fromIndexPath.item];
        [_floderView.bookModels removeObjectAtIndex:fromIndexPath.item];
        [_floderView.bookModels insertObject:fromModel atIndex:toIndexPath.item];
    }
    
}

// MARK: 移动书籍 & 调用接口
- (void)collectionView:(UICollectionView *)collectionView deleteItemAndModelAtIndexPath:(NSIndexPath *)fromIndexPath insertModel:(ECRBookrackModel *)model toIndexPath:(NSIndexPath *)toIndexPath{
    if ([collectionView isEqual:_mainView.bookrack]) {// 已购买
//        self.bookrackModels
        [self bookrackDeleteItemAndModelWithModel:model
                                    fromIndexPath:fromIndexPath
                                      toIndexPath:toIndexPath
                                        dataArray:self.bookrackModels sucess:^{
                                            [_mainView.bookrack reloadData];
                                        }];
    }
    if ([collectionView isEqual:_mainView.allOfBooks]) {// 全部图书
        [self bookrackDeleteItemAndModelWithModel:model
                                    fromIndexPath:fromIndexPath
                                      toIndexPath:toIndexPath
                                        dataArray:self.self.allBookModels sucess:^{
                                            [_mainView.allOfBooks reloadData];
                                        }];
    }
}
- (void)bookrackDeleteItemAndModelWithModel:(ECRBookrackModel *)model fromIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath dataArray:(NSMutableArray *)datas sucess:(void(^)())sucess{
    if (model == nil) {// 如果model为nil, 那么toIndex的模型为文件夹类型
        ECRBookrackModel *book = datas[fromIndexPath.item];
        ECRBookrackModel *group = datas[toIndexPath.item];
        [ECRBookrackDataHandler bookShelfAddBookToGroup:book groupModel:group success:^(id objc) {
            NSLog(@"加入成功 -- %@",objc);
        } failure:^(NSError *error, NSString *msg) {
            NSLog(@"加入失败error:%@ -- msg: %@",error,msg);
        }];
        [datas removeObjectAtIndex:fromIndexPath.item];
    }else{
        ECRBookrackModel *fromModel = datas[fromIndexPath.item];
        ECRBookrackModel *toModel = datas[toIndexPath.item];
        [ECRBookrackDataHandler bookShelfDoubleBooksToNewGroupWithFromModel:fromModel toModel:toModel success:^(id objc) {
            NSLog(@"合并成功 -- %@",objc);
            model.groupId = [objc[@"groupId"] integerValue];
            NSLog(@"model.groupid -- %ld",model.groupId);
            [[NSOperationQueue mainQueue] addOperationWithBlock:^{
                [UIView animateWithDuration:0.5 animations:^{
                    if (fromIndexPath.item < toIndexPath.item) {// 从前往后添加
                        [datas removeObjectAtIndex:fromIndexPath.item];
                        [datas removeObjectAtIndex:(toIndexPath.item - 1)];
                        [datas insertObject:model atIndex:(toIndexPath.item - 1)];
                    }else{// 从后往前添加
                        [datas removeObjectAtIndex:fromIndexPath.item];
                        [datas removeObjectAtIndex:toIndexPath.item];
                        [datas insertObject:model atIndex:toIndexPath.item];
                    }
                } completion:^(BOOL finished) {
                    if (sucess) {
                        sucess();
                    }    
                }];
            }];
            
        } failure:^(NSError *error, NSString *msg) {
            NSLog(@"合并失败 error:%@ -- msg: %@",error,msg);
        }];
        
    }
}

- (BOOL)collectionView:(UICollectionView *)collectionView itemAtIndexPath:(NSIndexPath *)fromIndexPath canMoveToIndexPath:(NSIndexPath *)toIndexPath{
    return YES;
}
- (BOOL)collectionView:(UICollectionView *)collectionView canMoveItemAtIndexPath:(NSIndexPath *)indexPath{
    return YES;
}

#pragma mark - UICollectionViewDelegateFlowLayout
// 定义每个Section的四边间距
- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout insetForSectionAtIndex:(NSInteger)section{
    if ([collectionView isEqual:_floderView.collectionView]) {
        return UIEdgeInsetsMake(10, 0, 10, 0);//分别为上、左、下、右
    }
    return UIEdgeInsetsZero;
}
#pragma mark - UITextFieldDelegate & UITextFieldTextDidChangeNotification
// MARK: 修改 文件名
- (BOOL)textFieldShouldReturn:(UITextField *)textField{
    if (textField.text == nil || [textField.text isEqualToString:@""]) {
        [self presentFailureTips:LOCALIZATION(@"分组名称不能为空")];
    }else{
        //    [self modifiFileNameWithText:textField.text];
        [ECRBookrackDataHandler bookShelfUpdateGroupNameWithGroupId:self.currentFloderModel.groupId groupName:textField.text success:^(id objc){
            NSLog(@"修改分组名称成功 -- ");
            // 1 修改模型数据
            [self modifiFileNameWithText:textField.text];
            // 2 刷新UI
            if (self.currentPlace == 1) {
                [[NSOperationQueue mainQueue] addOperationWithBlock:^{
                    [self.mainView.allOfBooks reloadData];
                }];
            }
            if (self.currentPlace == 2) {
                [[NSOperationQueue mainQueue] addOperationWithBlock:^{
                    [self.mainView.bookrack reloadData];
                }];
            }
            
        } failure:^(NSError *error, NSString *msg) {
            NSLog(@"error -- %@",error);
            NSLog(@"msg -- %@",msg);
        }];
        [self.floderView endEditing:YES];
    }
    return YES;
}
//- (void)floderViewTextFiledTextDidChange:(NSNotification *)notification{
//
//}

- (void)setNavRightItemsWithState:(BOOL)normal{
    if (normal) {
        // ```
        UIBarButtonItem *menuItem = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"icon_menu"] style:UIBarButtonItemStyleDone target:self action:@selector(menuDropDown)];
        
        // 搜索
        UIBarButtonItem *searchItem = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"icon_search_white"] style:UIBarButtonItemStyleDone target:self action:@selector(bookrackSearch)];
        
        self.navigationItem.leftBarButtonItem = nil;
        self.navigationItem.rightBarButtonItems = @[menuItem,searchItem];
    }else{
        if (self.navigationItem.rightBarButtonItems.count == 2) {
            self.navigationItem.rightBarButtonItems = nil;
            
            UIBarButtonItem *allSelectItem = [[UIBarButtonItem alloc] initWithTitle:LOCALIZATION(@"全选") style:UIBarButtonItemStylePlain target:self action:@selector(allSelected)];
            self.navigationItem.leftBarButtonItem = allSelectItem;
            UIBarButtonItem *doneItem = [[UIBarButtonItem alloc] initWithTitle:LOCALIZATION(@"完成") style:UIBarButtonItemStylePlain target:self action:@selector(editDoneFunc)];
            self.navigationItem.rightBarButtonItem = doneItem;
        }
    }
}
- (void)menuDropDown{// 展开下拉菜单
    if (self.menu == nil) {
        ECRBookrackNavMenuView *menu = [ECRBookrackNavMenuView bookrackNavMenuView];
        menu.delegate = self;
//        menu.backgroundColor = [UIColor clearColor];
        menu.frame = CGRectMake(0, 0, Screen_Width, Screen_Height);
        [[UIApplication sharedApplication].keyWindow addSubview:menu];
        self.menu = menu;
    }
}
- (void)bookrackSearch{
    // MARK: 弹出搜索视图
    
    [self.tabBarController presentViewController:[ECRSearchBooksViewController searchBooksNav:self closeBlock:^{
        self.tabBarController.tabBar.hidden = NO;
    }]
                                        animated:YES
                                      completion:^{
                                          self.tabBarController.tabBar.hidden = YES;
                                      }];
}
// 结束编辑
- (void)editDoneFunc{
    // 0.如果删除alert view 存在，删除
    if (self.deboAlert != nil) {
        [self.deboAlert removeFromSuperview];
        self.deboAlert = nil;
    }
    // 1.显示tabbar
    [self rg_setTabbarHidden:NO];
    // 2.修改导航 UI
    [self setNavRightItemsWithState:YES];
    // 3.修改模型状态
    [self brModelChangeStateWith:NO];
    // 4.回调,告诉flow layout 结束 编辑
    if (self.editDoneBlock) {
        self.editDoneBlock();
    }
    // 5.结束编辑状态
    self.isEdit_br = NO;
    
    // 删除 选中数组
    [self.absModels removeAllObjects];
    _absModels = nil;
    [self.modelsWillBeRemove removeAllObjects];
    _modelsWillBeRemove = nil;
}
- (void)brModelChangeStateWith:(BOOL)isEdit{
    // 已购买
    for (ECRBookrackModel *model in self.bookrackModels) {
        model.isEditState = isEdit;
        model.isSelected = NO;
        if (model.alreadyBuyBooks.count) {
            for (ECRBookrackModel *modelInFile in model.alreadyBuyBooks) {
                modelInFile.isEditState = isEdit;
                modelInFile.isSelected = NO;
//                NSLog(@"-- -- %d",modelInFile.isEditState);
            }
        }
    }
    // 全部图书
    for (ECRBookrackModel *model in self.allBookModels) {
        model.isEditState = isEdit;
        model.isSelected = NO;
        if (model.books.count) {
            for (ECRBookrackModel *modelInFile in model.books) {
                modelInFile.isEditState = isEdit;
                modelInFile.isSelected = NO;
                //                NSLog(@"-- -- %d",modelInFile.isEditState);
            }
        }
    }
    [self bookrackAndFloderReloadData];// floder.collectionview reload 4
}
- (void)bookrackAndFloderReloadData{
    //
    [[NSOperationQueue mainQueue] addOperationWithBlock:^{
        [UIView animateWithDuration:0 animations:^{
            [self.mainView.bookrack reloadData];
            [self.mainView.allOfBooks reloadData];
//            [self.mainView.bookrack performBatchUpdates:^{
//            } completion:nil];
        }];
        if (self.floderView != nil) {
            [UIView animateWithDuration:0 animations:^{
                [self.floderView.collectionView reloadData];
            }];
        }
    }];
}
// 显示，或者隐藏tabbar
- (void)rg_setTabbarHidden:(BOOL)isHidden{// YES:隐藏，NO 显示
    [self.tabBarController.tabBar setHidden:isHidden];
    self.floderView.isEdit_br = isHidden;// 控制文件夹view 全选按钮的显示1
    if (isHidden) {
        // 添加 “删除“按钮
        self.breBottom = [[ECRBookrackEditBottom alloc] initWithFrame:CGRectMake(0, Screen_Height - 49, Screen_Width, 49)];
        self.breBottom.delegate = self;
        [[UIApplication sharedApplication].keyWindow addSubview:self.breBottom];
    }else{
        // 移除 ”删除“按钮
        [self.breBottom removeFromSuperview];
        self.breBottom = nil;
    }
}
- (void)createNavLeftBackItem{
    
}
- (void)modifiFileNameWithText:(NSString *)newName{
    // 1.
    self.currentFloderModel.name = newName;
    // 2.
    self.floderView.fileName = newName;
}

- (NSMutableArray<ECRBookrackModel *> *)modelsWillBeRemove{
    if (_modelsWillBeRemove == nil) {
        _modelsWillBeRemove = [NSMutableArray arrayWithCapacity:10];
    }
    return _modelsWillBeRemove;
}
- (NSMutableArray<ECRBookrackModel *> *)absModels{
    if (_absModels == nil) {
        _absModels = [NSMutableArray arrayWithCapacity:10];
    }
    return _absModels;
}
- (ECRBrebAlertView *)deboAlert{
    if (_deboAlert == nil) {
        _deboAlert = [[ECRBrebAlertView alloc] initWithFrame:Screen_Bounds];
        _deboAlert.delegate = self;
    }
    return _deboAlert;
}
- (ECRRequestFailuredView *)rfview{
    if (_rfview == nil) {
        _rfview = [[ECRRequestFailuredView alloc] initWithFrame:self.view.bounds];
        _rfview.delegate = self;
    }
    return _rfview;
}
- (ECRBookrackView *)mainView{
    if (_mainView == nil) {
        ECRBookrackFlowLayout *brLayout = [[ECRBookrackFlowLayout alloc] init];// 已购买
        brLayout.flssDelegate =  self;
        brLayout.currentPlace = 2;
        ECRBookrackFlowLayout *abLayout = [[ECRBookrackFlowLayout alloc] init];// 全部图书
        abLayout.flssDelegate = self;
        abLayout.currentPlace = 1;
        _mainView          = [[ECRBookrackView alloc]
                              initWithFrame:self.view.bounds
                              flowLayout:brLayout
                              abLayout:abLayout];
        _mainView.delegate = self;
        _mainView.bookrack.dataSource = self;
        _mainView.allOfBooks.dataSource = self;
    }
    return _mainView;
}

- (void)didReceiveMemoryWarning{
    [super didReceiveMemoryWarning];
    [[SDImageCache sharedImageCache] setValue:nil forKey:@"memCache"];
}
- (void)dealloc{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}



@end


