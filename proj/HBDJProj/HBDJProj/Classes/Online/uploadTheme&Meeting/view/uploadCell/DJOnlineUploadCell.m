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
UITextViewDelegate>

/** 内容标签 */
@property (weak,nonatomic) UILabel *contentLabel;

@property (assign,nonatomic) CGFloat lineHeight;

@end

@implementation DJOnlineUploadCell

- (void)clickContentLabel:(UIGestureRecognizer *)tap{
    /// 通知代理，点击了contentlabel
    if ([self.delegate respondsToSelector:@selector(userWantBeginInputWithModel:cell:)]) {
        [self.delegate userWantBeginInputWithModel:self.model cell:self];
    }
}

- (void)setModel:(DJOnlineUploadTableModel *)model{
    [super setModel:model];
    if (model.content) {
        _contentLabel.text = model.content;
        _contentLabel.textColor = UIColor.EDJGrayscale_11;
    }
//    [model addObserver:self forKeyPath:keyPath_content options:NSKeyValueObservingOptionNew context:nil];
}

//- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary<NSKeyValueChangeKey,id> *)change context:(void *)context{
//    if ([keyPath isEqualToString:keyPath_content] && object == self.model) {
//        _contentLabel.text = self.model.content;
//    }
//}

//- (void)dealloc{
//    [self.model removeObserver:self forKeyPath:keyPath_content];
//}

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        
        UILabel *label = UILabel.new;
        _contentLabel = label;
        [self.contentView addSubview:_contentLabel];
        /// 默认显示 灰色字体，提示用户
        _contentLabel.numberOfLines = 0;
        _contentLabel.userInteractionEnabled = YES;
        _contentLabel.text = @"请点击以输入内容";
        _contentLabel.textColor = UIColor.EDJGrayscale_EC;
        _contentLabel.font = [UIFont systemFontOfSize:14];
        [_contentLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.item.mas_right).offset(marginEight);
            make.right.equalTo(self.contentView.mas_right).offset(-marginEight);
            make.centerY.equalTo(self.contentView.mas_centerY);
            make.top.equalTo(self.contentView.mas_top).offset(marginFifteen);
            make.bottom.equalTo(self.contentView.mas_bottom).offset(-marginFifteen);
        }];
        
        UITapGestureRecognizer *tapLabel = [UITapGestureRecognizer.alloc initWithTarget:self action:@selector(clickContentLabel:)];
        [_contentLabel addGestureRecognizer:tapLabel];
        
    }
    return self;
}

@end


//        UITextView *textView = UITextView.new;
////        textView.scrollEnabled = NO;
//        textView.backgroundColor = UIColor.randomColor;
//        _txt = textView;
//        [self.contentView addSubview:_txt];
//        _txt.delegate = self;
//        _txt.font = [UIFont systemFontOfSize:14];
//        _txt.textColor = [UIColor EDJGrayscale_11];
//        [_txt mas_makeConstraints:^(MASConstraintMaker *make) {
//            make.left.equalTo(self.item.mas_right).offset(marginTen);
//            make.right.equalTo(self.contentView.mas_right).offset(-marginTen);
//            make.top.equalTo(self.contentView.mas_top).offset(marginFive);
//            make.bottom.equalTo(self.contentView.mas_bottom).offset(-marginFive);
//            make.height.mas_equalTo(34);
//        }];

#pragma mark - UITextViewDelegate
//- (void)textViewDidBeginEditing:(UITextView *)textView{
//    /// 1.记录初始行高
//    _lineHeight = textView.font.lineHeight;
//}
//- (void)textViewDidChange:(UITextView *)textView{
//    self.model.content = textView.text;
//    CGSize textSize = [textView.text sizeOfTextWithMaxSize:CGSizeMake(textView.size.width, MAXFLOAT) font:textView.font];
//    /// 2.实时计算文本内容的高度,并返回当前行数
//    [self currentLine:textSize];
//
//}

//- (void)currentLine:(CGSize)textSize{
//    int line = textSize.height / _lineHeight;
//    if ([self.delegate respondsToSelector:@selector(userInputContenLineFeed:
//                                                    textView:
//                                                    lineCount:
//                                                    singleHeight:
//                                                    reloadCallBack:)]) {
//        [self.delegate userInputContenLineFeed:self textView:_txt lineCount:line singleHeight:_lineHeight reloadCallBack:^(UITextView *currentTextView, CGFloat textHeight) {
////            [self.txt becomeFirstResponder];
////            [currentTextView mas_updateConstraints:^(MASConstraintMaker *make) {
////
////            }];
//        }];
//
//    }
//}
