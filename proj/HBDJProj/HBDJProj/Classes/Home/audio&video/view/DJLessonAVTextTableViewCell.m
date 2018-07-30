//
//  DJLessonAVTextTableViewCell.m
//  HBDJProj
//
//  Created by Peanut Lee on 2018/7/30.
//  Copyright © 2018年 Lee. All rights reserved.
//

#import "DJLessonAVTextTableViewCell.h"
#import "DJCoreTextViewManager.h"
#import "LGAttributedTextView.h"
#import "DJDataBaseModel.h"

@interface DJLessonAVTextTableViewCell ()
@property (weak,nonatomic) LGAttributedTextView *rtv;

@end

@implementation DJLessonAVTextTableViewCell

- (void)setModel:(DJDataBaseModel *)model{
    _model = model;
    NSLog(@"富文本字符串: %@",model.content);
    [DJCoreTextViewManager.new viewWithRichText:model.content completion:^(LGAttributedTextView *view) {
        _rtv = view;
    }];
}

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        LGAttributedTextView *rtv = LGAttributedTextView.new;
        _rtv = rtv;
        [self.contentView addSubview:_rtv];
        [_rtv mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.contentView.mas_top).offset(marginEight);
            make.left.equalTo(self.contentView.mas_left).offset(marginEight);
            make.right.equalTo(self.contentView.mas_right).offset(-marginEight);
            make.bottom.equalTo(self.contentView.mas_bottom).offset(-marginEight);
        }];
    }
    return self;
}

@end
