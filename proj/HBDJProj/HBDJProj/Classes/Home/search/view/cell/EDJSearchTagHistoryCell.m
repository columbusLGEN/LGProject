//
//  EDJSearchTagHistoryCell.m
//  HBDJProj
//
//  Created by Peanut Lee on 2018/4/25.
//  Copyright © 2018年 Lee. All rights reserved.
//

#import "EDJSearchTagHistoryCell.h"
#import "EDJSearchTagModel.h"

@interface EDJSearchTagHistoryCell ()
@property (weak, nonatomic) IBOutlet UIButton *tagButton;

@end

@implementation EDJSearchTagHistoryCell

- (void)setModel:(EDJSearchTagModel *)model{
    [super setModel:model];
    [_tagButton setTitle:model.name forState:UIControlStateNormal];
    
}

- (void)awakeFromNib{
    [super awakeFromNib];
    [self.tagButton setBackgroundColor:[UIColor whiteColor]];
    _tagButton.userInteractionEnabled = NO;
}

- (void)layoutSubviews{
    [super layoutSubviews];
    [self.tagButton cutBorderWithBorderWidth:1 borderColor:[UIColor EDJMainColor] cornerRadius:self.tagButton.height * 0.5];
    [self.tagButton setTitleColor:[UIColor EDJMainColor] forState:UIControlStateNormal];

    
}

@end
