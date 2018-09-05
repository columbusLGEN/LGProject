//
//  ECRBaseWkViewController.m
//  EasyChineseReading-ios
//
//  Created by Peanut Lee on 2017/11/8.
//  Copyright © 2017年 retech. All rights reserved.
//

#import "LGWKWebViewController.h"
#import <WebKit/WebKit.h>

/// TODO: 添加进度条

@interface LGWKWebViewController ()<WKUIDelegate,WKNavigationDelegate>
@property (strong,nonatomic) NSURL *URL;
@property (strong,nonatomic) WKWebView *wkView;

@end

@implementation LGWKWebViewController

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:NO animated:YES];
}

- (instancetype)initWithUrl:(NSURL *)URL{
    self.URL = URL;
    return [self init];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self configUI];
    
}
- (void)configUI{
    self.title = @"党员统计报表";
    NSURLRequest *request = [NSURLRequest requestWithURL:self.URL];
    [self.wkView loadRequest:request];
}

- (void)setWkTitle:(NSString *)wkTitle{
    _wkTitle = wkTitle;
    self.title = wkTitle;
}


#pragma mark - WKUIDelegate

#pragma mark - WKNavigationDelegate

- (WKWebView *)wkView{
    if (_wkView == nil) {
//        _wkView = [[WKWebView alloc] initWithFrame:self.view.bounds configuration:nil];
        _wkView = [[WKWebView alloc] initWithFrame:self.view.bounds];
        _wkView.UIDelegate = self;
        _wkView.navigationDelegate = self;
        [self.view addSubview:_wkView];
    }
    return _wkView;
}


@end
