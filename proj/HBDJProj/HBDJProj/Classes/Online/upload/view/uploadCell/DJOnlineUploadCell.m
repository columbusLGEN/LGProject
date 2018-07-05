//
//  DJOnlineUplaodCell.m
//  HBDJProj
//
//  Created by Peanut Lee on 2018/7/3.
//  Copyright © 2018年 Lee. All rights reserved.
//

#import "DJOnlineUploadCell.h"
#import "DJOnlineUploadTableModel.h"

#import "DJOnlineUplaodTableViewController.h"

@interface DJOnlineUploadCell ()<
UITextFieldDelegate>
@property (weak,nonatomic) UITextField *txt;

@end

@implementation DJOnlineUploadCell

#pragma mark - UITextFieldDelegate
- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string{
    NSString *updateString = [textField.text stringByReplacingCharactersInRange:range withString:string];
    textField.text = updateString;
    [self.vc setFormDataDictValue:updateString indexPath:self.indexPath];
    
    return NO;
}

- (void)setModel:(DJOnlineUploadTableModel *)model{
    [super setModel:model];

}

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        
        UITextField *textField = UITextField.new;
        _txt = textField;
        [self.contentView addSubview:_txt];
        _txt.delegate = self;
        _txt.font = [UIFont systemFontOfSize:14];
        _txt.textColor = [UIColor EDJGrayscale_11];
        [_txt setBorderStyle:UITextBorderStyleRoundedRect];
        [_txt mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.item.mas_right).offset(marginTen);
            make.right.equalTo(self.contentView.mas_right).offset(-marginTen);
            make.centerY.equalTo(self.contentView.mas_centerY);
        }];
        
    }
    return self;
}

@end
