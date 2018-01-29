//
//  RegisterAgreementVC.m
//  EasyChineseReading-ios
//
//  Created by 赵春阳 on 2018/1/9.
//  Copyright © 2018年 retech. All rights reserved.
//

#import "RegisterAgreementVC.h"
#import "RegisterVC.h"

@interface RegisterAgreementVC ()

@property (strong, nonatomic) UIWebView *webView; //

@end

@implementation RegisterAgreementVC

- (void)viewDidLoad {
    [super viewDidLoad];
    [self configRegisterAgreementView];
}

#pragma mark - 配置注册协议与隐私设置界面
- (void)configRegisterAgreementView
{
    self.title = LOCALIZATION(@"注册协议及隐私政策");
    
    _webView = [[UIWebView alloc] initWithFrame:CGRectMake(5, 0, Screen_Width - 10, self.view.height - 64 - 54)];
    _webView.backgroundColor = [UIColor whiteColor];
    NSError *error = nil;
    NSString *txtpath = [[NSBundle mainBundle] pathForResource:@"注册条款" ofType:@"html"];  //设置需要读取的文本名称路径
    NSString *txt = [NSString stringWithContentsOfFile:txtpath encoding:NSUTF8StringEncoding error:&error];
    
    [self.view addSubview:_webView];
    
    [_webView loadHTMLString:txt baseURL:[NSURL URLWithString:txtpath]];
    
    UILabel *lblCancel = [[UILabel alloc] init];
    lblCancel.textColor = [UIColor cm_blackColor_333333_1];
    lblCancel.backgroundColor = [UIColor whiteColor];
    lblCancel.textAlignment = NSTextAlignmentCenter;
    lblCancel.text = LOCALIZATION(@"不同意");
    lblCancel.userInteractionEnabled = YES;
    [self.view addSubview:lblCancel];
    
    UITapGestureRecognizer *tapCancel = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(cancel)];
    [lblCancel addGestureRecognizer:tapCancel];

    UILabel *lblAgree  = [[UILabel alloc] init];
    lblAgree.textColor = [UIColor whiteColor];
    lblAgree.backgroundColor = [UIColor cm_mainColor];
    lblAgree.textAlignment = NSTextAlignmentCenter;
    lblAgree.text = LOCALIZATION(@"同意");
    lblAgree.userInteractionEnabled = YES;
    [self.view addSubview:lblAgree];
    UITapGestureRecognizer *tapAgree = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(agree)];
    [lblAgree addGestureRecognizer:tapAgree];
    
    [lblCancel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.view.mas_left);
        make.bottom.mas_equalTo(self.view.mas_bottom);
        make.height.mas_equalTo(44);
        make.right.mas_equalTo(lblAgree.mas_left);
    }];
    [lblAgree mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo(self.view.mas_right);
        make.bottom.mas_equalTo(self.view.mas_bottom);
        make.height.mas_equalTo(44);
        make.width.mas_equalTo(lblCancel.mas_width);
    }];
}

#pragma mark - 同意/取消

/** 取消 */
- (void)cancel
{
    [self.navigationController popViewControllerAnimated:YES];
}

/** 同意协议 */
- (void)agree
{
    RegisterVC *registerVC = [RegisterVC new];
    registerVC.hidesBottomBarWhenPushed = NO;
    [self.navigationController pushViewController:registerVC animated:YES];
}

@end
