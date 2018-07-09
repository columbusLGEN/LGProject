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
UITextFieldDelegate,
UITextViewDelegate>
//@property (weak,nonatomic) UITextField *txt;
@property (weak,nonatomic) UITextView *txt;

@end

@implementation DJOnlineUploadCell

#pragma mark - UITextFieldDelegate
- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string{
    NSString *updateString = [textField.text stringByReplacingCharactersInRange:range withString:string];
    textField.text = updateString;
    [self.vc setFormDataDictValue:updateString indexPath:self.indexPath];
    
    return NO;
}

#pragma mark - UITextViewDelegate
- (void)textViewDidChange:(UITextView *)textView{
    self.model.content = textView.text;
    // 计算高度
    CGSize textSize = [textView.text sizeOfTextWithMaxSize:CGSizeMake(textView.size.width, MAXFLOAT) font:textView.font];
    
    NSLog(@"text: %@ -- %@",textView.text,NSStringFromCGSize(textSize));
    
}

- (void)setModel:(DJOnlineUploadTableModel *)model{
    [super setModel:model];
    _txt.text = model.content;
}

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        
//        UITextField *textField = UITextField.new;
//        _txt = textField;
//        [self.contentView addSubview:_txt];
//        _txt.delegate = self;
//        _txt.font = [UIFont systemFontOfSize:14];
//        _txt.textColor = [UIColor EDJGrayscale_11];
//        [_txt setBorderStyle:UITextBorderStyleNone];
//        [_txt mas_makeConstraints:^(MASConstraintMaker *make) {
//            make.left.equalTo(self.item.mas_right).offset(marginTen);
//            make.right.equalTo(self.contentView.mas_right).offset(-marginTen);
//            make.centerY.equalTo(self.contentView.mas_centerY);
//        }];

        UITextView *textView = UITextView.new;
        textView.scrollEnabled = NO;
        textView.backgroundColor = UIColor.orangeColor;
        _txt = textView;
        [self.contentView addSubview:_txt];
        _txt.delegate = self;
        _txt.font = [UIFont systemFontOfSize:14];
        _txt.textColor = [UIColor EDJGrayscale_11];
        [_txt mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.item.mas_right).offset(marginTen);
            make.right.equalTo(self.contentView.mas_right).offset(-marginTen);
            make.top.equalTo(self.contentView.mas_top).offset(marginFive);
            make.bottom.equalTo(self.contentView.mas_bottom).offset(-marginFive);
        }];
    }
    return self;
}

@end
