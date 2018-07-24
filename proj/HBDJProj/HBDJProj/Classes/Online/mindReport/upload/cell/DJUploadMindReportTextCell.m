//
//  DJUploadMindReportTextCell.m
//  HBDJProj
//
//  Created by Peanut Lee on 2018/7/21.
//  Copyright © 2018年 Lee. All rights reserved.
//

#import "DJUploadMindReportTextCell.h"
#import "DJUploadMindReportLineModel.h"

@interface DJUploadMindReportTextCell ()
@property (weak,nonatomic) UILabel *content;

@end

@implementation DJUploadMindReportTextCell

- (void)setModel:(DJUploadMindReportLineModel *)model{
    [super setModel:model];
    _content.text = model.content?model.content:@" ";
}

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        
        [self.colorLump mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.contentView.mas_top).offset(marginTen);
            make.left.equalTo(self.contentView.mas_left).offset(marginTwelve);
            make.height.mas_equalTo(marginFifteen);
            make.width.mas_equalTo(3);
        }];
        
        UILabel *content = UILabel.new;
        _content = content;
        [self.contentView addSubview:_content];
        _content.textColor = UIColor.EDJGrayscale_11;
        _content.font = [UIFont systemFontOfSize:17];
        _content.textAlignment = NSTextAlignmentLeft;
        _content.numberOfLines = 0;
        
        [_content mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.title.mas_right).offset(marginEight);
            make.top.equalTo(self.colorLump.mas_top);
            make.right.equalTo(self.contentView.mas_right).offset(-marginTen);
            make.bottom.equalTo(self.contentView.mas_bottom).offset(-marginTen);
            make.width.mas_equalTo(kScreenWidth - 90);
        }];
        
    }
    return self;
}

- (void)layoutSubviews{
    [super layoutSubviews];
    
}

@end
