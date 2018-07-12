//
//  HPBookInfoBriefCell.m
//  HBDJProj
//
//  Created by Peanut Lee on 2018/5/2.
//  Copyright © 2018年 Lee. All rights reserved.
//

#import "HPBookInfoBriefCell.h"
#import "HPBookInfoModel.h"

@interface HPBookInfoBriefCell ()
@property (weak, nonatomic) IBOutlet UILabel *itemTitle;
@property (weak, nonatomic) IBOutlet UILabel *contentLabel;
@property (weak, nonatomic) IBOutlet UIImageView *arrow;
@property (weak, nonatomic) IBOutlet UIButton *button;

@end

@implementation HPBookInfoBriefCell

+ (instancetype)bookinfoBreifCell{
    return [[[NSBundle mainBundle] loadNibNamed:bookinfoBriefCell owner:nil options:nil] lastObject];
}

- (void)setModel:(HPBookInfoModel *)model{
    _model = model;
    
    _itemTitle.text = model.itemTitle;
    _contentLabel.text = model.content;
    
    _button.selected = model.showAll;
    if (model.showAll) {
        _arrow.transform = CGAffineTransformMakeRotation(M_PI);
        _contentLabel.numberOfLines = 0;
    }else{
        _arrow.transform = CGAffineTransformIdentity;
        _contentLabel.numberOfLines = 3;
    }
}

- (IBAction)showAllClick:(UIButton *)sender {
    _model.showAll = !_model.showAll;
    if ([self.delegate respondsToSelector:@selector(bibCellShowAllButtonClick:)]) {
        [self.delegate bibCellShowAllButtonClick:self];
    }
}

- (void)awakeFromNib {
    [super awakeFromNib];
    
}


@end
