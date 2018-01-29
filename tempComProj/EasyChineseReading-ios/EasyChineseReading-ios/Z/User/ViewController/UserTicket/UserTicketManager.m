
//
//  UserTicketManager.m
//  EasyChineseReading-ios
//
//  Created by 赵春阳 on 2017/9/28.
//  Copyright © 2017年 retech. All rights reserved.
//

#import "UserTicketManager.h"

#import "UTicketCollectionViewCell.h"

#import "UserTicketVC.h"
#import "UserTicketListVC.h"
#import "UserTicketCorrespondBooksVC.h"
#import "UVirtualCurrencyRechargeVC.h"

static CGFloat const kCellHeight   = 108.f; // cell 高度
static CGFloat const kCellSpace    = 36.f;  // cell 边距

@interface UserTicketManager () <UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout>

@property (weak, nonatomic) IBOutlet UIView *viewHeader;

@property (weak, nonatomic) IBOutlet UIImageView *imgBack;
@property (weak, nonatomic) IBOutlet UIImageView *imgBackground;
@property (weak, nonatomic) IBOutlet UIImageView *imgNavBack;
@property (weak, nonatomic) IBOutlet UIImageView *imgHeader;
@property (weak, nonatomic) IBOutlet UIImageView *imgTop;
@property (weak, nonatomic) IBOutlet UIImageView *imgBot;
// 右箭头
@property (weak, nonatomic) IBOutlet UIImageView *imgRA0;
@property (weak, nonatomic) IBOutlet UIImageView *imgRA1;
@property (weak, nonatomic) IBOutlet UIImageView *imgRA2;

@property (weak, nonatomic) IBOutlet UILabel *lblDescLeft;
@property (weak, nonatomic) IBOutlet UILabel *lblRange;
@property (weak, nonatomic) IBOutlet UILabel *lblTitle;

@property (weak, nonatomic) IBOutlet UIButton *btnPay;

@property (weak, nonatomic) IBOutlet UIView *viewExchange;  // 兑换
@property (weak, nonatomic) IBOutlet UIView *viewTickets;   // 我的
@property (weak, nonatomic) IBOutlet UIView *viewShowTicket;// 卡券中心

@property (weak, nonatomic) IBOutlet UILabel *lblExchange;  // 兑换
@property (weak, nonatomic) IBOutlet UILabel *lblTickets;   // 我的
@property (weak, nonatomic) IBOutlet UILabel *lblShowTicket;// 卡券中心

@property (weak, nonatomic) IBOutlet UIView *viewExchangeLine;
@property (weak, nonatomic) IBOutlet UIView *viewTicketsLine;

@property (weak, nonatomic) IBOutlet UICollectionView *collectionView; // 列表
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *headerHeightConstraint;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *avatarTopConstraint;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *avatarBotConstraint;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *btnTopConstraint;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *btnBotConstraint;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *cellHeightConstraint;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *sectionHeightConstraint;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *navHeightConstraint;

@property (strong, nonatomic) UICollectionViewFlowLayout *layout; // collecition 布局

@property (strong, nonatomic) UVirtualCurrencyRechargeVC *rechargeVC; // 全平台包月
@property (strong, nonatomic) EmptyView *emptyView;

@property (strong, nonatomic) NSMutableArray *arrTickets;            // 卡券数组

@end

@implementation UserTicketManager

- (void)viewDidLoad {
    [super viewDidLoad];
    [self configTickManagerView];
    [self showWaitTips];
    [self getTickets];
    [self configEmptyView];
    [self configHeaderViewHeight];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:YES animated:YES];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - 配置界面

- (void)updateSystemLanguage
{
    [_btnPay setTitle:[UserRequest sharedInstance].user.allbooks ? LOCALIZATION(@"续期") : LOCALIZATION(@"购买") forState:UIControlStateNormal];

    _lblRange.text      = [UserRequest sharedInstance].user.endtime.length > 0 ? [NSString stringWithFormat:@"-%@  %@ %@", LOCALIZATION(@"全平台资源"), LOCALIZATION(@"到期"), [UserRequest sharedInstance].user.endtime] : [NSString stringWithFormat:@"-%@", LOCALIZATION(@"全平台资源")];
    _lblDescLeft.text   = LOCALIZATION(@"VIP租阅");
    _lblTitle.text      = LOCALIZATION(@"会员中心");
    _lblExchange.text   = LOCALIZATION(@"卡券兑换");
    _lblTickets.text    = LOCALIZATION(@"我的卡券");
    _lblShowTicket.text = LOCALIZATION(@"领券中心");
}

- (void)configEmptyView
{
    _emptyView = [EmptyView loadFromNibWithFrame:CGRectMake(0, _collectionView.y, Screen_Width, self.view.height - _collectionView.y)];
    [_emptyView updateEmptyViewWithType:ENUM_EmptyResultTypeData Image:nil desc:LOCALIZATION(@"没有可领取的卡券") subDesc:nil];
    [self.view addSubview:_emptyView];
}

- (void)configTickManagerView
{
    _lblRange.textColor    = [UIColor whiteColor];
    _lblDescLeft.textColor = [UIColor whiteColor];
    _lblTitle.textColor    = [UIColor whiteColor];
    
    _lblExchange.textColor   = [UIColor cm_blackColor_333333_1];
    _lblTickets.textColor    = [UIColor cm_blackColor_333333_1];
    _lblShowTicket.textColor = [UIColor cm_blackColor_333333_1];
    
    _viewExchangeLine.backgroundColor = [UIColor cm_lineColor_D9D7D7_1];
    _viewTicketsLine.backgroundColor  = [UIColor cm_lineColor_D9D7D7_1];
    
    _lblDescLeft.font = [UIFont systemFontOfSize:cFontSize_16];
    _lblRange.font    = [UIFont systemFontOfSize:cFontSize_14];
    _lblTitle.font    = [UIFont systemFontOfSize:cFontSize_16];
    
    _btnPay.layer.masksToBounds = YES;
    _btnPay.layer.cornerRadius = _btnPay.height/2;
    // TODO: 判断是否有全平台租赁
    [_btnPay setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [_btnPay addTarget:self action:@selector(buyAllRead) forControlEvents:UIControlEventTouchUpInside];

    UITapGestureRecognizer *tapExchange = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(toExchangeTicket)];
    [_viewExchange addGestureRecognizer:tapExchange];
    
    UITapGestureRecognizer *tapTickets = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(toTickets)];
    [_viewTickets addGestureRecognizer:tapTickets];
    
    UITapGestureRecognizer *tapImgBack = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(popToViewController)];
    [_imgBack addGestureRecognizer:tapImgBack];
    
    [_collectionView registerNib:[UINib nibWithNibName:NSStringFromClass([UTicketCollectionViewCell class]) bundle:nil] forCellWithReuseIdentifier:NSStringFromClass([UTicketCollectionViewCell class])];
    _collectionView.collectionViewLayout = self.layout;
    
    _imgBack.image       = [UIImage imageNamed:@"icon_arrow_left_white"];
    _imgBackground.image = [UIImage imageNamed:@"img_background_member"];
    _imgNavBack.image    = [UIImage imageNamed:@"icon_home_nav_bg"];
    _imgHeader.image     = [UIImage imageNamed:@"img_lease_header"];
    _imgTop.image        = [UIImage imageNamed:@"icon_ticket_card_voucher"];
    _imgBot.image        = [UIImage imageNamed:@"icon_ticket_my_ticket"];
    _imgRA0.image        = _imgRA1.image = _imgRA2.image = [UIImage imageNamed:@"icon_arrow_right"];
    
    switch ([LGSkinSwitchManager getCurrentUserSkin]) {
        case ECRHomeUITypeDefault:
            _lblRange.textColor = _lblDescLeft.textColor = [UIColor whiteColor];
            _btnPay.backgroundColor = [UIColor cm_orangeColor_FF7200_1];
            break;
        case ECRHomeUITypeAdultTwo:
            _lblRange.textColor = _lblDescLeft.textColor = [UIColor cm_blackColor_666666_1];
            _btnPay.backgroundColor = [UIColor cm_mainColor];
            break;
        case ECRHomeUITypeKidOne:
            _lblRange.textColor = _lblDescLeft.textColor = [UIColor cm_blackColor_666666_1];
            _btnPay.backgroundColor = [UIColor cm_orangeColor_FF7200_1];
            break;
        case ECRHomeUITypeKidtwo:
            
            break;
        default:
            break;
    }
}

- (void)configHeaderViewHeight
{
    _headerHeightConstraint.constant = isPad ? 300.f : ([IPhoneVersion deviceVersion] == iphoneX ? 250.f + 24.f : 250.f);
    _avatarTopConstraint.constant    = isPad ? 20.f  : 10.f;
    _avatarBotConstraint.constant    = isPad ? 30.f  : 20.f;
    _btnTopConstraint.constant       = isPad ? 30.f  : 20.f;
    _btnBotConstraint.constant       = isPad ? 40.f  : 20.f;
    _cellHeightConstraint.constant   = isPad ? 64.f  : 54.f;
    _sectionHeightConstraint.constant= isPad ? 44.f  : 44.f;
    _navHeightConstraint.constant    = [IPhoneVersion deviceVersion] == iphoneX ? cHeaderHeight_88 : cHeaderHeight_64;
}

#pragma mark - handle

/** 兑换卡券 */
- (void)toExchangeTicket
{
    UserTicketVC *tickVC = [UserTicketVC new];
    [self.navigationController pushViewController:tickVC animated:YES];
}

/** 我的卡券 */
- (void)toTickets
{
    UserTicketListVC *tickListVC = [UserTicketListVC new];
    [self.navigationController pushViewController:tickListVC animated:YES];
}

- (void)popToViewController
{
    [self.navigationController popViewControllerAnimated:YES];
}

/** 全平台租阅 */
- (void)buyAllRead
{
    _rechargeVC = [UVirtualCurrencyRechargeVC loadFromStoryBoard:@"User"];
    _rechargeVC.payPurpose = ENUM_PayPurposeAllLease;
    [self.navigationController pushViewController:_rechargeVC animated:YES];
}

#pragma mark - 获取数据

- (void)getTickets
{
    WeakSelf(self)
    [[UserRequest sharedInstance] getAllTicketesWithCompletion:^(id object, ErrorModel *error) {
        StrongSelf(self)
        [self dismissTips];
        if (error) {
            [self presentFailureTips:error.message];
        }
        else {
            self.arrTickets = [TicketModel mj_objectArrayWithKeyValuesArray:object];
            self.emptyView.hidden = self.arrTickets.count > 0;
            [self.collectionView reloadData];
        }
    }];
}

#pragma mark - UICollectionViewDataSource

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return _arrTickets.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    UTicketCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:NSStringFromClass([UTicketCollectionViewCell class]) forIndexPath:indexPath];
    cell.data = _arrTickets[indexPath.row];
    return cell;
}

#pragma mark - UICollectionViewDelegate

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    TicketModel *ticket = _arrTickets[indexPath.row];
    if (ticket.status == ENUM_TicketStatusHaveNot && ticket.receiveNum < ticket.totalNum)
        [self getTicketWithTicket:ticket indexPath:indexPath];
    else
        [self userTicketWithType:ticket.fullminusType];
}

#pragma mark - action

- (void)userTicketWithType:(NSString *)ticketType
{
    UserTicketCorrespondBooksVC *booksVC = [UserTicketCorrespondBooksVC new];
    booksVC.ticketType = ticketType;
    [self.navigationController pushViewController:booksVC animated:YES];
}

- (void)getTicketWithTicket:(TicketModel *)ticket indexPath:(NSIndexPath *)indexPath
{
    [self showWaitTips];
    WeakSelf(self)
    [[UserRequest sharedInstance] getTicketWithTicketId:ticket.seqid completion:^(id object, ErrorModel *error) {
        StrongSelf(self)
        [self dismissTips];
        if (error) {
            [self presentFailureTips:error.message];
        }
        else {
            ticket.status = ENUM_TicketStatusHave;
            ticket.receiveNum += 1;
            UTicketCollectionViewCell *cell = (UTicketCollectionViewCell *)[self.collectionView cellForItemAtIndexPath:indexPath];
            cell.data = ticket;
            [self.collectionView reloadItemsAtIndexPaths:@[indexPath]];
            [self presentSuccessTips:LOCALIZATION(@"领取成功")];
        }
    }];
}

#pragma mark -

- (UICollectionViewFlowLayout *)layout
{
    if (_layout == nil) {
        _layout = [[UICollectionViewFlowLayout alloc] init];
        _layout.minimumLineSpacing      = kCellSpace;
        _layout.minimumInteritemSpacing = kCellSpace;
        _layout.sectionInset            = UIEdgeInsetsMake(isPad ? kCellSpace : 0, kCellSpace, kCellSpace, kCellSpace);
        _layout.itemSize                = isPad ? CGSizeMake((Screen_Width - kCellSpace * 3)/2, kCellHeight) : CGSizeMake(Screen_Width - kCellSpace * 2, kCellHeight);
    }
    return _layout;
}

- (NSMutableArray *)arrTickets
{
    if (_arrTickets == nil) {
        _arrTickets = [NSMutableArray array];
    }
    return _arrTickets;
}

@end
