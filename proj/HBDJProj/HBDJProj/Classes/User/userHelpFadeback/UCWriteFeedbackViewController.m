//
//  UCWriteFeedbackViewController.m
//  HBDJProj
//
//  Created by Peanut Lee on 2018/4/20.
//  Copyright © 2018年 Lee. All rights reserved.
//

#import "UCWriteFeedbackViewController.h"
#import <objc/runtime.h>

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
    [_textView cutBorderWithBorderWidth:0.5 borderColor:[UIColor EDJMainColor] cornerRadius:0];
    
    UILabel *placeHolder = [UILabel new];
    placeHolder.text = @"请写下您的意见或建议";
    placeHolder.textColor = [UIColor EDJMainColor];
    placeHolder.font = [UIFont systemFontOfSize:15];
    [placeHolder sizeToFit];
    [_textView addSubview:placeHolder];
    [_textView setValue:placeHolder forKey:@"_placeholderLabel"];
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
