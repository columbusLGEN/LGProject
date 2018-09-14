//
//  DJXGDJWebViewController.m
//  HBDJProj
//
//  Created by Peanut Lee on 2018/9/14.
//  Copyright © 2018 Lee. All rights reserved.
//

#import "DJXGDJWebViewController.h"
#import <WebKit/WebKit.h>

@interface DJXGDJWebViewController ()

@end

@implementation DJXGDJWebViewController

//@synthesize wkView = _wkView;
//
//- (WKWebView *)wkView{
//    if (_wkView == nil) {
//        
//        /// 添加要注入的 js 代码 (本段代码保证图片适应手机屏幕显示)
//        NSString *jScript = @"\
//        var meta = document.createElement('meta'); \
//        meta.setAttribute('name', 'viewport'); \
//        meta.setAttribute('content', 'width=device-width');\
//        document.getElementsByTagName('head')[0].appendChild(meta); \
//        var imgs = document.getElementsByTagName('img');\
//        for (var i in imgs){\
//        imgs[i].style.maxWidth='100%';\
//        imgs[i].style.height='auto';\
//        }";
//        WKUserScript *wkUScript = [[WKUserScript alloc] initWithSource:jScript injectionTime:WKUserScriptInjectionTimeAtDocumentEnd forMainFrameOnly:YES];
//        WKUserContentController *wkUController = [[WKUserContentController alloc] init];
//        [wkUController addUserScript:wkUScript];
//        WKWebViewConfiguration *wkWebConfig = [[WKWebViewConfiguration alloc] init];
//        wkWebConfig.userContentController = wkUController;
//        
//        _wkView = [[WKWebView alloc] initWithFrame:CGRectZero configuration:wkWebConfig];
//        
//        //        _wkView = [[WKWebView alloc] initWithFrame:CGRectZero];
//        
//        _wkView.UIDelegate = self;
//        _wkView.navigationDelegate = self;
//        [self.view addSubview:_wkView];
//    }
//    return _wkView;
//}

@end
