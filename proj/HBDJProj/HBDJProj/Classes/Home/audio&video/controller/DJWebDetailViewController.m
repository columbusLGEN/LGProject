//
//  DJWebDetailViewController.m
//  HBDJProj
//
//  Created by Peanut Lee on 2018/12/12.
//  Copyright © 2018 Lee. All rights reserved.
//

#import "DJWebDetailViewController.h"

#import <WebKit/WebKit.h>

@interface DJWebDetailViewController ()<WKUIDelegate, WKNavigationDelegate>

@property (strong, nonatomic) WKWebView *webView;

@end

@implementation DJWebDetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self configViewUI];
}

- (void)configViewUI
{
    [self.view addSubview:self.webView];
    [self.webView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges  .mas_equalTo(self.view).insets(UIEdgeInsetsMake(0, 0, 0, 0));
    }];

    [_webView loadRequest:[NSURLRequest requestWithURL:self.url]];
}

#pragma mark - setter

- (WKWebView *)webView
{
    if (_webView == nil) {
        _webView = [[WKWebView alloc] initWithFrame:self.view.frame];
        _webView.navigationDelegate = self;
        _webView.UIDelegate = self;
    }
    return _webView;
}

@end
