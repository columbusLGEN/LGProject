//
//  DJSendCommentsViewController.m
//  HBDJProj
//
//  Created by Peanut Lee on 2018/8/16.
//  Copyright © 2018年 Lee. All rights reserved.
//

#import "DJSendCommentsViewController.h"
#import "DJCommentInputView.h"

@interface DJSendCommentsViewController ()
@property (weak,nonatomic) UIButton *bgButton;
@property (weak,nonatomic) DJCommentInputView *inputView;

@end

@implementation DJSendCommentsViewController


- (void)viewDidLayoutSubviews{
    [super viewDidLayoutSubviews];
    [_inputView cutBorderWithBorderWidth:0 borderColor:nil cornerRadius:5];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillChangeFrame:) name:UIKeyboardWillChangeFrameNotification object:nil];
    
    self.view.backgroundColor = [UIColor clearColor];
    
    UIButton *button = [UIButton.alloc initWithFrame:self.view.bounds];
    _bgButton = button;
    [_bgButton addTarget:self action:@selector(lg_dismissViewController) forControlEvents:UIControlEventTouchUpInside];
    [_bgButton setBackgroundColor:[UIColor colorWithWhite:0 alpha:0.5]];

    [self.view addSubview:_bgButton];
    
    DJCommentInputView *inputView = DJCommentInputView.new;
    _inputView = inputView;
//    _inputView.alpha = 0;
    [self.view addSubview:_inputView];
    [_inputView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.view.mas_centerX);
        make.centerY.equalTo(self.view.mas_centerY);
        make.width.mas_equalTo(kScreenWidth * 0.92);
        make.height.mas_equalTo(200);
    }];
}

#pragma mark - notifications
- (void)keyboardWillChangeFrame:(NSNotification *)notification{
    NSDictionary *userInfo = notification.userInfo;
    CGRect frameBegin = [userInfo[UIKeyboardFrameBeginUserInfoKey] CGRectValue];
    CGRect frameEnd = [userInfo[UIKeyboardFrameEndUserInfoKey] CGRectValue];
    
    NSLog(@"frameBegin -- %@ ",NSStringFromCGRect(frameBegin));
    //    NSLog(@"frameEnd -- %@",NSStringFromCGRect(frameEnd));
    CGFloat offsetY = frameBegin.origin.y - frameEnd.origin.y;
    NSLog(@"willchangeframe.y -- %f",offsetY);
    
}

- (void)lg_dismissViewController{
    [self.view endEditing:YES];
    [super lg_dismissViewController];
}

- (void)dealloc{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

@end
