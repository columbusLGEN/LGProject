//
//  DCSubStageCommentsCell.m
//  HBDJProj
//
//  Created by Peanut Lee on 2018/5/21.
//  Copyright © 2018年 Lee. All rights reserved.
//

#import "DCSubStageCommentsCell.h"
#import "DCSubStageCommentsModel.h"

@interface DCSubStageCommentsCell ()
@property (strong,nonatomic) UILabel *content;

@end

@implementation DCSubStageCommentsCell

- (void)setModel:(DCSubStageCommentsModel *)model{
    _model = model;
    
    _content.attributedText = model.fullCommentString;
}

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        self.backgroundColor = [UIColor EDJGrayscale_F5];
        [self.contentView addSubview:self.content];
        [self.content mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.contentView.mas_left).offset(marginFive);
            make.right.equalTo(self.contentView.mas_right).offset(-marginFive);
            make.top.equalTo(self.contentView.mas_top).offset(marginFive);
            make.bottom.equalTo(self.contentView.mas_bottom).offset(-marginFive);
        }];
    }
    return self;
}

- (UILabel *)content{
    if (!_content){
        _content = [UILabel new];
        _content.font = [UIFont systemFontOfSize:14];
//        _content.preferredMaxLayoutWidth = kScreenWidth - 45;
        _content.numberOfLines = 0;
    }
    return _content;
}

@end
