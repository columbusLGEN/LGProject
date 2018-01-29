//
//  ECRBaseWkViewController.m
//  EasyChineseReading-ios
//
//  Created by Peanut Lee on 2017/11/8.
//  Copyright © 2017年 retech. All rights reserved.
//

#import "ECRBaseWkViewController.h"
#import <WebKit/WebKit.h>

@interface ECRBaseWkViewController ()<WKUIDelegate,WKNavigationDelegate>
@property (strong,nonatomic) WKWebView *wkView;//

@end

@implementation ECRBaseWkViewController

- (void)setWkTitle:(NSString *)wkTitle{
    _wkTitle = wkTitle;
    self.title = wkTitle;
}

- (void)setURLString:(NSString *)URLString{
    _URLString = URLString;
    
    if (URLString == nil || [URLString isEqualToString:@""]) {
        URLString = @"https://www.baidu.com";
    }
    NSURL *URL = [NSURL URLWithString:URLString];
    NSURLRequest *request = [NSURLRequest requestWithURL:URL];
    [self.wkView loadRequest:request];
}

#pragma mark - WKUIDelegate

#pragma mark - WKNavigationDelegate

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setupUI];
    
}

- (void)setupUI{
    
}

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
