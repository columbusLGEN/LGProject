//
//  ECRBaseWkViewController.h
//  EasyChineseReading-ios
//
//  Created by Peanut Lee on 2017/11/8.
//  Copyright © 2017年 retech. All rights reserved.
//

#import "LGBaseViewController.h"

@class WKWebView;

@interface LGWKWebViewController : LGBaseViewController

- (instancetype)initWithUrl:(NSURL *)URL;

/** 标题 */
@property (copy,nonatomic) NSString *wkTitle;

@property (strong,nonatomic) WKWebView *wkView;

@end
