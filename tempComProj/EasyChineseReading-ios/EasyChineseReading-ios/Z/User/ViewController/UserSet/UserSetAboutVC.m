//
//  USetAboutVC.m
//  EasyChineseReading-ios
//
//  Created by 赵春阳 on 17/9/1.
//  Copyright © 2017年 lee. All rights reserved.
//

#import "UserSetAboutVC.h"

@interface UserSetAboutVC ()

@property (weak, nonatomic) IBOutlet UIImageView *imgLogo;
@property (weak, nonatomic) IBOutlet UIImageView *imgHeader;
@property (weak, nonatomic) IBOutlet UIImageView *imgBack;
@property (weak, nonatomic) IBOutlet UIImageView *imgBackground;

@property (weak, nonatomic) IBOutlet UILabel *lblAbout;

@property (weak, nonatomic) IBOutlet UILabel *lblBeiyushe; // 出版社名
@property (weak, nonatomic) IBOutlet UILabel *lblPostcode; // 邮编
@property (weak, nonatomic) IBOutlet UILabel *lblPhone;    // 客服电话
@property (weak, nonatomic) IBOutlet UILabel *lblEmail;    // 客服邮箱
@property (weak, nonatomic) IBOutlet UILabel *lblAddress;  // 通信地址
@property (weak, nonatomic) IBOutlet UILabel *lblLicense;  // 许可证
@property (weak, nonatomic) IBOutlet UILabel *lblICP;

@property (weak, nonatomic) IBOutlet UILabel *lblBottom;    // 版权所有
@property (weak, nonatomic) IBOutlet UIView *viewBackground;
@property (weak, nonatomic) IBOutlet UILabel *lblTitle;
@property (weak, nonatomic) IBOutlet UIView *viewVerLine;

@end

@implementation UserSetAboutVC

- (void)viewDidLoad {
    [super viewDidLoad];
    [self configView];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:YES animated:YES];
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    [self.navigationController setNavigationBarHidden:NO animated:YES];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - 翻译

- (void)updateSystemLanguage
{
    _lblTitle.text = LOCALIZATION(@"关于");

    _lblAbout.text  = LOCALIZATION(@"是一个致力于打造全球汉语阅读社区的汉语互动阅读平台，是“十三五”期间\n北京语言大学出版社（以下简称北语社）推广汉语和中国文化“走出去”的代表性产品。\n产品集合了北语社精品读物与国内适合于外国人阅读的汉语书籍、报刊、文章等，以个性化的\n阅读功能为核心。用户可根据不同年龄、级别和兴趣定制一个\n寓教于乐的个人化汉语阅读中心。");
    
    _lblBeiyushe.text = LOCALIZATION(@"北京语言大学出版社有限公司");
    _lblPostcode.text = LOCALIZATION(@"邮编：100083");
    _lblPhone.text    = LOCALIZATION(@"客服电话：+86-10-82303908");
    _lblEmail.text    = LOCALIZATION(@"客服邮箱：service@blcup.com");
    _lblAddress.text  = LOCALIZATION(@"通信地址：北京市海淀区学院路15号");
    _lblLicense.text  = LOCALIZATION(@"互联网出版许可证：新出网证（京）字163号");
    _lblICP.text      = LOCALIZATION(@"京ICP证05080378");
    _lblBottom.text   = LOCALIZATION(@"版权所有：北京语言大学出版社有限公司，All Right Reserved Copyright 2017");
}

#pragma mark - 配置界面

- (void)configView
{
    _imgBack.image = [UIImage imageNamed:@"icon_arrow_left_white"];
    _imgHeader.image = [UIImage imageNamed:@"icon_home_nav_bg"];
    _imgBackground.image = [UIImage imageNamed:@"img_background_about"];
    _imgLogo.image = [UIImage imageNamed:@"img_logo_about"];
    
    _imgLogo.layer.masksToBounds = YES;
    _imgLogo.layer.cornerRadius = 15.f;
    
    _viewBackground.layer.masksToBounds = YES;
    _viewBackground.layer.cornerRadius = 15.f;
    
    _lblAbout.font    = [UIFont systemFontOfSize:cFontSize_16];
    _lblBeiyushe.font = [UIFont systemFontOfSize:cFontSize_16];
    _lblPostcode.font = [UIFont systemFontOfSize:cFontSize_14];
    _lblPhone.font    = [UIFont systemFontOfSize:cFontSize_14];
    _lblEmail.font    = [UIFont systemFontOfSize:cFontSize_14];
    _lblAddress.font  = [UIFont systemFontOfSize:cFontSize_14];
    _lblLicense.font  = [UIFont systemFontOfSize:cFontSize_14];
    _lblICP.font      = [UIFont systemFontOfSize:cFontSize_14];
    _lblBottom.font   = [UIFont systemFontOfSize:cFontSize_12];
    
    UITapGestureRecognizer *tapImgBack = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(popToViewController)];
    [_imgBack addGestureRecognizer:tapImgBack];
    
    UIColor *titleColor = [UIColor whiteColor];
    UIColor *backColor  = [UIColor cm_blackColor_000000_5F];
    switch ([LGSkinSwitchManager getCurrentUserSkin]) {
        case ECRHomeUITypeDefault:
            titleColor = [UIColor whiteColor];
            backColor  = [UIColor cm_blackColor_000000_5F];
            break;
        case ECRHomeUITypeAdultTwo:
        case ECRHomeUITypeKidOne:
            titleColor = [UIColor cm_blackColor_333333_1];
            backColor  = [UIColor cm_whiteColor_FFFFFF_7F];
            break;
        case ECRHomeUITypeKidtwo:
            
            break;
        default:
            break;
    }
    
    _lblAbout.textColor = _lblBeiyushe.textColor = _lblPostcode.textColor = _lblPhone.textColor = _lblEmail.textColor = _lblAddress.textColor = _lblLicense.textColor = _lblICP.textColor = _lblBottom.textColor = _viewVerLine.backgroundColor = titleColor;
    _viewBackground.backgroundColor = backColor;
}

#pragma mark - 返回
- (void)popToViewController
{
    [self.navigationController popViewControllerAnimated:YES];
}

@end
