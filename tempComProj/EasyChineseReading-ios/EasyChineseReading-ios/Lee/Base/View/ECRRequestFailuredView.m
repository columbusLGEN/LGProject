//
//  ECRRequestFailuredView.m
//  EasyChineseReading-ios
//
//  Created by Peanut Lee on 2017/10/18.
//  Copyright © 2017年 retech. All rights reserved.
//

static CGFloat font = 18;
static NSString *img_empty_view = @"img_empty_view";
static NSString *img_empty_network = @"img_empty_network";
static NSString *img_empty_shop_car = @"img_empty_shop_car";

#define clickReload LOCALIZATION(@"点击刷新")
#define cartEmotyStr LOCALIZATION(@"购物车空")
#define bookrackEmotyStr LOCALIZATION(@"书架空")
#define notLogIn LOCALIZATION(@"您未登录")
#define noTalk LOCALIZATION(@"暂无评论")
#define noJuan LOCALIZATION(@"暂无满减卷")
#define classifyNoData LOCALIZATION(@"没有找到你想要的")
#define noAccess LOCALIZATION(@"没有可授权的书籍")

#import "ECRRequestFailuredView.h"

@interface ECRRequestFailuredView ()
@property (strong,nonatomic) UIImageView *bgImg;//
@property (strong,nonatomic) UIButton *reRequest;//
@property (strong,nonatomic) UIButton *fullScreen;//
@property (copy,nonatomic) void(^reRequestBlock)();//

/** 显示图片名 */
@property (copy,nonatomic) NSString *imgName;
/** 按钮显示文字内容 */
@property (copy,nonatomic) NSString *btnTitle;

@end

@implementation ECRRequestFailuredView

- (void)setEmptyType:(ECRRFViewEmptyType)emptyType{
    _emptyType = emptyType;
    switch (emptyType) {
        case ECRRFViewEmptyTypeDisconnect:{
            self.imgName = img_empty_network;
            self.btnTitle = clickReload;
        }
            break;
        case ECRRFViewEmptyTypeCartEmpty:{
            self.imgName = img_empty_shop_car;
            self.btnTitle = cartEmotyStr;
        }
            break;
        case ECRRFViewEmptyTypeBookrackEmpty:{
            self.imgName = img_empty_view;
            self.btnTitle = bookrackEmotyStr;
        }
            break;
        case ECRRFViewEmptyTypeNotLogIn:{
            self.imgName = img_empty_view;
            self.btnTitle = notLogIn;
        }
            break;
        case ECRRFViewEmptyTypeNoComments:{
            self.imgName = img_empty_view;
            self.btnTitle = noTalk;
        }
            break;
        case ECRRFViewEmptyTypeNoJuan:{
            self.imgName = img_empty_view;
            self.btnTitle = noJuan;
        }
            break;
        case ECRRFViewEmptyTypeClassifyNoData:{
            self.imgName = img_empty_view;
            self.btnTitle = classifyNoData;
        }
            break;
        case ECRRFViewEmptyTypeNoAccess:{
            self.imgName = img_empty_view;
            self.btnTitle = noAccess;
        }
            break;
        default:{
            self.imgName = img_empty_view;
            self.btnTitle = clickReload;
        }
            break;
    }
}

- (void)setImgName:(NSString *)imgName{
    _imgName = imgName;
    [self.bgImg setImage:[UIImage imageNamed:imgName]];
}
- (void)setBtnTitle:(NSString *)btnTitle{
    _btnTitle = btnTitle;
    [self.reRequest setTitle:btnTitle forState:UIControlStateNormal];
}

- (instancetype)requestFailuredViewWithFrame:(CGRect)frame clickBlock:(void(^)())block{
    self.reRequestBlock = block;
    return [self initWithFrame:frame];
}

- (void)reRequestClick:(UIButton *)sender{
    if ([self.delegate respondsToSelector:@selector(rfViewReloadData:eType:)]) {
        [self.delegate rfViewReloadData:self eType:self.emptyType];
    }
}

- (void)setupUI{
    self.backgroundColor = [UIColor whiteColor];
    [self addSubview:self.bgImg];
    [self addSubview:self.reRequest];
    [self addSubview:self.fullScreen];
    
    [self.bgImg mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.mas_centerX);
        make.centerY.equalTo(self.mas_centerY).offset(-30);
    }];
    [self.reRequest mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.mas_centerX);
        make.top.equalTo(self.bgImg.mas_bottom).offset(10);
    }];
    [self.fullScreen mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.mas_top);
        make.left.equalTo(self.mas_left);
        make.bottom.equalTo(self.mas_bottom);
        make.right.equalTo(self.mas_right);
    }];
    
}

- (instancetype)initWithFrame:(CGRect)frame{
    if (self = [super initWithFrame:frame]) {
        [self setupUI];
    }
    return self;
}

- (instancetype)initWithCoder:(NSCoder *)aDecoder{
    if (self = [super initWithCoder:aDecoder]) {
        [self setupUI];
    }
    return self;
}
- (UIImageView *)bgImg{
    if (_bgImg == nil) {
        _bgImg = [[UIImageView alloc] init];
        [_bgImg setImage:[UIImage imageNamed:@"img_empty_network"]];
    }
    return _bgImg;
}
- (UIButton *)reRequest{
    if (_reRequest == nil) {
        _reRequest = [[UIButton alloc] init];
        [_reRequest.titleLabel setFont:[UIFont systemFontOfSize:font]];
        [_reRequest setTitleColor:[UIColor cm_blackColor_666666_1] forState:UIControlStateNormal];
        [_reRequest setTitle:clickReload forState:UIControlStateNormal];
        [_reRequest setTintColor:[UIColor clearColor]];
        [_reRequest addTarget:self action:@selector(reRequestClick:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _reRequest;
}
- (UIButton *)fullScreen{
    if (_fullScreen == nil) {
        _fullScreen = [[UIButton alloc] init];
        [_fullScreen addTarget:self action:@selector(reRequestClick:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _fullScreen;
}
@end
