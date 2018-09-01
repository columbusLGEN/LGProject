//
//  UCWriteFeedbackViewController.m
//  HBDJProj
//
//  Created by Peanut Lee on 2018/4/20.
//  Copyright © 2018年 Lee. All rights reserved.
//

#import "UCWriteFeedbackViewController.h"
#import <objc/runtime.h>
#import "UITextView+Extension.h"
#import "DJUserNetworkManager.h"

@interface UCWriteFeedbackViewController ()
@property (weak, nonatomic) IBOutlet UITextView *textView;
@property (weak, nonatomic) IBOutlet UIButton *commit;
@property (weak, nonatomic) IBOutlet UIButton *cancel;

@end

@implementation UCWriteFeedbackViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self uiConfig];
    
    /// 通过运行时,查看 类的 实例变量列表
//    unsigned int count = 0;
//    Ivar *ivars = class_copyIvarList([UITextView class], &count);
//    for (int i = 0; i < count; i++) {
//        Ivar ivar = ivars[i];
//        const char * name = ivar_getName(ivar);
//        NSString *objcName = [NSString stringWithUTF8String:name];
//        NSLog(@"%d objcname: %@",i,objcName);
//    }
   
}

- (IBAction)commit:(id)sender {
    if ([_textView.text isEqualToString:@""] || _textView.text == nil) {
        [self presentFailureTips:@"请输入您要反馈的内容"];
        return;
    }
    [DJUserNetworkManager.sharedInstance frontFeedback_addWithTitle:_textView.text success:^(id responseObj) {
        [self presentMessageTips:@"提交成功，请耐心等待管理员恢复"];
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.8 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            [self lg_dismissViewController];
        });
    } failure:^(id failureObj) {
        [self presentFailureTips:@"提交失败，请检查网络后重试"];
    }];
    
}
- (IBAction)cancel:(id)sender {
    
}

- (void)uiConfig{
    self.title = @"反馈意见";
    CGFloat cornerRadius = 19;
    [_commit setTitle:@"提交" forState:UIControlStateNormal];
    [_commit setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [_commit setBackgroundColor:[UIColor EDJMainColor]];
    [_commit cutBorderWithBorderWidth:0 borderColor:nil cornerRadius:cornerRadius];
    
    [_cancel setTitle:@"取消" forState:UIControlStateNormal];
    [_cancel setTitleColor:[UIColor EDJMainColor] forState:UIControlStateNormal];
    [_cancel cutBorderWithBorderWidth:1 borderColor:[UIColor EDJMainColor] cornerRadius:cornerRadius];
    
    _textView.text = nil;
    
    [_textView cutBorderWithBorderWidth:0.5 borderColor:[UIColor EDJColor_E0B5B1] cornerRadius:0];
    [_textView lg_setplaceHolderTextWithText:self.textViewPlaceHolder textColor:[UIColor EDJColor_E0B5B1] font:15];
    NSLog(@"textview -- %@",_textView);
}

- (NSString *)textViewPlaceHolder{
    if (_textViewPlaceHolder == nil) {
        _textViewPlaceHolder = @"请写下您的意见或建议";
    }
    return _textViewPlaceHolder;
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
