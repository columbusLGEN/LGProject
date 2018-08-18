//
//  DJDisUploadTextView.m
//  HBDJProj
//
//  Created by Peanut Lee on 2018/8/18.
//  Copyright © 2018年 Lee. All rights reserved.
//

#import "DJDisUploadTextView.h"
#import "UITextView+Extension.h"

@interface DJDisUploadTextView ()
@property (weak,nonatomic) UIView *colorLump;

@end

@implementation DJDisUploadTextView

- (instancetype)initWithFrame:(CGRect)frame{
    if (self = [super initWithFrame:frame]) {
        
        UIView *colorLump = UIView.new;
        _colorLump = colorLump;
        _colorLump.backgroundColor = UIColor.EDJMainColor;
        [self addSubview:_colorLump];
        [_colorLump mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.mas_top).offset(marginFifteen);
            make.left.equalTo(self.mas_left).offset(marginTwelve);
            make.height.mas_equalTo(marginTwenty);
            make.width.mas_equalTo(3);
        }];
        
        UITextView *textView = UITextView.new;
        _textView = textView;
        [self addSubview:_textView];
        [_textView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(_colorLump.mas_top).offset(-marginFive);
            make.left.equalTo(_colorLump.mas_right).offset(marginTen);
            make.right.equalTo(self.mas_right).offset(-marginTen);
            make.height.mas_equalTo(60);
        }];
        
        NSInteger font = 15;
        [_textView lg_setplaceHolderTextWithText:@"你的描述内容时" textColor:UIColor.EDJGrayscale_A4 font:font];
        _textView.font = [UIFont systemFontOfSize:font];
        _textView.textColor = UIColor.EDJGrayscale_11;
        [_textView sizeToFit];
        
        
    }
    return self;
}

@end
