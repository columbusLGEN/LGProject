//
//  ECRShoppingCarViewController.m
//  EasyChineseReading-ios
//
//  Created by lee on 2017/8/31.
//  Copyright © 2017年 lee. All rights reserved.
//

/*
    购物车:
        状态:
            1.空
            2.非空
                2.1 有勾选商品
                2.2 无勾选商品
        跳转
            1.商品详情
            2.订单页面
 
 */

static NSString *reuserID = @"ECRShoppingCarCell";
static CGFloat sdvHeight = 50;// 结算view 高度

#import "ECRShoppingCarViewController.h"
#import "ECRShoppingCarCell.h"
#import "ECRShoppingCarModel.h"
#import "ECRSettleDoneView.h"
#import "ECRBookInfoViewController.h"// 商品详情控制器
#import "ECRSettleAccountsModel.h"// 结算模型
#import "ECRBookFormViewController.h"
#import "ECRShoppingCarManager.h"
#import "ECRFullminusModel.h"
#import "ECRRequestFailuredView.h"

@interface ECRShoppingCarViewController ()<
UITableViewDataSource,
UITableViewDelegate,
ECRShoppingCarCellDelegate,
ECRSettleDoneViewDelegate,
UIAlertViewDelegate,
ECRBookFormViewControllerDelegate,
ECRRequestFailuredViewDelegate
>
@property (strong,nonatomic) NSMutableArray<ECRShoppingCarModel *> *totalArray;// 商品数组(可变,方便删减物品)
@property (strong,nonatomic) NSMutableArray<ECRShoppingCarModel *> *tickedArray;// 勾选商品数组
@property (assign,nonatomic) CGFloat totalPrice;// 勾选商品总价

@property (strong,nonatomic) UITableView *list;
/** 底部结算view */
@property (strong,nonatomic) ECRSettleDoneView *settleDoneView;
@property (assign,nonatomic) CGFloat rowH;//

/** 加载view */
@property (strong,nonatomic) MBProgressHUD *loadDataHUD;
/** 购物车为空时显示 */
@property (strong,nonatomic) ECRRequestFailuredView *cartEmptyView;
/** 网络了解错误 */
@property (strong,nonatomic) ECRRequestFailuredView *rfView;/// request failured

@end

@implementation ECRShoppingCarViewController

#pragma mark - ECRRequestFailuredViewDelegate
- (void)rfViewReloadData:(ECRRequestFailuredView *)view eType:(ECRRFViewEmptyType)etype{
    if ([view isEqual:self.cartEmptyView]) {/// 购物车为空,跳转至首页
        [self.navigationController popToRootViewControllerAnimated:YES];
    }
    if ([view isEqual:self.rfView]) {/// 网络连接错误,重新请求数据
        [self.rfView removeFromSuperview];
        self.rfView = nil;
        [self loadNewData];
    }
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setupUI];
    [self loadNewData];

}

- (void)loadNewData{
    [self.loadDataHUD showAnimated:YES];
    [[ECRShoppingCarManager sharedInstance] loadCartDataWith:nil success:^(NSMutableArray *totalArray, NSMutableArray *tickedArray, CGFloat priceT) {
//        totalArray = nil;
        [self.loadDataHUD hideAnimated:YES];
        if (totalArray.count == 0 || totalArray == nil) {
            /// 显示empty view
            [self lg_addCartEmptyView];
        }else{
            self.totalArray = totalArray;
            self.tickedArray = tickedArray;
            self.totalPrice = priceT;
            self.settleDoneView.price = self.totalPrice;
            [[NSOperationQueue mainQueue] addOperationWithBlock:^{
                [self.list reloadData];
                // MARK:设置 结算view
                self.settleDoneView.delegate = self;
            }];
        }
        
    } failure:^(NSString *msg) {
        [self.loadDataHUD hideAnimated:YES];
        [self presentFailureTips:msg];
    } commenFailure:^(NSError *error) {
        [self.loadDataHUD hideAnimated:YES];
        if (self.rfView == nil) {
            self.rfView = [[ECRRequestFailuredView alloc] initWithFrame:self.view.bounds];
            self.rfView.emptyType = ECRRFViewEmptyTypeDisconnect;
            self.rfView.delegate = self;
            [self.view addSubview:self.rfView];
        }
    }];
    
}
- (void)setupUI{
    [self.list registerNib:[UINib nibWithNibName:reuserID bundle:nil] forCellReuseIdentifier:reuserID];
//    [self textDependsLauguage];
    [self.view addSubview:self.loadDataHUD];
    [self.loadDataHUD hideAnimated:NO];
}
- (void)textDependsLauguage{
    self.title = [LGPChangeLanguage localizedStringForKey:@"购物车"];
}
#pragma mark - settleDoneView delegate
- (void)sdView:(ECRSettleDoneView *)sdView{
    // MARK: 跳转至结算页面
    [self showBecauseTickedArrayEmptyOtherwiseBlock:^{
        /// 跳转至订单明细页面,在其内部请求满减卷
        ECRBookFormViewController *dFormDetail = [[ECRBookFormViewController alloc] init];
        dFormDetail.viewControllerPushWay = ECRBaseControllerPushWayPush;
        dFormDetail.tickedArray = self.tickedArray;
        dFormDetail.tickedPrice = self.totalPrice;
        dFormDetail.delegate = self;
        [self.navigationController pushViewController:dFormDetail animated:YES];
    }];
}
// MARK: 点击 “全选” 按钮
- (void)sdViewAllSelected:(ECRSettleDoneView *)sdView{
    [[ECRShoppingCarManager sharedInstance] clickSelectAllSuccess:^(NSMutableArray *totalArray, NSMutableArray *tickedArray, CGFloat priceT) {
        self.totalArray = totalArray;
        self.tickedArray = tickedArray;
        self.totalPrice = priceT;
        self.settleDoneView.price = self.totalPrice;
        [self.list reloadData];
    } allsCancel:^{
        [self.settleDoneView allSelectedCanceled];
    }];
}
// MARK: 删除选中商品
- (void)sdViewAllRemoveFormCar:(ECRSettleDoneView *)sdView{
    [self showBecauseTickedArrayEmptyOtherwiseBlock:^{
        // 弹窗提示
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"" message:LOCALIZATION(@"确定删除选中商品") delegate:self cancelButtonTitle:LOCALIZATION(@"取消") otherButtonTitles:LOCALIZATION(@"确定"), nil];
        [alert show];
    }];
}

//确定删除
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    //    NSLog(@"buttonindex -- %ld",buttonIndex);
    if (buttonIndex) {
        // 1 确定
        NSMutableArray *wrIds= [NSMutableArray array];// will remove book id
        [self.tickedArray enumerateObjectsUsingBlock:^(ECRShoppingCarModel * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            [wrIds addObject:@(obj.id)];
        }];
        NSString *ids = [wrIds componentsJoinedByString:@","];
        NSDictionary *dict = [NSDictionary dictionaryWithObjectsAndKeys:ids,@"id",@"2",@"type", nil];
        [[ECRShoppingCarManager sharedInstance] manageShopCarWithDict:dict success:^(NSMutableArray *totalArray, NSMutableArray *tickedArray, CGFloat priceT) {
//            NSLog(@"totalArraycount -- %ld",totalArray.count);
            if (totalArray.count == 0 || totalArray == nil) {
                /// 购物车为空
                [self lg_addCartEmptyView];
            }else{
                self.totalArray = totalArray;
                self.tickedArray = tickedArray;
                self.totalPrice = priceT;
                self.settleDoneView.price = self.totalPrice;
                [[NSOperationQueue mainQueue] addOperationWithBlock:^{
                    if (self.totalArray.count == 0) {
                        [self.settleDoneView allSelectedCanceled];
                    }
                    [self.list reloadData];
                }];
            }
        } failure:^(NSString *msg) {
            
        } commenFailure:^(NSError *error) {
            
        }];
        
    }else{
        // 0 取消
        
    }
    
}

#pragma mark - cell delegate
// MARK: 选中 或者 取消选中 商品
- (void)scCell:(ECRShoppingCarCell *)cell selectProduct:(ECRShoppingCarModel *)model{
//    NSInteger modelIndex = [self.totalArray indexOfObject:model];
    NSLog(@"选中的模型 -- %@ -- %@",model,model.bookName);
    [[ECRShoppingCarManager sharedInstance] selectedOrUnselectedWithModel:model success:^(NSMutableArray *totalArray, NSMutableArray *tickedArray, CGFloat priceT) {
        self.totalArray = totalArray;
        self.tickedArray = tickedArray;
        self.totalPrice = priceT;
        self.settleDoneView.price = self.totalPrice;
        [[NSOperationQueue mainQueue] addOperationWithBlock:^{
            [self.list reloadData];
        }];
        if (totalArray.count == tickedArray.count) {
            [self.settleDoneView allSelected];
        }
//        NSLog(@"model.selected -- %d",model.isTick);
    } allsCancel:^{
        [self.settleDoneView allSelectedCanceled];
    }];

}
- (void)scCell:(ECRShoppingCarCell *)cell clickProduct:(ECRShoppingCarModel *)model{
    
}

#pragma mark - UITableViewDelegate
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.totalArray.count ? self.totalArray.count : 0;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    ECRShoppingCarCell *cell = [tableView dequeueReusableCellWithIdentifier:reuserID];
    cell.delegate = self;
    ECRShoppingCarModel *model;
    if (self.totalArray.count) {
        model = self.totalArray[indexPath.row];
    }
    cell.model = model;
    return cell;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return self.rowH;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    // 跳转至详情页面
    ECRShoppingCarModel *model;
    if (self.totalArray.count) {
        model = self.totalArray[indexPath.row];
    }
    UIStoryboard *board = [UIStoryboard storyboardWithName:@"BookInfo" bundle:nil];
    ECRBookInfoViewController *bivc = [board instantiateViewControllerWithIdentifier:@"ECRBookInfoViewController"];
    bivc.bookId = model.bookId;
    bivc.viewControllerPushWay = ECRBaseControllerPushWayPush;
    [self.navigationController pushViewController:bivc animated:YES];
}

- (void)setTotalPrice:(CGFloat)totalPrice{
    _totalPrice = totalPrice;
    self.settleDoneView.price = totalPrice;
}

- (void)showBecauseTickedArrayEmptyOtherwiseBlock:(void(^)())otherwise{
    if (self.tickedArray == nil || self.tickedArray.count == 0){
        [self presentFailureTips:LOCALIZATION(@"未勾选任何商品")];
    }else{
        if (otherwise){
            otherwise();
        }
    }
}

- (UITableView *)list{
    if (_list == nil) {
        CGRect rect = CGRectMake(0, 0, Screen_Width, Screen_Height - sdvHeight -64);
        _list = [[UITableView alloc] initWithFrame:rect style:UITableViewStylePlain];
        _list.delegate = self;
        _list.dataSource = self;
        _list.separatorStyle = UITableViewCellSeparatorStyleNone;
        [self.view addSubview:_list];
    }
    return _list;
}
- (ECRSettleDoneView *)settleDoneView{
    if (_settleDoneView == nil) {
        CGFloat sdY = self.view.height - sdvHeight;// - 64;
        CGRect sdRect = CGRectMake(0, sdY, Screen_Width, sdvHeight);
        _settleDoneView = [[ECRSettleDoneView alloc] initWithFrame:sdRect];
        [self.view addSubview:_settleDoneView];
    }
    return _settleDoneView;
}
- (CGFloat)rowH{
    if ([[ECRMultiObject sharedInstance] userInterfaceIdiom] == UIUserInterfaceIdiomPad) {
        return 180;
    }else{
        return 152;
    }
}
- (MBProgressHUD *)loadDataHUD{
    if (_loadDataHUD == nil) {
        _loadDataHUD = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
        _loadDataHUD.mode = MBProgressHUDModeIndeterminate;
    }
    return _loadDataHUD;
}

- (void)lg_addCartEmptyView{
    self.cartEmptyView = [[ECRRequestFailuredView alloc] initWithFrame:self.view.bounds];
    self.cartEmptyView.emptyType = ECRRFViewEmptyTypeCartEmpty;
    self.cartEmptyView.delegate = self;
    [self.view addSubview:self.cartEmptyView];
}

@end






