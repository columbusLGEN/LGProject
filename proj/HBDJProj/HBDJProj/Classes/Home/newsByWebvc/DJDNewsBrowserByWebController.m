//
//  DJDNewsBrowserByWebController.m
//  HBDJProj
//
//  Created by lee on 2018/12/6.
//  Copyright © 2018 Lee. All rights reserved.
//

#import "DJDNewsBrowserByWebController.h"
#import <WebKit/WebKit.h>

@interface DJDNewsBrowserByWebController ()

@property (strong,nonatomic) WKWebView *wkView;

@end

@implementation DJDNewsBrowserByWebController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self.wkView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.view);
    }];
}

- (WKWebView *)wkView{
    if (!_wkView) {
        _wkView = [WKWebView.alloc initWithFrame:CGRectZero];
//        _wkView.scrollView.contentInset;
        [self.view addSubview:_wkView];
    }
    return _wkView;
}

@end
