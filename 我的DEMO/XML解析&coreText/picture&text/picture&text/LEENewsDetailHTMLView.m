//
//  LEENewsDetailHTMLView.m
//  picture&text
//
//  Created by Peanut Lee on 2018/3/27.
//  Copyright © 2018年 LG. All rights reserved.
//

#import "LEENewsDetailHTMLView.h"
#import <WebKit/WebKit.h>

@interface LEENewsDetailHTMLDelegate : NSObject<UIWebViewDelegate>
/**  */
//@property (weak,nonatomic)  LEENewsDetailHTMLView *view;

@end

@implementation LEENewsDetailHTMLDelegate

- (void)webViewDidStartLoad:(UIWebView *)webView{
}

@end

@interface LEENewsDetailHTMLView ()
/**  */
@property (weak,nonatomic) WKWebView *wkWebView;
/**  */
@property (weak,nonatomic) UIWebView *webView;
/**  */
@property (strong,nonatomic) LEENewsDetailHTMLDelegate *webViewDelegate;

@end

@implementation LEENewsDetailHTMLView

- (void)setHtml:(NSString *)html{
    _html = html;
    [_wkWebView loadHTMLString:html baseURL:nil];
    
}

- (instancetype)initWithFrame:(CGRect)frame{
    if (self = [super initWithFrame:frame]) {
        
        /// webkit
        WKWebView *webView = [[WKWebView alloc] initWithFrame:self.bounds];
        [self addSubview:webView];
        _wkWebView = webView;
//        _wkWebView.UIDelegate;
//        _wkWebView.navigationDelegate;
        
        
        // uiwebview
//        _webViewDelegate = [LEENewsDetailHTMLDelegate new];
//        UIWebView *webView = [[UIWebView alloc] initWithFrame:self.bounds];
//        [self addSubview:webView];
//        _webView = webView;
//        _webView.delegate = _webViewDelegate;
////        _webViewDelegate.view = self;
//        _webView.scalesPageToFit = YES;
//        [_webView loadHTMLString:html baseURL:nil];
        
    }
    return self;
}

@end
