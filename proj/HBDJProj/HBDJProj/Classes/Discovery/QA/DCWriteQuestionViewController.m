//
//  DCWriteQuestionViewController.m
//  HBDJProj
//
//  Created by Peanut Lee on 2018/4/28.
//  Copyright © 2018年 Lee. All rights reserved.
//

#import "DCWriteQuestionViewController.h"
#import "UITextView+Extension.h"

@interface DCWriteQuestionViewController ()
@property (weak,nonatomic) UITextView *textView;
@property (weak,nonatomic) UIButton *commit;
@property (weak,nonatomic) UIButton *cancel;

@end

@implementation DCWriteQuestionViewController

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:NO animated:YES];
}

- (void)viewDidLayoutSubviews{
    [super viewDidLayoutSubviews];
    
    [_commit cutBorderWithBorderWidth:0 borderColor:nil cornerRadius:_commit.height / 2];
    [_cancel cutBorderWithBorderWidth:1 borderColor:[UIColor EDJColor_E0B5B1] cornerRadius:_cancel.height / 2];
    
}
- (void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = @"提问";
    
    UITextView *textView = [UITextView new];
    
    UIButton *commit = [UIButton new];
    UIButton *cancel = [UIButton new];
    
    [self.view addSubview:textView];
    [self.view addSubview:commit];
    [self.view addSubview:cancel];
    
    [textView mas_makeConstraints:^(MASConstraintMaker *make) {
//        if (@available(iOS 11.0, *)) {
//            make.top.equalTo(self.view.mas_safeAreaLayoutGuideTop).offset(9);
//        }else{
//            make.top.equalTo(self.view.mas_topMargin).offset(9);
//        }
        make.top.equalTo(self.view.mas_top).offset(kNavHeight + 9);
        make.left.equalTo(self.view.mas_left).offset(marginTwelve);
        make.right.equalTo(self.view.mas_right).offset(-marginTwelve);
        make.height.mas_equalTo(200);
    }];
    [commit mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(textView.mas_bottom).offset(57);
        make.height.mas_equalTo(38);
        make.left.equalTo(self.view.mas_left).offset(50);
        make.right.equalTo(self.view.mas_right).offset(-50);
    }];
    [cancel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(commit.mas_bottom).offset(24);
        make.left.equalTo(commit.mas_left);
        make.height.equalTo(commit.mas_height);
        make.width.equalTo(commit.mas_width);
    }];
    
    /// 样式
    textView.font = [UIFont systemFontOfSize:15];
    textView.textColor = [UIColor EDJGrayscale_33];
    [textView cutBorderWithBorderWidth:0.5 borderColor:[UIColor EDJColor_E0B5B1] cornerRadius:0];
    [textView lg_setplaceHolderTextWithText:@"请写下您的问题" textColor:[UIColor EDJColor_E0B5B1] font:15];
    
    [commit setTitle:@"提交" forState:UIControlStateNormal];
    [commit setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [commit setBackgroundColor:[UIColor EDJMainColor]];
    
    [cancel setTitle:@"取消" forState:UIControlStateNormal];
    [cancel setTitleColor:[UIColor EDJMainColor] forState:UIControlStateNormal];
    [cancel setBackgroundColor:[UIColor whiteColor]];
    
    
    _textView = textView;
    _commit = commit;
    _cancel = cancel;
}


@end
