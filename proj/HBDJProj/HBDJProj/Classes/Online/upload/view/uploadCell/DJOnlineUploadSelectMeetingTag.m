//
//  DJOnlineUploadSelectMeetingTag.m
//  HBDJProj
//
//  Created by Peanut Lee on 2018/7/7.
//  Copyright © 2018年 Lee. All rights reserved.
//

#import "DJOnlineUploadSelectMeetingTag.h"
#import "DJOnlineUploadTableModel.h"

@interface DJOnlineUploadSelectMeetingTag ()
@property (weak,nonatomic) UILabel *meetingTag;

@end


@implementation DJOnlineUploadSelectMeetingTag

@synthesize model = _model;

- (void)setModel:(DJOnlineUploadTableModel *)model{
    [super setModel:model];
    _meetingTag.text = model.content;
}

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        UILabel *lbl = UILabel.new;
        _meetingTag = lbl;
        [self.contentView addSubview:_meetingTag];
        _meetingTag.textColor = [UIColor EDJGrayscale_11];
        _meetingTag.font = [UIFont systemFontOfSize:15];
        
        UIImageView *arrowRight = [[UIImageView alloc]
                                   initWithImage:[UIImage
                                                  imageNamed:@"home_digital_book_info_arrow_up"]];
        arrowRight.contentMode = UIViewContentModeScaleAspectFit;
        arrowRight.transform = CGAffineTransformMakeRotation(M_PI * 0.5);
        [self.contentView addSubview:arrowRight];
        
        [arrowRight mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.equalTo(self.contentView.mas_right).offset(-marginTen);
            make.centerY.equalTo(self.contentView.mas_centerY);
            make.width.mas_equalTo(8);
            make.height.mas_equalTo(20);
        }];
        
        [_meetingTag mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.equalTo(arrowRight.mas_left).offset(-marginFive);
            make.centerY.equalTo(self.contentView.mas_centerY);
        }];
        
        
    }
    return self;
}

@end
