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
@property (strong,nonatomic) UIProgressView *progressView;

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
    NSURLRequest *request = [NSURLRequest requestWithURL:self.URL];
    [self.wkView loadRequest:request];
    [_wkView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.view);
    }];
    
    /// 添加进度条
    self.progressView = [[UIProgressView alloc]initWithFrame:CGRectMake(0, kNavHeight, CGRectGetWidth(self.view.frame), 2)];
    self.progressView.trackTintColor  = [UIColor whiteColor];
    self.progressView.progressTintColor = UIColor.EDJMainColor;
    [self.view addSubview:self.progressView];
    
    // 给webview添加监听
    [self.wkView addObserver:self forKeyPath:@"estimatedProgress" options:NSKeyValueObservingOptionOld | NSKeyValueObservingOptionNew context:nil];
    
    
}

//页面加载完成之后调用

- (void)webView:(WKWebView *)webView didFinishNavigation:(WKNavigation *)navigation {
    
    [webView evaluateJavaScript:@"document.body.offsetHeight;" completionHandler:^(id _Nullable any, NSError * _Nullable error) {
        
        NSString *heightStr = [NSString stringWithFormat:@"%@",any];
        
//        //下面的wkWeb已经可以完美展示了，不过我的界面是自定义的
//
//        wk_web.frame = CGRectMake(0, _headerImage.frame.origin.y + ScreenW, ScreenW, heightStr.floatValue);
//
//        //所以，我的界面最底部是scrollView，其中包含：其他的视图 + wk_web，注意：100 + ScreenW 就是其他的视图，举个简单的例子而已。
//
//        _mScroll_ViewHHH.constant = 100 + ScreenW + heightStr.floatValue;
        
        
    }];
    
}

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary<NSKeyValueChangeKey,id> *)change context:(void *)context{
    if ([keyPath isEqual:@"estimatedProgress"] && object == self.wkView) {
        [self.progressView setAlpha:1.0f];
        [self.progressView setProgress:self.wkView.estimatedProgress animated:YES];
        if (self.wkView.estimatedProgress  >= 1.0f) {
            [UIView animateWithDuration:0.3 delay:0.3 options:UIViewAnimationOptionCurveEaseOut animations:^{
                [self.progressView setAlpha:0.0f];
            } completion:^(BOOL finished) {
                [self.progressView setProgress:0.0f animated:YES];
            }];
        }
    }else{
        [super observeValueForKeyPath:keyPath ofObject:object change:change context:context];
    }
}

- (void)setWkTitle:(NSString *)wkTitle{
    _wkTitle = wkTitle;
    self.title = wkTitle;
}


#pragma mark - WKUIDelegate

#pragma mark - WKNavigationDelegate
-(void)webView:(WKWebView *)webView decidePolicyForNavigationAction:(WKNavigationAction *)navigationAction decisionHandler:(void (^)(WKNavigationActionPolicy))decisionHandler {
    //如果是跳转一个新页面
    if (navigationAction.targetFrame == nil) {
        [webView loadRequest:navigationAction.request];
    }
    
    decisionHandler(WKNavigationActionPolicyAllow);
}

- (void)lg_dismissViewController{
    if ([_wkView canGoBack]) {
        [_wkView goBack];
    }else{
        [super lg_dismissViewController];
    }
}

- (void)dealloc{
    [self.wkView removeObserver:self forKeyPath:@"estimatedProgress"];
    [self.wkView setNavigationDelegate:nil];
    [self.wkView setUIDelegate:nil];
}

- (WKWebView *)wkView{
    if (_wkView == nil) {
        
        /// 添加要注入的 js 代码 (本段代码保证图片适应手机屏幕显示)
        NSString *jScript = @"\
        var meta = document.createElement('meta'); \
        meta.setAttribute('name', 'viewport'); \
        meta.setAttribute('content', 'width=device-width');\
        document.getElementsByTagName('head')[0].appendChild(meta); \
        var imgs = document.getElementsByTagName('img');\
        for (var i in imgs){\
        imgs[i].style.maxWidth='100%';\
        imgs[i].style.height='auto';\
        }";
        WKUserScript *wkUScript = [[WKUserScript alloc] initWithSource:jScript injectionTime:WKUserScriptInjectionTimeAtDocumentEnd forMainFrameOnly:YES];
        WKUserContentController *wkUController = [[WKUserContentController alloc] init];
        [wkUController addUserScript:wkUScript];
        WKWebViewConfiguration *wkWebConfig = [[WKWebViewConfiguration alloc] init];
        wkWebConfig.userContentController = wkUController;

        _wkView = [[WKWebView alloc] initWithFrame:CGRectZero configuration:wkWebConfig];
        
//        _wkView = [[WKWebView alloc] initWithFrame:CGRectZero];
        
        _wkView.UIDelegate = self;
        _wkView.navigationDelegate = self;
        [self.view addSubview:_wkView];
    }
    return _wkView;
}


@end
