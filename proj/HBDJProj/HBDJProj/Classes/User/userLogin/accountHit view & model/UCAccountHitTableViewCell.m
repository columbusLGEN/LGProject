//
//  UCAccountHitTableViewCell.m
//  HBDJProj
//
//  Created by Peanut Lee on 2018/5/17.
//  Copyright © 2018年 Lee. All rights reserved.
//

#import "UCAccountHitTableViewCell.h"
#import "UCAccountHitModel.h"
#import "UCAccountHitViewController.h"

@interface UCAccountHitTableViewCell ()<
UITextFieldDelegate>
@property (weak, nonatomic) IBOutlet UIImageView *icon;
@property (weak, nonatomic) IBOutlet UITextField *txtField;


@end

@implementation UCAccountHitTableViewCell

#pragma mark - txt delegate
/// 实现该代理方法中的代码，可以 加密的UITextField在重新输入密码时，不清空之前的内容
- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string {
    NSString *updatedString = [textField.text stringByReplacingCharactersInRange:range withString:string];
    textField.text = updatedString;
    [self.vc.activationDict setValue:updatedString forKey:[NSString stringWithFormat:@"%ld",self.index.row]];
    NSLog(@"textfield.text: %@",updatedString);
    return NO;
}


- (void)setModel:(UCAccountHitModel *)model{
    _model = model;
    _icon.image = [UIImage imageNamed:model.iconName];
    _txtField.placeholder = model.placeholder;
    
}

//- (void)txtFieldValueChanged:(NSNotification *)notification{
//    UITextField *txt = notification.object;
//    if ([txt isEqual:self.txtField]) {
//
//    }
//}

- (void)setIndex:(NSIndexPath *)index{
    _index = index;
    switch (index.row) {
        case 0:
            self.txtField.keyboardType = UIKeyboardTypePhonePad;
            break;
        case 1:
        case 2:
        case 3:
            self.txtField.secureTextEntry = YES;
            break;

    }
}

- (void)awakeFromNib {
    [super awakeFromNib];
    self.selectionStyle = UITableViewCellSelectionStyleNone;
    self.txtField.delegate = self;
    
//    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(txtFieldValueChanged:) name:UITextFieldTextDidChangeNotification object:nil];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

}
- (void)dealloc{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}
@end
