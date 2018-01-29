//
//  UCommentVC.m
//  EasyChineseReading-ios
//
//  Created by 赵春阳 on 17/8/30.
//  Copyright © 2017年 lee. All rights reserved.
//

#import "UserCommentVC.h"

#import "UserSetVC.h"

@interface UserCommentVC ()<UITextViewDelegate>

@property (weak, nonatomic) IBOutlet UITextView *txtView;
@property (weak, nonatomic) IBOutlet UILabel *lblPlaceholder;
@property (weak, nonatomic) IBOutlet UILabel *lblTextLength;

@end

@implementation UserCommentVC

- (void)viewDidLoad {
    [super viewDidLoad];
    [self configNavigationBar];
    [self configTextView];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark -
/** 配置 textView */
- (void)configTextView
{
    self.title = LOCALIZATION(@"意见反馈");
    _lblPlaceholder.text = LOCALIZATION(@"请输入你的意见反馈");

    _txtView.layer.borderWidth = 1.f;
    _txtView.layer.borderColor = [UIColor cm_blackColor_333333_1].CGColor;
    
    _lblTextLength.textColor = [UIColor cm_blackColor_666666_1];
    _lblTextLength.font      = [UIFont systemFontOfSize:cFontSize_14];
    _lblTextLength.text      = [NSString stringWithFormat:@"0/%ld", cMaxCommentLength];
}

/** 配置 navigationBar */
- (void)configNavigationBar
{
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:LOCALIZATION(@"发送") style:UIBarButtonItemStylePlain target:self action:@selector(pushComment)];
}

#pragma mark - 
/** 发送意见反馈 */
- (void)pushComment
{
    if (_txtView.text.length == 0) {
        [self presentFailureTips:LOCALIZATION(@"请输入你的意见反馈")];
    }
    else if (_txtView.text.charLength > cMaxCommentLength) {
        [self presentFailureTips:[NSString stringWithFormat:@"%@%@ %ld", LOCALIZATION(@"意见反馈"), LOCALIZATION(@"字符长度为"), cMaxCommentLength]];
    }
    else {
        [self showWaitTips];
        WeakSelf(self)
        [[UserRequest sharedInstance] submitFeedbackWithMessage:_txtView.text phoneModel:[IPhoneVersion deviceName] mobileSystem:SSystemVersion appversion:appVersion completion:^(id object, ErrorModel *error) {
            StrongSelf(self)
            [self dismissTips];
            if (error) {
                [self presentFailureTips:error.message];
            }
            else {
                [self presentSuccessTips:LOCALIZATION(@"发送成功, 感谢您的反馈")];
                dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                    [self popToViewControllerWithController:[UserSetVC class] completionBlock:^{}];                    
                });
            }
        }];
    }
}

#pragma mark - UITextViewDelegate
- (void)textViewDidChange:(UITextView *)textView
{
    _lblPlaceholder.hidden = textView.text.length > 0;
    _lblTextLength.text = [NSString stringWithFormat:@"%ld/%ld", textView.text.charLength, cMaxCommentLength];
}

@end
