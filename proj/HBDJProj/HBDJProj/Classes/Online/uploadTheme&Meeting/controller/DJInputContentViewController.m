//
//  DJInputContentViewController.m
//  HBDJProj
//
//  Created by Peanut Lee on 2018/7/10.
//  Copyright © 2018年 Lee. All rights reserved.
//

#import "DJInputContentViewController.h"
#import "DJOnlineUploadTableModel.h"

@interface DJInputContentViewController ()<
UITextViewDelegate>
@property (weak,nonatomic) UITextView *textView;

@end

@implementation DJInputContentViewController

+ (LGBaseNavigationController *)modalInputvcWithModel:(id)model delegate:(id)delegate{
    DJInputContentViewController *vc = self.new;
    vc.model = model;
    vc.delegate = delegate;
    vc.pushWay = LGBaseViewControllerPushWayModal;
    LGBaseNavigationController *nav = [LGBaseNavigationController.alloc initWithRootViewController:vc];
    return nav;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    UIBarButtonItem *cancel = [UIBarButtonItem.alloc initWithTitle:@"取消" style:UIBarButtonItemStyleDone target:self action:@selector(lg_dismissViewController)];
    self.navigationItem.leftBarButtonItem = cancel;
    
    UIBarButtonItem *done = [UIBarButtonItem.alloc initWithTitle:@"确定" style:UIBarButtonItemStyleDone target:self action:@selector(inputDone)];
    self.navigationItem.rightBarButtonItem = done;
    
    UITextView *txtView = UITextView.new;
    _textView = txtView;
    [self.view addSubview:_textView];
    [_textView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.view.mas_top).offset(kNavHeight + marginFive);
        make.left.equalTo(self.view.mas_left).offset(marginFive);
        make.right.equalTo(self.view.mas_right).offset(-marginFive);
        make.bottom.equalTo(self.view.mas_bottom).offset(-marginFive);
    }];
    _textView.font = [UIFont systemFontOfSize:17];
    _textView.delegate = self;
    [_textView cutBorderWithBorderWidth:1 borderColor:UIColor.EDJGrayscale_F3 cornerRadius:0];
    
    UILabel *placeholder = UILabel.new;
    placeholder.textColor = UIColor.EDJGrayscale_F3;
    placeholder.text = @"请输入内容";
    placeholder.font = [UIFont systemFontOfSize:15];
    placeholder.numberOfLines = 0;
    [placeholder sizeToFit];
    
    [_textView addSubview:placeholder];
    [_textView setValue:placeholder forKey:@"placeholderLabel"];
//    [_textView setValue:placeholder forKey:@"_placeholderLabel"];
    
    if (_model.content) {
        _textView.text = _model.content;
    }
}

- (void)inputDone{
    /// 通知代理
    if (_textView.text.length > 0) {
        self.model.content = _textView.text;
    }
    if ([self.delegate respondsToSelector:@selector(inputContentViewController:model:)]) {
        [self.view endEditing:YES];
        [self.delegate inputContentViewController:self model:self.model];
    }
    [self lg_dismissViewController];
}

//- (void)textViewDidBeginEditing:(UITextView *)textView{
//    textView.textColor = UIColor.EDJGrayscale_11;
//}


@end
