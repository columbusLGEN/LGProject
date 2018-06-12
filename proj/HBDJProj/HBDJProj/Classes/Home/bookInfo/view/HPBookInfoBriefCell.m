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

@property (strong,nonatomic) HPBookInfoModel *subModel;

@end

@implementation HPBookInfoBriefCell

- (void)setModel:(HPBookInfoModel *)model{
    _subModel = model;
    _itemTitle.text = model.itemTitle;
    _contentLabel.text = model.content;
}

- (IBAction)showAllClick:(id)sender {
    if (_subModel.showAll) {
        _subModel.showAll = NO;
        _arrow.transform = CGAffineTransformMakeRotation(M_PI);
    }else{
        _subModel.showAll = YES;
        _arrow.transform = CGAffineTransformIdentity;
    }
    if ([self.delegate respondsToSelector:@selector(bibCellShowAllButtonClick)]) {
        [self.delegate bibCellShowAllButtonClick];
    }
}

- (void)awakeFromNib {
    [super awakeFromNib];
    
}


@end
