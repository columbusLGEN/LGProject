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
    
    NSString *desContent = [model.username stringByAppendingString:[NSString stringWithFormat:@": %@",model.comment]];
    NSDictionary *attrDict = @{NSForegroundColorAttributeName:[UIColor EDJColor_6CBEFC]};
    
    NSMutableAttributedString *desAttContent = [[NSMutableAttributedString alloc] initWithString:desContent];
    
    NSString *blueString = [model.username stringByAppendingString:@":"];
    [desAttContent setAttributes:attrDict range:NSMakeRange([desContent rangeOfString:blueString].location, [desContent rangeOfString:blueString].length)];
    
    _content.attributedText = desAttContent;
}

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        self.backgroundColor = [UIColor EDJGrayscale_F5];
        [self.contentView addSubview:self.content];
        [self.content mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.contentView.mas_left).offset(marginFive);
            make.right.equalTo(self.contentView.mas_right).offset(-marginFive);
            make.top.equalTo(self.contentView.mas_top);
            make.bottom.equalTo(self.contentView.mas_bottom);
        }];
    }
    return self;
}

- (UILabel *)content{
    if (!_content){
        _content = [UILabel new];
        _content.font = [UIFont systemFontOfSize:14];
        _content.numberOfLines = 0;
    }
    return _content;
}

@end
