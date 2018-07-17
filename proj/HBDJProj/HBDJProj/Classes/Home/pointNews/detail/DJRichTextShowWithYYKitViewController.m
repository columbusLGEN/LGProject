//
//  DJRichTextShowWithYYKitViewController.m
//  HBDJProj
//
//  Created by Peanut Lee on 2018/7/14.
//  Copyright © 2018年 Lee. All rights reserved.
//

#import "DJRichTextShowWithYYKitViewController.h"
#import <YYText/YYText.h>
#import "LGHTMLParser.h"
#import "DCRichTextTopInfoView.h"
#import "DJDataBaseModel.h"

@interface DJRichTextShowWithYYKitViewController ()<
YYTextViewDelegate>

@property (weak,nonatomic) DCRichTextTopInfoView *topInfoView;

@property (strong,nonatomic) YYTextView *richView;

@end

@implementation DJRichTextShowWithYYKitViewController

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:NO animated:YES];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self.view addSubview:_richView];
    [_richView addSubview:self.topInfoView];
}

- (void)setContentModel:(DJDataBaseModel *)contentModel{
    _contentModel = contentModel;
    
    self.topInfoView.model = contentModel;
    
    [LGHTMLParser HTMLSaxWithHTMLString:contentModel.content success:^(NSAttributedString *attrString) {
        
        YYTextView *richView = YYTextView.new;
        _richView = richView;
        _richView.textContainerInset = UIEdgeInsetsMake(richTextTopInfoViewHeight, 10, 10, 10);
//        _richView.font = [UIFont systemFontOfSize:17];
        _richView.delegate = self;
        _richView.frame = self.view.bounds;
        _richView.editable = NO;
        
        _richView.attributedText = attrString;
       
    }];
}

- (void)textView:(YYTextView *)textView didTapHighlight:(YYTextHighlight *)highlight inRange:(NSRange)characterRange rect:(CGRect)rect{
    NSLog(@"点击超链接: ");
}

- (DCRichTextTopInfoView *)topInfoView{
    if (!_topInfoView) {
        _topInfoView = [DCRichTextTopInfoView richTextTopInfoView];
        _topInfoView.frame = CGRectMake(0, 0, kScreenWidth, richTextTopInfoViewHeight);
    }
    return _topInfoView;
}

@end
