//
//  DJSendCommentsViewController.m
//  HBDJProj
//
//  Created by Peanut Lee on 2018/8/16.
//  Copyright © 2018年 Lee. All rights reserved.
//

#import "DJSendCommentsViewController.h"
#import "DJCommentInputView.h"
#import "DJDiscoveryNetworkManager.h"
#import "DJDataBaseModel.h"

@interface DJSendCommentsViewController ()<
UITextViewDelegate>
@property (weak,nonatomic) UIButton *bgButton;
@property (weak,nonatomic) DJCommentInputView *inputView;

@end

@implementation DJSendCommentsViewController

+ (instancetype)sendCommentvcWithModel:(DJDataBaseModel *)model{
    DJSendCommentsViewController *vc = DJSendCommentsViewController.new;
    vc.model = model;
    vc.pushWay = LGBaseViewControllerPushWayModal;
    vc.modalTransitionStyle = UIModalTransitionStyleCrossDissolve;
    vc.modalPresentationStyle = UIModalPresentationOverFullScreen;
    return vc;
}

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
    [_inputView.done addTarget:self action:@selector(sendComment) forControlEvents:UIControlEventTouchUpInside];
    [_inputView.cancel addTarget:self action:@selector(lg_dismissViewController) forControlEvents:UIControlEventTouchUpInside];
    _inputView.input.delegate = self;
    [self.view addSubview:_inputView];
    [_inputView.input becomeFirstResponder];
    
    [_inputView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.view.mas_centerX);
        make.centerY.equalTo(self.view.mas_centerY);
        make.width.mas_equalTo(kScreenWidth * 0.92);
        make.height.mas_equalTo(200);
    }];
}

#pragma mark - notifications
- (void)keyboardWillChangeFrame:(NSNotification *)notification{
//    NSDictionary *userInfo = notification.userInfo;
//    CGRect frameBegin = [userInfo[UIKeyboardFrameBeginUserInfoKey] CGRectValue];
//    CGRect frameEnd = [userInfo[UIKeyboardFrameEndUserInfoKey] CGRectValue];
//
//    NSLog(@"frameBegin -- %@ ",NSStringFromCGRect(frameBegin));
//    //    NSLog(@"frameEnd -- %@",NSStringFromCGRect(frameEnd));
//    CGFloat offsetY = frameBegin.origin.y - frameEnd.origin.y;
//    NSLog(@"willchangeframe.y -- %f",offsetY);

    /*
     UIKeyboardAnimationCurveUserInfoKey = 7; // 动画的执行节奏（速度）
     UIKeyboardAnimationDurationUserInfoKey = "0.25"; // 键盘弹出\隐藏动画所需的时间
     UIKeyboardBoundsUserInfoKey = "NSRect: {{0, 0}, {375, 216}}";
     UIKeyboardCenterBeginUserInfoKey = "NSPoint: {187.5, 775}";
     UIKeyboardCenterEndUserInfoKey = "NSPoint: {187.5, 559}";

     // 键盘弹出
     UIKeyboardFrameBeginUserInfoKey = "NSRect: {{0, 667}, {375, 216}}"; // 键盘刚出来那一刻的frame
     UIKeyboardFrameEndUserInfoKey = "NSRect: {{0, 451}, {375, 216}}"; // 键盘显示完毕之后的frame

     // 键盘隐藏
     UIKeyboardFrameBeginUserInfoKey = "NSRect: {{0, 451}, {375, 216}}";
     UIKeyboardFrameEndUserInfoKey = "NSRect: {{0, 667}, {375, 216}}";
     */

    // 0.取出键盘动画的时间
    CGFloat duration = [notification.userInfo[UIKeyboardAnimationDurationUserInfoKey] doubleValue];
    // 1.取得键盘最后的frame
    CGRect keyboardFrame = [notification.userInfo[UIKeyboardFrameEndUserInfoKey] CGRectValue];
    // 2.计算控制器的view需要平移的距离
    CGFloat transformY = (keyboardFrame.origin.y - self.view.frame.size.height) * 0.5;

    [UIView animateWithDuration:duration animations:^{
        self.view.transform = CGAffineTransformMakeTranslation(0, transformY);
    }];
}

#pragma mark - delegate
//- textview

- (void)sendComment{
    if (_inputView.input.text == nil || [_inputView.input.text isEqualToString:@""]) {
        [self presentFailureTips:@"请输入评论内容"];
        return;
    }
    [DJDiscoveryNetworkManager.sharedInstance frontComments_addWithCommentid:self.model.seqid commenttype:_commenttype comment:_inputView.input.text success:^(id responseObj) {
        [self presentSuccessTips:uploadNeedsCheckString];
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.8 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            [self lg_dismissViewController];
        });
    } failure:^(id failureObj) {
        [self presentSuccessTips:@"发表失败，稍后重试"];
    }];
}

- (void)lg_dismissViewController{
    [self.view endEditing:YES];
    [super lg_dismissViewController];
}

- (void)dealloc{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

@end
