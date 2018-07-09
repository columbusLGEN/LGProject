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

@property (assign,nonatomic) CGFloat lineHeight;

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
- (void)textViewDidBeginEditing:(UITextView *)textView{
    /// 1.记录初始行高
    _lineHeight = textView.font.lineHeight;
}
- (void)textViewDidChange:(UITextView *)textView{
    self.model.content = textView.text;
    CGSize textSize = [textView.text sizeOfTextWithMaxSize:CGSizeMake(textView.size.width, MAXFLOAT) font:textView.font];
    /// 2.实时计算文本内容的高度,并返回当前行数
    [self currentLine:textSize];
    
}

- (void)currentLine:(CGSize)textSize{
    int line = textSize.height / _lineHeight;
    if ([self.delegate respondsToSelector:@selector(userInputContenLineFeed:
                                                    textView:
                                                    lineCount:
                                                    singleHeight:
                                                    reloadCallBack:)]) {
        [self.delegate userInputContenLineFeed:self textView:_txt lineCount:line singleHeight:_lineHeight reloadCallBack:^(UITextView *currentTextView, CGFloat textHeight) {
//            [self.txt becomeFirstResponder];
//            [currentTextView mas_updateConstraints:^(MASConstraintMaker *make) {
//                
//            }];
        }];
        
    }
}

- (void)setModel:(DJOnlineUploadTableModel *)model{
    [super setModel:model];
    if (model.content) {
//        _txt.text = model.content;
    }
}

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {

        UITextView *textView = UITextView.new;
//        textView.scrollEnabled = NO;
        textView.backgroundColor = UIColor.randomColor;
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
            make.height.mas_equalTo(34);
        }];
        
    }
    return self;
}

@end
