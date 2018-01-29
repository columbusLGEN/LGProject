//
//  ECRBookInfoController.m
//  EasyChineseReading-ios
//
//  Created by lee on 2017/8/30.
//  Copyright © 2017年 lee. All rights reserved.
//

#import "ECRBookInfoController.h"
#import <WebKit/WebKit.h>
#import "UIColor+TOPColorSet.h"

@interface ECRBookInfoController ()<
WKNavigationDelegate,
WKUIDelegate
>
@property (strong,nonatomic) WKWebView *wkwView;
@property (nonatomic,strong) UIProgressView *progressView;

@end

@implementation ECRBookInfoController

// MARK: 父类方法
- (void)createNavLeftBackItem{
    
    UIBarButtonItem *bkBatButtonItem = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"icon_arrow_left_white"] style:UIBarButtonItemStyleDone target:self action:@selector(popSelf)];
    UIBarButtonItem *spaceBarButtonItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFixedSpace target:nil action:nil];
    spaceBarButtonItem.width = -4;
    self.navigationItem.leftBarButtonItems = @[spaceBarButtonItem,bkBatButtonItem];
    
    UIBarButtonItem *cusRight = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"icon_webview_close"] style:UIBarButtonItemStylePlain target:self action:@selector(allClose)];
    self.navigationItem.rightBarButtonItem = cusRight;
    
}

#pragma mark - WKUIDelegate
//- (void)webView:(WKWebView *)webView runJavaScriptAlertPanelWithMessage:(NSString *)message initiatedByFrame:(WKFrameInfo *)frame completionHandler:(void (^)(void))completionHandler {
//    // 点击到 JS弹窗时执行该方法
//    //    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"提示" message:message?:@"" preferredStyle:UIAlertControllerStyleAlert];
//    //    [alertController addAction:([UIAlertAction actionWithTitle:@"确认" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
//    //        completionHandler();
//    //    }])];
//    //    [self presentViewController:alertController animated:YES completion:nil];
//}
//
//- (WKWebView *)webView:(WKWebView *)webView createWebViewWithConfiguration:(WKWebViewConfiguration *)configuration forNavigationAction:(WKNavigationAction *)navigationAction windowFeatures:(WKWindowFeatures *)windowFeatures {
//    
//    return webView;
//}

#pragma mark - WKNavigationDelegate
//- (void)webView:(WKWebView *)webView didFailProvisionalNavigation:(WKNavigation *)navigation withError:(NSError *)error {
//    
//    // 跳转失败？
//}
//
//- (void)webView:(WKWebView *)webView didReceiveServerRedirectForProvisionalNavigation:(WKNavigation *)navigation{
//    
//    // 决定跳转？
//}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setupUI];
}

- (void)setupUI{
    self.view.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:self.wkwView];
    [self createProgressView];
    [_wkwView loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:_requestURL]]];
    //    NSLog(@"webview: %@",self.wkwView);
    _wkwView.UIDelegate = self;
    _wkwView.navigationDelegate = self;
    
}

- (void)createProgressView {
    
    CGRect navBounds = self.navigationController.navigationBar.bounds;
    CGRect barFrame = CGRectMake(0,
                                 navBounds.size.height - 2,
                                 navBounds.size.width,
                                 2);
    self.progressView = [[UIProgressView alloc] initWithFrame:barFrame];
    [self.navigationController.navigationBar addSubview:self.progressView];
    [self.wkwView addObserver:self forKeyPath:@"estimatedProgress" options:NSKeyValueObservingOptionNew context:nil];
    self.navigationController.interactivePopGestureRecognizer.delegate = (id)self;
}
- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary<NSString *,id> *)change context:(void *)context {
    if ([keyPath isEqualToString:@"estimatedProgress"]) {
        self.progressView.hidden = (self.wkwView.estimatedProgress == 1);
        [self.progressView setProgress:self.wkwView.estimatedProgress animated:YES];
        self.progressView.progressTintColor = [UIColor colorR:0xff g:0x72 b:0 a:1];
    }
}
- (WKWebView *)wkwView{
    if (_wkwView == nil) {
        _wkwView = [[WKWebView alloc] initWithFrame:self.view.bounds];
    }
    return _wkwView;
}

- (void)popSelf {
    if ([self.wkwView canGoBack]) {
        [self.wkwView goBack];
    } else {
        [self.navigationController popViewControllerAnimated:YES];
    }
}
- (void)allClose{
    [self.navigationController popViewControllerAnimated:1];
}

- (void)dealloc{
    [self.wkwView removeObserver:self forKeyPath:@"estimatedProgress"];
    [self.progressView removeFromSuperview];
}

@end







