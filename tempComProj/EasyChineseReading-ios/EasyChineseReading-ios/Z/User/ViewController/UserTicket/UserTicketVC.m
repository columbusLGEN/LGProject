//
//  UserTicketVC.m
//  EasyChineseReading-ios
//
//  Created by 赵春阳 on 2017/9/14.
//  Copyright © 2017年 lee. All rights reserved.
//

#import "UserTicketVC.h"
#import "UserOrderVC.h"

static CGFloat const kBtnSpace = 86;
static CGFloat const kBtnWidth = 40;
static CGFloat const kSegmentHeight = 3;

@interface UserTicketVC () <UITextFieldDelegate>
// 顶部视图 --
@property (strong, nonatomic) UIView *customSegment; 

@property (strong, nonatomic) UIView *viewSlider;    // 底部滑块

@property (strong, nonatomic) UIView *botline;       // 底部横线
@property (strong, nonatomic) UIView *verLeftLine;
@property (strong, nonatomic) UIView *verRightLine;
@property (strong, nonatomic) UIView *viewLeft;
@property (strong, nonatomic) UIView *viewCenter;
@property (strong, nonatomic) UIView *viewRight;

@property (strong, nonatomic) UILabel *lblLeft;
@property (strong, nonatomic) UILabel *lblCenter;
@property (strong, nonatomic) UILabel *lblRight;

// 底部视图 --
@property (strong, nonatomic) UILabel     *lblDescTicketCode; // 卡券描述
@property (strong, nonatomic) UILabel     *lblDescHint;       // 提示描述

@property (strong, nonatomic) UITextField *txtfDescTicketCode;// 输入卡券

@property (strong, nonatomic) UITextView  *txtVHint;          // 提示

@property (strong, nonatomic) UIButton    *btnConvert;        // 兑换

@property (assign, nonatomic) ENUM_TicketType ticketType;

@end

@implementation UserTicketVC

- (void)viewDidLoad {
    [super viewDidLoad];
    [self configTicketView];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(textDidChange) name:UITextFieldTextDidChangeNotification object:nil];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:NO animated:YES];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - 配置界面

- (void)updateSystemLanguage
{
    self.title              = LOCALIZATION(@"兑换卡密");
    _lblDescTicketCode.text = LOCALIZATION(@"兑换卡卡密");
    _lblDescHint.text       = LOCALIZATION(@"温馨提示");
    _txtVHint.text          = LOCALIZATION(@"1）阅读卡绑定账户后，只能当前账户使用，不能跨账户使用；\n 2）阅读卡为非记名卡有效期一般为24个月；\n 3）使用阅读卡兑换或购买的电子书将不予以退换；\n 4）阅读卡不可兑换现金。");
    [_btnConvert setTitle:LOCALIZATION(@"立即兑换") forState:UIControlStateNormal];
}

- (void)configTicketView
{
    _ticketType = ENUM_TicketTypeDiscount;
    
    _customSegment = [[UIView alloc] initWithFrame:CGRectMake(0, 0, Screen_Width, cHeaderHeight_44)];
    _customSegment.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:_customSegment];
    
    _viewLeft = [[UIView alloc] initWithFrame:CGRectMake(0, 0, _customSegment.width/3 - 1, _customSegment.height - 1)];
    [_customSegment addSubview:_viewLeft];
    
    _viewCenter = [[UIView alloc] initWithFrame:CGRectMake(_customSegment.width/3, 0, _customSegment.width/3 - 1, _customSegment.height - 1)];
    [_customSegment addSubview:_viewCenter];
    
    _viewRight = [[UIView alloc] initWithFrame:CGRectMake(_customSegment.width*2/3, 0, _customSegment.width/3 - 1, _customSegment.height - 1)];
    [_customSegment addSubview:_viewRight];
    
    _lblLeft = [[UILabel alloc] init];
    _lblLeft.textAlignment = NSTextAlignmentCenter;
    _lblLeft.textColor = [UIColor cm_mainColor];
    _lblLeft.text = LOCALIZATION(@"满减券");
    _lblLeft.font = [UIFont systemFontOfSize:cFontSize_16];
    [_viewLeft addSubview:_lblLeft];

    _lblCenter = [[UILabel alloc] init];
    _lblCenter.textAlignment = NSTextAlignmentCenter;
    _lblCenter.textColor = [UIColor cm_blackColor_333333_1];
    _lblCenter.text = LOCALIZATION(@"充值卡");
    _lblCenter.font = [UIFont systemFontOfSize:cFontSize_16];
    [_viewCenter addSubview:_lblCenter];

    _lblRight = [[UILabel alloc] init];
    _lblRight.textAlignment = NSTextAlignmentCenter;
    _lblRight.textColor = [UIColor cm_blackColor_333333_1];
    _lblRight.text = LOCALIZATION(@"阅读卡");
    _lblRight.font = [UIFont systemFontOfSize:cFontSize_16];
    [_viewRight addSubview:_lblRight];
    
    _botline = [[UIView alloc] initWithFrame:CGRectMake(0, _customSegment.height - 1, _customSegment.width, 1)];
    _botline.backgroundColor = [UIColor cm_lineColor_D9D7D7_1];
    [_customSegment addSubview:_botline];
    
    _verLeftLine = [[UIView alloc] initWithFrame:CGRectMake(_customSegment.width/3 - 1, (_customSegment.height - cFontSize_16)/2, 1, cFontSize_16)];
    _verLeftLine.backgroundColor = [UIColor cm_lineColor_D9D7D7_1];
    [_customSegment addSubview:_verLeftLine];
    
    _verRightLine = [[UIView alloc] initWithFrame:CGRectMake(_customSegment.width*2/3 - 1, (_customSegment.height - cFontSize_16)/2, 1, cFontSize_16)];
    _verRightLine.backgroundColor = [UIColor cm_lineColor_D9D7D7_1];
    [_customSegment addSubview:_verRightLine];
    
    _viewSlider = [[UIView alloc] initWithFrame:CGRectMake((_viewLeft.width - [NSString stringWidthWithText:_lblLeft.text fontSize:cFontSize_16])/2, _viewLeft.height - kSegmentHeight
                                                           , [NSString stringWidthWithText:_lblLeft.text fontSize:cFontSize_16], kSegmentHeight)];
    _viewSlider.backgroundColor = [UIColor cm_mainColor];
    [_customSegment addSubview:_viewSlider];
    
    _viewLeft.userInteractionEnabled   = YES;
    _viewCenter.userInteractionEnabled = YES;
    _viewRight.userInteractionEnabled  = YES;
    
    UITapGestureRecognizer *tapL = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapLLabel)];
    UITapGestureRecognizer *tapC = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapCLabel)];
    UITapGestureRecognizer *tapR = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapRLabel)];
    
    [_viewLeft   addGestureRecognizer:tapL];
    [_viewCenter addGestureRecognizer:tapC];
    [_viewRight  addGestureRecognizer:tapR];
    
    _lblDescTicketCode = [UILabel new];
    _lblDescTicketCode.textColor = [UIColor cm_blackColor_333333_1];
    _lblDescTicketCode.font = [UIFont systemFontOfSize:16.f];
    _lblDescTicketCode.text = LOCALIZATION(@"兑换卡卡密");
    [self.view addSubview:_lblDescTicketCode];
    
    _lblDescHint = [UILabel new];
    _lblDescHint.textColor = [UIColor cm_blackColor_333333_1];
    _lblDescHint.font = [UIFont systemFontOfSize:14.f];
    _lblDescHint.text = LOCALIZATION(@"温馨提示");
    [self.view addSubview:_lblDescHint];
    
    _txtfDescTicketCode = [UITextField new];
    _txtfDescTicketCode.borderStyle = UITextBorderStyleRoundedRect;
    _txtfDescTicketCode.textColor = [UIColor cm_blackColor_333333_1];
    _txtfDescTicketCode.font = [UIFont systemFontOfSize:16.f];
    _txtfDescTicketCode.clearButtonMode = UITextFieldViewModeWhileEditing;
    _txtfDescTicketCode.delegate = self;
    [self.view addSubview:_txtfDescTicketCode];
    
    _txtVHint = [UITextView new];
    _txtVHint.textColor = [UIColor cm_blackColor_333333_1];
    _txtVHint.font = [UIFont systemFontOfSize:12.f];
    _txtVHint.text = LOCALIZATION(@"1）阅读卡绑定账户后，只能当前账户使用，不能跨账户使用；\n2）阅读卡为非记名卡有效期一般为24个月；\n3）使用阅读卡兑换或购买的电子书将不予以退换；\n4）阅读卡不可兑换现金。");
    _txtVHint.userInteractionEnabled = NO;
    _txtVHint.scrollEnabled = NO;
    [self.view addSubview:_txtVHint];
    
    _btnConvert = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, Screen_Width - 2*kBtnSpace, kBtnWidth)];
    _btnConvert.backgroundColor = [UIColor cm_grayColor__F1F1F1_1];
    [_btnConvert setTitle:LOCALIZATION(@"立即兑换") forState:UIControlStateNormal];
    [_btnConvert setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [_btnConvert addTarget:self action:@selector(convertNow) forControlEvents:UIControlEventTouchUpInside];
    _btnConvert.titleLabel.font = [UIFont systemFontOfSize:cFontSize_16];
    _btnConvert.layer.cornerRadius = _btnConvert.height/2;
    _btnConvert.layer.masksToBounds = YES;
    [self.view addSubview:_btnConvert];
    _btnConvert.enabled = NO;
    WeakSelf(self)
    [_lblLeft mas_makeConstraints:^(MASConstraintMaker *make) {
        make.center.equalTo(weakself.viewLeft);
    }];
    
    [_lblCenter mas_makeConstraints:^(MASConstraintMaker *make) {
        make.center.equalTo(weakself.viewCenter);
    }];
    
    [_lblRight mas_makeConstraints:^(MASConstraintMaker *make) {
        make.center.equalTo(weakself.viewRight);
    }];
    
    [_lblDescTicketCode mas_makeConstraints:^(MASConstraintMaker *make) {
        StrongSelf(self)
        make.left.equalTo(self.view.mas_left).offset(26);
        make.right.equalTo(self.txtfDescTicketCode.mas_left).offset(-10);
        make.width.equalTo(@(50)).priority(249);
        make.centerY.mas_equalTo(self.txtfDescTicketCode.mas_centerY);
    }];
    
    [_txtfDescTicketCode mas_makeConstraints:^(MASConstraintMaker *make) {
        StrongSelf(self)
        make.right.equalTo(self.view.mas_right).offset(-26);
        make.top.equalTo(self.view.mas_top).offset(20 + cHeaderHeight_44);
        make.height.equalTo(@30);
    }];
    
    [_txtVHint mas_makeConstraints:^(MASConstraintMaker *make) {
        StrongSelf(self)
        make.left.equalTo(self.view.mas_left).offset(28);
        make.right.equalTo(self.view.mas_right).offset(-28);
        make.bottom.equalTo(self.view.mas_bottom).offset(-28);
    }];
    
    [_lblDescHint mas_makeConstraints:^(MASConstraintMaker *make) {
        StrongSelf(self)
        make.leading.equalTo(self.txtVHint.mas_leading);
        make.bottom.equalTo(self.txtVHint.mas_top).offset(-5);
    }];
    
    [_btnConvert mas_makeConstraints:^(MASConstraintMaker *make) {
        StrongSelf(self)
        make.top.equalTo(self.txtfDescTicketCode.mas_top).offset(kBtnSpace);
        make.centerX.equalTo(self.view.mas_centerX);
        make.size.mas_equalTo(CGSizeMake(Screen_Width - 2*kBtnSpace, kBtnWidth));
        make.left.equalTo(self.view.mas_left).offset(kBtnSpace);
    }];
}

#pragma mark - 立即兑换
- (void)convertNow
{
    if ([_txtfDescTicketCode.text empty]) {
        [self presentFailureTips:LOCALIZATION(@"请输入兑换卡卡密")];
        return;
    }
    [self showWaitTips];
    WeakSelf(self)
    [[UserRequest sharedInstance] getTicketWithCode:_txtfDescTicketCode.text type:_ticketType completion:^(id object, ErrorModel *error) {
        StrongSelf(self)
        [self dismissTips];
        if (error) {
            [self presentFailureTips:error.message];
        }
        else {
            self.txtfDescTicketCode.text = @"";
            [self presentSuccessTips:LOCALIZATION(@"兑换成功")];
            if (self.ticketType == ENUM_TicketTypeReading) {
                dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.f * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                    UserOrderVC *order = [UserOrderVC new];
                    order.isLeaseOrder = YES;
                    [self.navigationController pushViewController:order animated:YES];
                });
            }
            else {
                dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.f * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                    [self.navigationController popViewControllerAnimated:YES];
                });
            }
        }
    }];
}

#pragma mark - textfield delegate

- (void)textDidChange
{
    _btnConvert.enabled = _txtfDescTicketCode.text.length > 0;
    _btnConvert.backgroundColor = _txtfDescTicketCode.text.length > 0 ? [UIColor cm_mainColor] : [UIColor cm_grayColor__F1F1F1_1];
}

#pragma mark -

/** 满减券 */
- (void)tapLLabel
{
    if (_ticketType != ENUM_TicketTypeDiscount) {
        _ticketType = ENUM_TicketTypeDiscount;
        _lblLeft.textColor   = [UIColor cm_mainColor];
        _lblCenter.textColor = [UIColor cm_blackColor_333333_1];
        _lblRight.textColor  = [UIColor cm_blackColor_333333_1];
        
        _viewSlider.frame = CGRectMake((_viewLeft.width - [NSString stringWidthWithText:_lblLeft.text fontSize:cFontSize_16])/2
                                       , _viewLeft.height - kSegmentHeight
                                       , [NSString stringWidthWithText:_lblLeft.text fontSize:cFontSize_16]
                                       , kSegmentHeight);
    }
}

/** 充值券 */
- (void)tapCLabel
{
    if (_ticketType != ENUM_TicketTypeRecharge) {
        _ticketType = ENUM_TicketTypeRecharge;
        _lblLeft.textColor   = [UIColor cm_blackColor_333333_1];
        _lblCenter.textColor = [UIColor cm_mainColor];
        _lblRight.textColor  = [UIColor cm_blackColor_333333_1];

        _viewSlider.frame = CGRectMake(_viewLeft.width + (_viewCenter.width - [NSString stringWidthWithText:_lblCenter.text fontSize:cFontSize_16])/2
                                       , _viewCenter.height - kSegmentHeight
                                       , [NSString stringWidthWithText:_lblCenter.text fontSize:cFontSize_16]
                                       , kSegmentHeight);
    }
}

/** 阅读券 */
- (void)tapRLabel
{
    if (_ticketType != ENUM_TicketTypeReading) {
        _ticketType = ENUM_TicketTypeReading;
        _lblLeft.textColor   = [UIColor cm_blackColor_333333_1];
        _lblCenter.textColor = [UIColor cm_blackColor_333333_1];
        _lblRight.textColor  = [UIColor cm_mainColor];
        
        _viewSlider.frame = CGRectMake(_viewLeft.width + _viewCenter.width + (_viewRight.width - [NSString stringWidthWithText:_lblRight.text fontSize:cFontSize_16])/2
                                       , _viewRight.height - kSegmentHeight
                                       , [NSString stringWidthWithText:_lblRight.text fontSize:cFontSize_16]
                                       , kSegmentHeight);
    }
}

@end
