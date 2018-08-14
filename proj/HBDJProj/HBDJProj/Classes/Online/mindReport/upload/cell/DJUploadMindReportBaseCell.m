//
//  DJUploadMindReportBaseCell.m
//  HBDJProj
//
//  Created by Peanut Lee on 2018/7/21.
//  Copyright © 2018年 Lee. All rights reserved.
//

#import "DJUploadMindReportBaseCell.h"
#import "DJUploadMindReportLineModel.h"

@implementation DJUploadMindReportBaseCell

+ (NSString *)cellReuseIdWithModel:(DJUploadMindReportLineModel *)model{
    switch (model.lineType) {
        case DJUploadMindReportLineTypeText:
            return uploadMRTextCell;
            break;
        case DJUploadMindReportLineTypeCover:
            return uploadMRAddCoverCell;
            break;
        case DJUploadMindReportLineTypeImage:
            return uploadMRAddImageCell;
            break;
        case DJUploadMindReportLineTypePyqImage:
            return uploadPYQImageCell;
            break;
        case DJUploadMindReportLineTypePyqText:
            return uploadPYQTextCell;
            break;
    }
}

- (void)setModel:(DJUploadMindReportLineModel *)model{
    _model = model;
    
    _title.text = [model.itemName stringByAppendingString:@" : "];
    
}

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        UIView *colorLump = UIView.new;
        _colorLump = colorLump;
        UILabel *title = UILabel.new;
        _title = title;
        UIView *line = UIView.new;
        _line = line;
        
        [self.contentView addSubview:_colorLump];
        [self.contentView addSubview:_title];
        [self.contentView addSubview:_line];
        
        [_colorLump mas_makeConstraints:^(MASConstraintMaker *make) {
//            make.top.equalTo(self.contentView.mas_top).offset(marginTen);
            make.centerY.equalTo(self.contentView.mas_centerY);
            make.left.equalTo(self.contentView.mas_left).offset(marginTwelve);
            make.height.mas_equalTo(marginFifteen);
            make.width.mas_equalTo(3);
        }];
        [_title mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.equalTo(_colorLump.mas_centerY);
            make.left.equalTo(_colorLump.mas_right).offset(marginEight);
//            make.width.mas_equalTo(50);
        }];
        [_line mas_makeConstraints:^(MASConstraintMaker *make) {
            make.height.mas_equalTo(1);
            make.left.equalTo(self.contentView.mas_left);
            make.right.equalTo(self.contentView.mas_right);
            make.bottom.equalTo(self.contentView.mas_bottom);
        }];
        
        [_title sizeToFit];
        _colorLump.backgroundColor = UIColor.EDJMainColor;
        _title.textColor = UIColor.EDJGrayscale_11;
        _title.font = [UIFont systemFontOfSize:17];
        _line.backgroundColor = UIColor.EDJGrayscale_F3;
        
    }
    return self;
}

@end
